import client from "../suiClient"; 
import { TransactionArgument, TransactionBlock } from "@mysten/sui.js/transactions";

// owo-mi funds functions
import { AuthorizedCapIndexArgs, DeleteCapArgs, DepositArgs, RevokeCapArgs, authorizedCapIndex, balance, deleteCap, deposit, newAuthorizedCap, newCap, new_, revokeCap } from "../sui-gen/owo-mi-package/fund/functions";

// owo-mi funds struct
import { Fund } from "../sui-gen/owo-mi-package/fund/structs";

export async function get_balance(){

    const txb = new TransactionBlock();
    const TypeArg = "TypeArg"; // ?
    const fund = ObjectArg; //?

    return balance(txb, TypeArg, fund);
}

export async function create_fund(){

    const txb = new TransactionBlock();

    return new_(txb);
}

export async function deposit_fund() {

    const txb = new TransactionBlock();
    const TypeArg = "TypeArg"; // ?
    const args: DepositArgs = {
        fund: ObjectArg, //?
        coin: ObjectArg  //?
    }

    return deposit(txb, TypeArg, args);
}

export async function new_cap(){

    const txb = new TransactionBlock();
    const fund = ObjectArg; //?

    return newCap(txb, fund);
}

export async function new_auth_cap(){
    
    const txb = new TransactionBlock();
    const fund = ObjectArg; //?

    return newAuthorizedCap(txb, fund);
}

export async function revoke_cap(cap_id: string | TransactionArgument){
    
    const txb = new TransactionBlock();
    const args: RevokeCapArgs =  {
        fund: ObjectArg, //?
        id: cap_id
        
    }   
    
    return revokeCap(txb, args)
}

export async function delete_cap(){
    
    const txb = new TransactionBlock();
    const args: DeleteCapArgs = {
        fund: ObjectArg, //?
        fundCap: ObjectArg //?
    }
    return deleteCap(txb, args)
}

export async function auth_cap_index(cap_id_index: string | TransactionArgument){

    const txb = new TransactionBlock();
    const args: AuthorizedCapIndexArgs = {
        fund: ObjectArg, // ?
        id: cap_id_index
    }

    return authorizedCapIndex(txb, args)

}