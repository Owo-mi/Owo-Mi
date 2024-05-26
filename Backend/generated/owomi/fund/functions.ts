import {PUBLISHED_AT} from "..";
import {ObjectArg, obj, pure} from "../../_framework/util";
import {TransactionArgument, TransactionBlock} from "@mysten/sui.js/transactions";

export function new_( txb: TransactionBlock, ) { return txb.moveCall({ target: `${PUBLISHED_AT}::fund::new`, arguments: [ ], }) }

export function balance( txb: TransactionBlock, typeArg: string, fund: ObjectArg ) { return txb.moveCall({ target: `${PUBLISHED_AT}::fund::balance`, typeArguments: [typeArg], arguments: [ obj(txb, fund) ], }) }

export interface AuthorizedCapIndexArgs { self: ObjectArg; cap: string | TransactionArgument }

export function authorizedCapIndex( txb: TransactionBlock, args: AuthorizedCapIndexArgs ) { return txb.moveCall({ target: `${PUBLISHED_AT}::fund::authorized_cap_index`, arguments: [ obj(txb, args.self), pure(txb, args.cap, `0x2::object::ID`) ], }) }

export interface DeleteCapArgs { self: ObjectArg; cap: ObjectArg }

export function deleteCap( txb: TransactionBlock, args: DeleteCapArgs ) { return txb.moveCall({ target: `${PUBLISHED_AT}::fund::delete_cap`, arguments: [ obj(txb, args.self), obj(txb, args.cap) ], }) }

export interface DepositArgs { fund: ObjectArg; coin: ObjectArg }

export function deposit( txb: TransactionBlock, typeArg: string, args: DepositArgs ) { return txb.moveCall({ target: `${PUBLISHED_AT}::fund::deposit`, typeArguments: [typeArg], arguments: [ obj(txb, args.fund), obj(txb, args.coin) ], }) }

export function newAuthorizedCap( txb: TransactionBlock, fund: ObjectArg ) { return txb.moveCall({ target: `${PUBLISHED_AT}::fund::new_authorized_cap`, arguments: [ obj(txb, fund) ], }) }

export function newCap( txb: TransactionBlock, fund: ObjectArg ) { return txb.moveCall({ target: `${PUBLISHED_AT}::fund::new_cap`, arguments: [ obj(txb, fund) ], }) }

export interface RevokeCapArgs { self: ObjectArg; cap: string | TransactionArgument }

export function revokeCap( txb: TransactionBlock, args: RevokeCapArgs ) { return txb.moveCall({ target: `${PUBLISHED_AT}::fund::revoke_cap`, arguments: [ obj(txb, args.self), pure(txb, args.cap, `0x2::object::ID`) ], }) }

export interface WithdrawArgs { fund: ObjectArg; cap: ObjectArg; amount: bigint | TransactionArgument }

export function withdraw( txb: TransactionBlock, typeArg: string, args: WithdrawArgs ) { return txb.moveCall({ target: `${PUBLISHED_AT}::fund::withdraw`, typeArguments: [typeArg], arguments: [ obj(txb, args.fund), obj(txb, args.cap), pure(txb, args.amount, `u64`) ], }) }
