import {PUBLISHED_AT} from "..";
import {ObjectArg, obj, option, pure} from "../../_framework/util";
import {TransactionArgument, TransactionBlock} from "@mysten/sui.js/transactions";

export interface NewArgs { name: string | TransactionArgument; description: string | TransactionArgument; target: (ObjectArg | TransactionArgument | null); clock: ObjectArg }

export function new_( txb: TransactionBlock, typeArg: string, args: NewArgs ) { return txb.moveCall({ target: `${PUBLISHED_AT}::saving::new`, typeArguments: [typeArg], arguments: [ pure(txb, args.name, `0x1::string::String`), pure(txb, args.description, `0x1::string::String`), option(txb, `0x0::saving::SavingTarget`, args.target), obj(txb, args.clock) ], }) }

export interface AuthorizedCapIndexArgs { self: ObjectArg; cap: string | TransactionArgument }

export function authorizedCapIndex( txb: TransactionBlock, typeArg: string, args: AuthorizedCapIndexArgs ) { return txb.moveCall({ target: `${PUBLISHED_AT}::saving::authorized_cap_index`, typeArguments: [typeArg], arguments: [ obj(txb, args.self), pure(txb, args.cap, `0x2::object::ID`) ], }) }

export interface DeleteCapArgs { self: ObjectArg; cap: ObjectArg }

export function deleteCap( txb: TransactionBlock, typeArg: string, args: DeleteCapArgs ) { return txb.moveCall({ target: `${PUBLISHED_AT}::saving::delete_cap`, typeArguments: [typeArg], arguments: [ obj(txb, args.self), obj(txb, args.cap) ], }) }

export interface DepositArgs { self: ObjectArg; cap: ObjectArg; coin: ObjectArg }

export function deposit( txb: TransactionBlock, typeArg: string, args: DepositArgs ) { return txb.moveCall({ target: `${PUBLISHED_AT}::saving::deposit`, typeArguments: [typeArg], arguments: [ obj(txb, args.self), obj(txb, args.cap), obj(txb, args.coin) ], }) }

export function newAuthorizedCap( txb: TransactionBlock, typeArg: string, self: ObjectArg ) { return txb.moveCall({ target: `${PUBLISHED_AT}::saving::new_authorized_cap`, typeArguments: [typeArg], arguments: [ obj(txb, self) ], }) }

export interface RevokeCapArgs { self: ObjectArg; cap: string | TransactionArgument }

export function revokeCap( txb: TransactionBlock, typeArg: string, args: RevokeCapArgs ) { return txb.moveCall({ target: `${PUBLISHED_AT}::saving::revoke_cap`, typeArguments: [typeArg], arguments: [ obj(txb, args.self), pure(txb, args.cap, `0x2::object::ID`) ], }) }

export function share( txb: TransactionBlock, typeArg: string, self: ObjectArg ) { return txb.moveCall({ target: `${PUBLISHED_AT}::saving::share`, typeArguments: [typeArg], arguments: [ obj(txb, self) ], }) }

export interface TransferCapArgs { cap: ObjectArg; recipient: string | TransactionArgument }

export function transferCap( txb: TransactionBlock, args: TransferCapArgs ) { return txb.moveCall({ target: `${PUBLISHED_AT}::saving::transfer_cap`, arguments: [ obj(txb, args.cap), pure(txb, args.recipient, `address`) ], }) }

export interface WithdrawArgs { self: ObjectArg; cap: ObjectArg; amount: (bigint | TransactionArgument | TransactionArgument | null); clock: ObjectArg }

export function withdraw( txb: TransactionBlock, typeArg: string, args: WithdrawArgs ) { return txb.moveCall({ target: `${PUBLISHED_AT}::saving::withdraw`, typeArguments: [typeArg], arguments: [ obj(txb, args.self), obj(txb, args.cap), pure(txb, args.amount, `0x1::option::Option<u64>`), obj(txb, args.clock) ], }) }

export interface DepositFromFundArgs { self: ObjectArg; fund: ObjectArg; savingCap: ObjectArg; fundCap: ObjectArg; amount: bigint | TransactionArgument }

export function depositFromFund( txb: TransactionBlock, typeArg: string, args: DepositFromFundArgs ) { return txb.moveCall({ target: `${PUBLISHED_AT}::saving::deposit_from_fund`, typeArguments: [typeArg], arguments: [ obj(txb, args.self), obj(txb, args.fund), obj(txb, args.savingCap), obj(txb, args.fundCap), pure(txb, args.amount, `u64`) ], }) }

export function newSavingCap( txb: TransactionBlock, typeArg: string, saving: ObjectArg ) { return txb.moveCall({ target: `${PUBLISHED_AT}::saving::new_saving_cap`, typeArguments: [typeArg], arguments: [ obj(txb, saving) ], }) }

export interface NewSavingTargetArgs { date: bigint | TransactionArgument; amount: bigint | TransactionArgument }

export function newSavingTarget( txb: TransactionBlock, args: NewSavingTargetArgs ) { return txb.moveCall({ target: `${PUBLISHED_AT}::saving::new_saving_target`, arguments: [ pure(txb, args.date, `u64`), pure(txb, args.amount, `u64`) ], }) }

export interface WithdrawToFundArgs { self: ObjectArg; fund: ObjectArg; savingCap: ObjectArg; amount: (bigint | TransactionArgument | TransactionArgument | null); clock: ObjectArg }

export function withdrawToFund( txb: TransactionBlock, typeArg: string, args: WithdrawToFundArgs ) { return txb.moveCall({ target: `${PUBLISHED_AT}::saving::withdraw_to_fund`, typeArguments: [typeArg], arguments: [ obj(txb, args.self), obj(txb, args.fund), obj(txb, args.savingCap), pure(txb, args.amount, `0x1::option::Option<u64>`), obj(txb, args.clock) ], }) }
