import {PUBLISHED_AT} from "..";
import {ObjectArg, obj, option, pure} from "../../_framework/util";
import {TransactionArgument, TransactionBlock} from "@mysten/sui.js/transactions";

export interface NewArgs { string1: string | TransactionArgument; string2: string | TransactionArgument; option: (ObjectArg | TransactionArgument | null); clock: ObjectArg }

export function new_( txb: TransactionBlock, typeArg: string, args: NewArgs ) { return txb.moveCall({ target: `${PUBLISHED_AT}::saving::new`, typeArguments: [typeArg], arguments: [ pure(txb, args.string1, `0x1::string::String`), pure(txb, args.string2, `0x1::string::String`), option(txb, `0x711a02c4e2ba28fce3d9c095a259f622b0502bfc1b96e77b6c0dc136199729f::saving::SavingTarget`, args.option), obj(txb, args.clock) ], }) }

export interface TransferArgs { saving: ObjectArg; address: string | TransactionArgument }

export function transfer( txb: TransactionBlock, typeArg: string, args: TransferArgs ) { return txb.moveCall({ target: `${PUBLISHED_AT}::saving::transfer`, typeArguments: [typeArg], arguments: [ obj(txb, args.saving), pure(txb, args.address, `address`) ], }) }

export interface WithdrawArgs { saving: ObjectArg; savingCap: ObjectArg; option: (bigint | TransactionArgument | TransactionArgument | null); clock: ObjectArg }

export function withdraw( txb: TransactionBlock, typeArg: string, args: WithdrawArgs ) { return txb.moveCall({ target: `${PUBLISHED_AT}::saving::withdraw`, typeArguments: [typeArg], arguments: [ obj(txb, args.saving), obj(txb, args.savingCap), pure(txb, args.option, `0x1::option::Option<u64>`), obj(txb, args.clock) ], }) }

export interface DepositArgs { saving: ObjectArg; savingCap: ObjectArg; coin: ObjectArg }

export function deposit( txb: TransactionBlock, typeArg: string, args: DepositArgs ) { return txb.moveCall({ target: `${PUBLISHED_AT}::saving::deposit`, typeArguments: [typeArg], arguments: [ obj(txb, args.saving), obj(txb, args.savingCap), obj(txb, args.coin) ], }) }

export function newAuthorizedCap( txb: TransactionBlock, typeArg: string, saving: ObjectArg ) { return txb.moveCall({ target: `${PUBLISHED_AT}::saving::new_authorized_cap`, typeArguments: [typeArg], arguments: [ obj(txb, saving) ], }) }

export interface RevokeCapArgs { saving: ObjectArg; id: string | TransactionArgument }

export function revokeCap( txb: TransactionBlock, typeArg: string, args: RevokeCapArgs ) { return txb.moveCall({ target: `${PUBLISHED_AT}::saving::revoke_cap`, typeArguments: [typeArg], arguments: [ obj(txb, args.saving), pure(txb, args.id, `0x2::object::ID`) ], }) }

export interface DeleteCapArgs { saving: ObjectArg; savingCap: ObjectArg }

export function deleteCap( txb: TransactionBlock, typeArg: string, args: DeleteCapArgs ) { return txb.moveCall({ target: `${PUBLISHED_AT}::saving::delete_cap`, typeArguments: [typeArg], arguments: [ obj(txb, args.saving), obj(txb, args.savingCap) ], }) }

export interface AuthorizedCapIndexArgs { saving: ObjectArg; id: string | TransactionArgument }

export function authorizedCapIndex( txb: TransactionBlock, typeArg: string, args: AuthorizedCapIndexArgs ) { return txb.moveCall({ target: `${PUBLISHED_AT}::saving::authorized_cap_index`, typeArguments: [typeArg], arguments: [ obj(txb, args.saving), pure(txb, args.id, `0x2::object::ID`) ], }) }

export function newSavingCap( txb: TransactionBlock, typeArg: string, saving: ObjectArg ) { return txb.moveCall({ target: `${PUBLISHED_AT}::saving::new_saving_cap`, typeArguments: [typeArg], arguments: [ obj(txb, saving) ], }) }

export interface NewSavingTargetArgs { u641: bigint | TransactionArgument; u642: bigint | TransactionArgument }

export function newSavingTarget( txb: TransactionBlock, args: NewSavingTargetArgs ) { return txb.moveCall({ target: `${PUBLISHED_AT}::saving::new_saving_target`, arguments: [ pure(txb, args.u641, `u64`), pure(txb, args.u642, `u64`) ], }) }

export interface TransferCapArgs { savingCap: ObjectArg; address: string | TransactionArgument }

export function transferCap( txb: TransactionBlock, args: TransferCapArgs ) { return txb.moveCall({ target: `${PUBLISHED_AT}::saving::transfer_cap`, arguments: [ obj(txb, args.savingCap), pure(txb, args.address, `address`) ], }) }

export interface DepositFromFundArgs { saving: ObjectArg; fund: ObjectArg; savingCap: ObjectArg; fundCap: ObjectArg; u64: bigint | TransactionArgument }

export function depositFromFund( txb: TransactionBlock, typeArg: string, args: DepositFromFundArgs ) { return txb.moveCall({ target: `${PUBLISHED_AT}::saving::deposit_from_fund`, typeArguments: [typeArg], arguments: [ obj(txb, args.saving), obj(txb, args.fund), obj(txb, args.savingCap), obj(txb, args.fundCap), pure(txb, args.u64, `u64`) ], }) }

export interface WithdrawToFundArgs { saving: ObjectArg; fund: ObjectArg; savingCap: ObjectArg; option: (bigint | TransactionArgument | TransactionArgument | null); clock: ObjectArg }

export function withdrawToFund( txb: TransactionBlock, typeArg: string, args: WithdrawToFundArgs ) { return txb.moveCall({ target: `${PUBLISHED_AT}::saving::withdraw_to_fund`, typeArguments: [typeArg], arguments: [ obj(txb, args.saving), obj(txb, args.fund), obj(txb, args.savingCap), pure(txb, args.option, `0x1::option::Option<u64>`), obj(txb, args.clock) ], }) }
