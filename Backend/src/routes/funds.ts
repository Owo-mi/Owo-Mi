import {Router} from "express"
import {TransactionBlock} from "@mysten/sui.js/transactions"
import {SuiClient} from "@mysten/sui.js/client"
import {new_ as newFund, newAuthorizedCap, revokeCap, share, transferCap} from "../../generated/owomi/fund/functions";
import {FundCap} from "../../generated/owomi/fund/structs";

const router = Router();
const client = new SuiClient({url: "https://fullnode.testnet.sui.io:443"})

router.post('/', async (req, res) => {
    const txb = new TransactionBlock()
    const {
        address // current user address, idk if we have it from the auth header?
    } = req.body;

    const [fund] = newFund(txb)
    const [cap] = newAuthorizedCap(txb, fund)

    share(txb, fund)
    transferCap(txb, {cap, recipient: address})

    return res.json({status: "success", data: txb.serialize()})
});

router.get("/", async (req, res) => {
    const address = req.query.address
    if (!address) {
        return res.status(404).json({message: 'Owner address is required'})
    }

    const capObjects = await client.getOwnedObjects({
        limit: 50,
        owner: address as string,
        options: {showContent: true},
        filter: {StructType: FundCap.$typeName},
    })

    // map all caps to the fund they're associated with
    const ids = capObjects.data.map((data) => {
        if (data.data?.content?.dataType === "moveObject") {
            return (data.data.content.fields as Record<string, string>).fund
        }
    }).filter(Boolean) as string[]

    // now fetch the fund objects using the fund we mapped to from above
    const fundObjects = await client.multiGetObjects({ids, options: {showContent: true}})
    const funds = fundObjects.map((data) => {
        if (data.data?.content?.dataType === "moveObject") {
            return data.data.content.fields as Record<string, string>
        }
    }).filter(Boolean)

    return res.json({status: "success", data: funds})
})

router.post("/:id/authorize", (req, res) => {
    const {
        recipient // current user address, idk if we have it from the auth header?
    } = req.body;
    const txb = new TransactionBlock()

    const [cap] = newAuthorizedCap(txb, txb.object(req.params.id))
    txb.transferObjects([cap], recipient)

    return res.json({status: "success", data: txb.serialize()})
})

router.post("/:id/revoke", (req, res) => {
    const {fundCap} = req.body;
    const txb = new TransactionBlock()
    revokeCap(txb, {self: txb.object(req.params.id), cap: fundCap})

    return res.json({status: "success", data: txb.serialize()})
})

export default router;
