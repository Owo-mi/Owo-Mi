module owomi::fund {
    use std::type_name;

    use sui::bag::{Self, Bag};
    use sui::balance::Balance;
    use sui::coin::{Self, Coin};

    public struct Fund has key {
        id: UID,
        balances: Bag,
        owner: address,
        authorized_caps: vector<ID>,
    }

    public struct FundCap has key {
        id: UID,
        fund: ID,
    }

    const EUnauthorized: u64 = 0;
    const EFundCapMismatch: u64 = 0;
    const EUnknownCoinType: u64 = 1;
    const EInsufficientFunds: u64 = 2;
    const EUnknownAuthorizedCap: u64 = 3;
    const EInvalidFundAuthorization: u64 = 4;

    public fun new(ctx: &mut TxContext): Fund {
        Fund {
            id: object::new(ctx),
            owner: ctx.sender(),
            balances: bag::new(ctx),
            authorized_caps: vector::empty(),
        }
    }

    public fun deposit<T>(fund: &mut Fund, coin: Coin<T>) {
        let coin_type = type_name::get<T>().into_string().into_bytes();

        if(fund.balances.contains(coin_type)) {
            let balance = fund.balances.borrow_mut<vector<u8>, Balance<T>>(coin_type);
            balance.join(coin.into_balance());
        } else {
            fund.balances.add(coin_type, coin.into_balance());
        }
    }

    public fun withdraw<T>(fund: &mut Fund, cap: &FundCap, amount: u64, ctx: &mut TxContext): Coin<T> {
        assert!(fund.id.to_inner() == cap.fund, EFundCapMismatch);
        let coin_type = type_name::get<T>().into_string().into_bytes();

        assert!(fund.balances.contains(coin_type), EUnknownCoinType);
        let balance = fund.balances.borrow_mut<vector<u8>, Balance<T>>(coin_type);
        assert!(balance.value() >= amount, EInsufficientFunds);

        let coin = fund.balances.borrow_mut<vector<u8>, Balance<T>>(coin_type).split(amount);
        coin::from_balance(coin, ctx)
    }

    public fun balance<T>(fund: &Fund): u64 {
        let coin_type = type_name::get<T>().into_string().into_bytes();
        if(!fund.balances.contains(coin_type)) return 0;

        fund.balances.borrow<vector<u8>, Balance<T>>(coin_type).value()
    }

    fun new_cap(fund: &Fund, ctx: &mut TxContext): FundCap {
        FundCap {
            id: object::new(ctx),
            fund: fund.id.to_inner()
        }
    }

    #[allow(lint(share_owned))]
    public fun share(self: Fund) {
        transfer::share_object(self)
    }

    public fun transfer_cap(cap: FundCap, recipient: address) {
        transfer::transfer(cap, recipient)
    }

    public fun new_authorized_cap(fund: &mut Fund, ctx: &mut TxContext): FundCap {
        assert!(fund.owner == ctx.sender(), EUnauthorized);
        let cap = fund.new_cap(ctx);
        fund.authorized_caps.push_back(cap.id.to_inner());

        cap
    }


    public fun revoke_cap(self: &mut Fund, cap: ID, ctx: &mut TxContext) {
        assert!(self.owner == ctx.sender(), EInvalidFundAuthorization);
        assert!(self.authorized_caps.contains(&cap), EUnknownAuthorizedCap);

        let index = self.authorized_cap_index(cap);
        assert!(index.is_some(), EUnknownAuthorizedCap);

        self.authorized_caps.remove(index.destroy_some());
    }

    public fun delete_cap(self: &mut Fund, cap: FundCap) {
        assert!(self.authorized_caps.contains(cap.id.as_inner()), EUnknownAuthorizedCap);

        let index = self.authorized_cap_index(cap.id.to_inner());
        assert!(index.is_some(), EUnknownAuthorizedCap);

        self.authorized_caps.remove(index.destroy_some());
        let FundCap { id, fund: _ } = cap;
        id.delete();
    }

    public fun authorized_cap_index(self: &Fund, cap: ID): Option<u64> {
        let (mut i, len) = (0, self.authorized_caps.length());
        while (i < len ){
            let authorized_cap = self.authorized_caps[i];
            if(authorized_cap == cap) {
                return option::some(i)
            };

            i = i + 1;
        };

        option::none()
    }
}