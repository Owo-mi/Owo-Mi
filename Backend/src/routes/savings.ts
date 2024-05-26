import {Router} from "express"
import {TransactionBlock} from "@mysten/sui.js/transactions"
import {SuiClient} from "@mysten/sui.js/client"
import {MOVE_STDLIB_ADDRESS, SUI_CLOCK_OBJECT_ID,} from "@mysten/sui.js/utils"
import {new_ as newSaving, newSavingTarget, share, transferCap} from "../../generated/owomi/saving/functions";
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

router.get("/savings", async (req, res) => {
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

router.post("/savings/:id/deposit", async (req, res) => {
    const {
        coinType,
        amount,
        savingCap,
        address // current user address, idk if we have it from the auth header?
    } = req.body;

    const txb = new TransactionBlock()

    // TODO: fetch the user's coin objects

    // TODO: prepare the coin objects for the deposit

    // TODO: make the necessary move calls

    return res.json({status: "success", data: txb.serialize()})
})

export default router;