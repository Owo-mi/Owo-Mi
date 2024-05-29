import {Router} from "express"
import {TransactionBlock} from "@mysten/sui.js/transactions"
import {SuiClient} from "@mysten/sui.js/client"
import {MOVE_STDLIB_ADDRESS, SUI_CLOCK_OBJECT_ID, SUI_TYPE_ARG} from "@mysten/sui.js/utils"
import {bcs} from "@mysten/sui.js/bcs"
import {fromB64} from "@mysten/bcs"
import {
    deposit,
    new_ as newSaving,
    newAuthorizedCap,
    newSavingTarget,
    revokeCap,
    share,
    transferCap,
    withdraw
} from "../../generated/owomi/saving/functions";
import {SavingCap} from "../../generated/owomi/saving/structs";

const router = Router();
const client = new SuiClient({url: "https://fullnode.testnet.sui.io:443"})

router.post('/', async (req, res) => {
    const txb = new TransactionBlock()
    const {
        coinType, name, description, target,
        address // current user address, idk if we have it from the auth header?
    } = req.body;

    // since the saving target could be optional, we construct an optional target by calling the move std option module
    const savingTarget = target ?
        txb.moveCall({
            target: `${MOVE_STDLIB_ADDRESS}::option::some`,
            arguments: [newSavingTarget(txb, {date: target.date, amount: target.amount})]
        }) : txb.moveCall({target: `${MOVE_STDLIB_ADDRESS}::option::none`})

    // Create a new savings, we pass in the details
    // - name: string
    // - description: string
    // - target: move struct (we created it above)
    // - clock: sui clock object id

    // the coin type: the coin type of the saving e.g 0x2::sui::SUI

    // the newSaving function returns the saving itself, and the saving cap
    const [saving, savingCap] = newSaving(txb, coinType, {
        name,
        description,
        target: savingTarget,
        clock: SUI_CLOCK_OBJECT_ID
    })

    // publish the saving as a shared object
    share(txb, coinType, saving)

    // transfer the saving cap to the user
    transferCap(txb, {cap: savingCap, recipient: address})

    return res.json({status: "success", data: txb.serialize()})
});

router.get("", async (req, res) => {
    const address = req.query.address
    if (!address) {
        return res.status(404).json({message: 'Owner address is required'})
    }

    // We can use the savings cap transferred to the user to get the user savings, so we will fetch the users SavingCaps
    const capObjects = await client.getOwnedObjects({
        limit: 50,
        owner: address as string,
        options: {showContent: true},
        filter: {StructType: SavingCap.$typeName},
    })

    // map all caps to the saving they're associated with
    const ids = capObjects.data.map((data) => {
        if (data.data?.content?.dataType === "moveObject") {
            return (data.data.content.fields as Record<string, string>).saving
        }
    }).filter(Boolean) as string[]

    // now fetch the saving objects using the saving we mapped to from above
    const savingObjects = await client.multiGetObjects({ids, options: {showContent: true}})
    const savings = savingObjects.map((data) => {
        if (data.data?.content?.dataType === "moveObject") {
            return data.data.content.fields as Record<string, string>
        }
    }).filter(Boolean)

    return res.json({status: "success", data: savings})
})

router.post("/:id/deposit", async (req, res) => {
    const {
        coinType,
        amount,
        savingCap,
        address // current user address, idk if we have it from the auth header?
    } = req.body;

    const txb = new TransactionBlock()

    // TODO: fetch the user's coin objects
    const {total, objects} = await getCoinsForSaving(address, amount, coinType)
    if (total == BigInt(0)) {
        return res.json({status: "error", message: `Insufficient coin objects for ${coinType}`})
    }

    // Prepare coins for deposit
    let depositCoin
    if (coinType == SUI_TYPE_ARG) {
        [depositCoin] = txb.splitCoins(txb.gas, [amount]);
    }

    const primaryCoin = txb.object(objects.pop()!);
    if (objects.length > 0) {
        txb.mergeCoins(primaryCoin, objects.map(txb.object));
    }

    if (total > amount) {
        [depositCoin] = txb.splitCoins(primaryCoin, [amount]);
    }

    deposit(txb, coinType, {
        cap: savingCap,
        coin: depositCoin ?? primaryCoin,
        self: txb.object(req.params.id)
    })

    return res.json({status: "success", data: txb.serialize()})
})

router.post("/:id/withdraw", (req, res) => {
    const {
        coinType,
        amount,
        savingCap,
        address // current user address, idk if we have it from the auth header?
    } = req.body;
    const txb = new TransactionBlock()

    const [coin] = withdraw(txb, coinType, {
        cap: savingCap,
        amount: amount,
        self: txb.object(req.params.id),
        clock: txb.object(SUI_CLOCK_OBJECT_ID),
    })
    txb.transferObjects([coin], address)

    return res.json({status: "success", data: txb.serialize()})
})

router.post("/:id/authorize", (req, res) => {
    const {
        coinType,
        recipient // current user address, idk if we have it from the auth header?
    } = req.body;
    const txb = new TransactionBlock()

    const [cap] = newAuthorizedCap(txb, coinType, txb.object(req.params.id))
    txb.transferObjects([cap], recipient)

    return res.json({status: "success", data: txb.serialize()})
})

router.post("/:id/revoke", (req, res) => {
    const {
        coinType,
        savingCap,
        recipient // current user address, idk if we have it from the auth header?
    } = req.body;
    const txb = new TransactionBlock()
    revokeCap(txb, coinType, {self: txb.object(req.params.id), cap: savingCap})

    return res.json({status: "success", data: txb.serialize()})
})

export default router;

const CoinStruct = bcs.struct("CoinStruct", {
    id: bcs.Address,
    balance: bcs.u64()
})

const getCoinsForSaving = async (
    address: string,
    amount: bigint,
    coinType: string
) => {
    let {total, objects}: { total: bigint, objects: string[] } = {total: BigInt(0), objects: []}
    let hasNext: boolean = true;
    let cursor: string | undefined | null = null;

    while (hasNext) {
        const {hasNextPage, nextCursor, data} = await client.getOwnedObjects({
            owner: address,
            cursor,
            options: {showBcs: true},
            filter: {StructType: `0x2::coin::Coin<${coinType}>`}
        })

        for (const object of data) {
            if (object.data?.bcs?.dataType !== "moveObject") continue;
            const coinData = CoinStruct.parse(fromB64(object.data.bcs.bcsBytes))
            total += BigInt(coinData.balance)
            objects.push(coinData.id)
        }

        if (total >= amount) {
            hasNext = false
            cursor = null
            break
        }

        hasNext = hasNextPage
        cursor = nextCursor
    }

    if (total < amount) {
        return {total: BigInt(0), objects: []}
    }

    return {total, objects}
};

