import client from "../suiClient"; 
import { TransactionArgument, TransactionBlock } from "@mysten/sui.js/transactions";

// owo-mi functions
import { newAuthorizedCap, RevokeCapArgs, revokeCap, NewArgs,AuthorizedCapIndexArgs, DeleteCapArgs, DepositFromFundArgs, NewSavingTargetArgs, TransferCapArgs, WithdrawToFundArgs, authorizedCapIndex, deleteCap, depositFromFund, newSavingCap, newSavingTarget, new_, transferCap, withdrawToFund, TransferArgs, transfer, WithdrawArgs, withdraw } from "../sui-gen/owo-mi-package/saving/functions";

//structs
import { Saving, SavingCap } from "../sui-gen/owo-mi-package/saving/structs";

export async function create_new_savings(savings_name: string, address: string, desc: string, zksign: string) {
    const txb = new TransactionBlock();
    const typeArg = "TypeArg"; // dont quite understand 
    
    const args: NewArgs = {
        string1: savings_name,
        string2: address,
        option: null,  // SavingTarget if it exists, otherwise, it's null
        clock:   // dont know man
    };

    return new_(txb, typeArg, args);
}

export async function transfer_saving(address: string | TransactionArgument){
    const txb = new TransactionBlock();
    const TypeArg = "TypeArg"; // ?
    
    const args: TransferArgs = {
        saving: ObjectArg, // ?
        address: address
    }
    return transfer(txb, TypeArg, args)
}

export async function withdraw_saving(){
    const txb = new TransactionBlock();
    const TypeArg = "TypeArg"; // ?

    const args: WithdrawArgs = {
        saving: ObjectArg, // ?
        savingCaP: ObjectArg, // ?
        option: null,  // ?
        clock: ObjectArg // ?
    }

    return withdraw(txb, TypeArg, args)
}

export async function create_auth_cap() {
    const txb = new TransactionBlock();
    const typeArg = "TypeArg"; // dont quite understand 

    return newAuthorizedCap(txb, typeArg, saving)
}

export async function revoke_auth_cap(revoke_id: string | TransactionArgument) {
    const txb = new TransactionBlock();
    const typeArg = "TypeArg"; // dont quite understand 
    const args: RevokeCapArgs = {
        saving: saving, // dont get how to Call Saving object args
        id: revoke_id
    }
    return revokeCap(txb, typeArg, args)
}

export async function del_cap() {
    const txb = new TransactionBlock();
    const typeArg = "TypeArg"; // dont quite understand 
    const args: DeleteCapArgs ={
        saving: saving,// ?
        savingCap: savingCap // ?
    }
    return deleteCap(txb, typeArg, args)
}

export async function auth_cap_index( id_cap: string | TransactionArgument) {
    const txb = new TransactionBlock();
    const TypeArg = "TypeArg";// ?
    const args: AuthorizedCapIndexArgs = {
        saving: saving,// ?
        id : id_cap
    }
    return authorizedCapIndex(txb, TypeArg, args)

}

export async function new_saving_cap(){
    const txb = new TransactionBlock();
    const TypeArg = "TypeArg";// ?
    const saving = savingObj// ?
 
    return newSavingCap(txb, TypeArg, saving)
}

export async function new_saving_target(){
    const txb = new TransactionBlock();
    const args: NewSavingTargetArgs = {
        u641 :  ,// ?
        u642 : //?
    }

    return newSavingTarget(txb, args)
}

export async function transfer_cap(address: string | TransactionArgument){
    const txb = new TransactionBlock();
    const args: TransferCapArgs = {
        savingCap: ObjectCap,// ?
        address: address
    }

    return transferCap(txb, args)
}

export async function deposit_from_fund(){
    const txb = new TransactionBlock();
    const TypeArg = "TypeArg";// ?

    const args:  DepositFromFundArgs = {
        saving: ObjectCap,// ?
        fund: ObjectCap,// ?
        savingCap: ObjectCap,// ?
        fundCap: ObjectCap,// ?
        u64: // ?
    }
    return depositFromFund(txb, TypeArg, args)
}

export async function withdraw_to_fund(){
    const txb = new TransactionBlock();
    const TypeArg = "TypeArg";// ?

    const args: WithdrawToFundArgs = {
        saving: ObjectCap,// ?
        fund: ObjectCap,// ?
        savingCap: ObjectCap,// ?
        option: null,  // ?
        clock: ObjectCap // ?
    }
    return withdrawToFund(txb, TypeArg, args)
}