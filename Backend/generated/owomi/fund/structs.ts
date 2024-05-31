import * as reified from "../../_framework/reified";
import {Bag} from "../../_dependencies/source/0x2/bag/structs";
import {ID, UID} from "../../_dependencies/source/0x2/object/structs";
import {PhantomReified, Reified, StructClass, ToField, ToTypeStr, Vector, decodeFromFields, decodeFromFieldsWithTypes, decodeFromJSONField, fieldToJSON, phantom} from "../../_framework/reified";
import {FieldsWithTypes, composeSuiType, compressSuiType} from "../../_framework/util";
import {bcs, fromB64, fromHEX, toHEX} from "@mysten/bcs";
import {SuiClient, SuiParsedData} from "@mysten/sui.js/client";

/* ============================== Fund =============================== */

export function isFund(type: string): boolean { type = compressSuiType(type); return type === "0x0::fund::Fund"; }

export interface FundFields { id: ToField<UID>; balances: ToField<Bag>; owner: ToField<"address">; authorizedCaps: ToField<Vector<ID>> }

export type FundReified = Reified< Fund, FundFields >;

export class Fund implements StructClass { static readonly $typeName = "0x0::fund::Fund"; static readonly $numTypeParams = 0;

 readonly $typeName = Fund.$typeName;

 readonly $fullTypeName: "0x0::fund::Fund";

 readonly $typeArgs: [];

 readonly id: ToField<UID>; readonly balances: ToField<Bag>; readonly owner: ToField<"address">; readonly authorizedCaps: ToField<Vector<ID>>

 private constructor(typeArgs: [], fields: FundFields, ) { this.$fullTypeName = composeSuiType( Fund.$typeName, ...typeArgs ) as "0x0::fund::Fund"; this.$typeArgs = typeArgs;

 this.id = fields.id;; this.balances = fields.balances;; this.owner = fields.owner;; this.authorizedCaps = fields.authorizedCaps; }

 static reified( ): FundReified { return { typeName: Fund.$typeName, fullTypeName: composeSuiType( Fund.$typeName, ...[] ) as "0x0::fund::Fund", typeArgs: [ ] as [], reifiedTypeArgs: [], fromFields: (fields: Record<string, any>) => Fund.fromFields( fields, ), fromFieldsWithTypes: (item: FieldsWithTypes) => Fund.fromFieldsWithTypes( item, ), fromBcs: (data: Uint8Array) => Fund.fromBcs( data, ), bcs: Fund.bcs, fromJSONField: (field: any) => Fund.fromJSONField( field, ), fromJSON: (json: Record<string, any>) => Fund.fromJSON( json, ), fromSuiParsedData: (content: SuiParsedData) => Fund.fromSuiParsedData( content, ), fetch: async (client: SuiClient, id: string) => Fund.fetch( client, id, ), new: ( fields: FundFields, ) => { return new Fund( [], fields ) }, kind: "StructClassReified", } }

 static get r() { return Fund.reified() }

 static phantom( ): PhantomReified<ToTypeStr<Fund>> { return phantom(Fund.reified( )); } static get p() { return Fund.phantom() }

 static get bcs() { return bcs.struct("Fund", {

 id: UID.bcs, balances: Bag.bcs, owner: bcs.bytes(32).transform({ input: (val: string) => fromHEX(val), output: (val: Uint8Array) => toHEX(val), }), authorized_caps: bcs.vector(ID.bcs)

}) };

 static fromFields( fields: Record<string, any> ): Fund { return Fund.reified( ).new( { id: decodeFromFields(UID.reified(), fields.id), balances: decodeFromFields(Bag.reified(), fields.balances), owner: decodeFromFields("address", fields.owner), authorizedCaps: decodeFromFields(reified.vector(ID.reified()), fields.authorized_caps) } ) }

 static fromFieldsWithTypes( item: FieldsWithTypes ): Fund { if (!isFund(item.type)) { throw new Error("not a Fund type");

 }

 return Fund.reified( ).new( { id: decodeFromFieldsWithTypes(UID.reified(), item.fields.id), balances: decodeFromFieldsWithTypes(Bag.reified(), item.fields.balances), owner: decodeFromFieldsWithTypes("address", item.fields.owner), authorizedCaps: decodeFromFieldsWithTypes(reified.vector(ID.reified()), item.fields.authorized_caps) } ) }

 static fromBcs( data: Uint8Array ): Fund { return Fund.fromFields( Fund.bcs.parse(data) ) }

 toJSONField() { return {

 id: this.id,balances: this.balances.toJSONField(),owner: this.owner,authorizedCaps: fieldToJSON<Vector<ID>>(`vector<0x2::object::ID>`, this.authorizedCaps),

} }

 toJSON() { return { $typeName: this.$typeName, $typeArgs: this.$typeArgs, ...this.toJSONField() } }

 static fromJSONField( field: any ): Fund { return Fund.reified( ).new( { id: decodeFromJSONField(UID.reified(), field.id), balances: decodeFromJSONField(Bag.reified(), field.balances), owner: decodeFromJSONField("address", field.owner), authorizedCaps: decodeFromJSONField(reified.vector(ID.reified()), field.authorizedCaps) } ) }

 static fromJSON( json: Record<string, any> ): Fund { if (json.$typeName !== Fund.$typeName) { throw new Error("not a WithTwoGenerics json object") };

 return Fund.fromJSONField( json, ) }

 static fromSuiParsedData( content: SuiParsedData ): Fund { if (content.dataType !== "moveObject") { throw new Error("not an object"); } if (!isFund(content.type)) { throw new Error(`object at ${(content.fields as any).id} is not a Fund object`); } return Fund.fromFieldsWithTypes( content ); }

 static async fetch( client: SuiClient, id: string ): Promise<Fund> { const res = await client.getObject({ id, options: { showBcs: true, }, }); if (res.error) { throw new Error(`error fetching Fund object at id ${id}: ${res.error.code}`); } if (res.data?.bcs?.dataType !== "moveObject" || !isFund(res.data.bcs.type)) { throw new Error(`object at id ${id} is not a Fund object`); }
 return Fund.fromBcs( fromB64(res.data.bcs.bcsBytes) ); }

 }

/* ============================== FundCap =============================== */

export function isFundCap(type: string): boolean { type = compressSuiType(type); return type === "0x0::fund::FundCap"; }

export interface FundCapFields { id: ToField<UID>; fund: ToField<ID> }

export type FundCapReified = Reified< FundCap, FundCapFields >;

export class FundCap implements StructClass { static readonly $typeName = "0x0::fund::FundCap"; static readonly $numTypeParams = 0;

 readonly $typeName = FundCap.$typeName;

 readonly $fullTypeName: "0x0::fund::FundCap";

 readonly $typeArgs: [];

 readonly id: ToField<UID>; readonly fund: ToField<ID>

 private constructor(typeArgs: [], fields: FundCapFields, ) { this.$fullTypeName = composeSuiType( FundCap.$typeName, ...typeArgs ) as "0x0::fund::FundCap"; this.$typeArgs = typeArgs;

 this.id = fields.id;; this.fund = fields.fund; }

 static reified( ): FundCapReified { return { typeName: FundCap.$typeName, fullTypeName: composeSuiType( FundCap.$typeName, ...[] ) as "0x0::fund::FundCap", typeArgs: [ ] as [], reifiedTypeArgs: [], fromFields: (fields: Record<string, any>) => FundCap.fromFields( fields, ), fromFieldsWithTypes: (item: FieldsWithTypes) => FundCap.fromFieldsWithTypes( item, ), fromBcs: (data: Uint8Array) => FundCap.fromBcs( data, ), bcs: FundCap.bcs, fromJSONField: (field: any) => FundCap.fromJSONField( field, ), fromJSON: (json: Record<string, any>) => FundCap.fromJSON( json, ), fromSuiParsedData: (content: SuiParsedData) => FundCap.fromSuiParsedData( content, ), fetch: async (client: SuiClient, id: string) => FundCap.fetch( client, id, ), new: ( fields: FundCapFields, ) => { return new FundCap( [], fields ) }, kind: "StructClassReified", } }

 static get r() { return FundCap.reified() }

 static phantom( ): PhantomReified<ToTypeStr<FundCap>> { return phantom(FundCap.reified( )); } static get p() { return FundCap.phantom() }

 static get bcs() { return bcs.struct("FundCap", {

 id: UID.bcs, fund: ID.bcs

}) };

 static fromFields( fields: Record<string, any> ): FundCap { return FundCap.reified( ).new( { id: decodeFromFields(UID.reified(), fields.id), fund: decodeFromFields(ID.reified(), fields.fund) } ) }

 static fromFieldsWithTypes( item: FieldsWithTypes ): FundCap { if (!isFundCap(item.type)) { throw new Error("not a FundCap type");

 }

 return FundCap.reified( ).new( { id: decodeFromFieldsWithTypes(UID.reified(), item.fields.id), fund: decodeFromFieldsWithTypes(ID.reified(), item.fields.fund) } ) }

 static fromBcs( data: Uint8Array ): FundCap { return FundCap.fromFields( FundCap.bcs.parse(data) ) }

 toJSONField() { return {

 id: this.id,fund: this.fund,

} }

 toJSON() { return { $typeName: this.$typeName, $typeArgs: this.$typeArgs, ...this.toJSONField() } }

 static fromJSONField( field: any ): FundCap { return FundCap.reified( ).new( { id: decodeFromJSONField(UID.reified(), field.id), fund: decodeFromJSONField(ID.reified(), field.fund) } ) }

 static fromJSON( json: Record<string, any> ): FundCap { if (json.$typeName !== FundCap.$typeName) { throw new Error("not a WithTwoGenerics json object") };

 return FundCap.fromJSONField( json, ) }

 static fromSuiParsedData( content: SuiParsedData ): FundCap { if (content.dataType !== "moveObject") { throw new Error("not an object"); } if (!isFundCap(content.type)) { throw new Error(`object at ${(content.fields as any).id} is not a FundCap object`); } return FundCap.fromFieldsWithTypes( content ); }

 static async fetch( client: SuiClient, id: string ): Promise<FundCap> { const res = await client.getObject({ id, options: { showBcs: true, }, }); if (res.error) { throw new Error(`error fetching FundCap object at id ${id}: ${res.error.code}`); } if (res.data?.bcs?.dataType !== "moveObject" || !isFundCap(res.data.bcs.type)) { throw new Error(`object at id ${id} is not a FundCap object`); }
 return FundCap.fromBcs( fromB64(res.data.bcs.bcsBytes) ); }

 }
