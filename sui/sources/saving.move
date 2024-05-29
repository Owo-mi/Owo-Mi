module owomi::saving {
    use std::string::String;

    use sui::balance::{Self, Balance};
    use sui::coin::{Self, Coin};
    use sui::clock::Clock;

    use owomi::fund::{Fund, FundCap};

    public struct Saving<phantom T> has key {
        id: UID,
        reward: u64,
        name: String,
        owner: address,
        created_at_ms: u64,
        description: String,
        balance: Balance<T>,
        target: Option<SavingTarget>,
        authorized_caps: vector<ID>,
    }

    public struct SavingTarget has store, drop, copy {
        date: u64,
        amount: u64
    }

    public struct SavingCap has key {
        id: UID,
        saving: ID
    }
    
    const EInvalidSavingTarget: u64 = 0;
    const EInvalidDepositAmount: u64 = 1;
    const ESavingCapMismatch: u64 = 2;
    const EInSufficientSavingBalance: u64 = 3;
    const EInvalidSavingAuthorization: u64 = 4;
    const EUnknownAuthorizedCap: u64 = 5;


    public fun new<T>(name: String, description: String, target: Option<SavingTarget>, clock: &Clock, ctx: &mut TxContext): (Saving<T>, SavingCap) {
        if(target.is_some()) {
            let target = target.borrow();

            assert!(target.amount > 0, EInvalidSavingTarget);
            assert!(target.date > clock.timestamp_ms(), EInvalidSavingTarget);
        };
        
        let id = object::new(ctx);
        let mut saving = Saving<T> {
            id,
            name,
            target,
            reward: 0,
            description,
            owner: ctx.sender(),
            balance: balance::zero(),
            authorized_caps: vector::empty(),
            created_at_ms: clock.timestamp_ms(),
        };

        let cap = new_saving_cap(&saving, ctx);
        saving.authorized_caps.push_back(cap.id.to_inner());
        (saving, cap)
    }

    public fun new_saving_target(date: u64, amount: u64): SavingTarget {
        SavingTarget {
            date,
            amount
        }
    }

    public fun new_authorized_cap<T>(self: &mut Saving<T>, ctx: &mut TxContext): SavingCap {
        assert!(self.owner == ctx.sender(), EInvalidSavingAuthorization);
        let cap = self.new_saving_cap(ctx);
        self.authorized_caps.push_back(cap.id.to_inner());

        cap
    }

    public fun revoke_cap<T>(self: &mut Saving<T>, cap: ID, ctx: &mut TxContext) {
        assert!(self.owner == ctx.sender(), EInvalidSavingAuthorization);
        assert!(self.authorized_caps.contains(&cap), EUnknownAuthorizedCap);

        let index = self.authorized_cap_index(cap);
        assert!(index.is_some(), EUnknownAuthorizedCap);
        self.authorized_caps.remove(index.destroy_some());
    }

    public fun delete_cap<T>(self: &mut Saving<T>, cap: SavingCap) {
        let index = self.authorized_cap_index(cap.id.to_inner());
        if(index.is_some()) {
            self.authorized_caps.remove(index.destroy_some());
        };

        let SavingCap { id, saving: _ } = cap;
        id.delete();
    }

    #[allow(lint(share_owned))]
    public fun share<T>(self: Saving<T>) {
        transfer::share_object(self)
    }

    public fun transfer_cap(cap: SavingCap, recipient: address) {
        transfer::transfer(cap, recipient)
    }

    public fun deposit<T>(self: &mut Saving<T>, cap: &SavingCap, coin: Coin<T>) {
        assert!(self.id.to_inner() == cap.saving, ESavingCapMismatch);
        assert!(self.authorized_caps.contains(cap.id.as_inner()), EUnknownAuthorizedCap);
        assert!(coin.value() > 0, EInvalidDepositAmount);

        self.balance.join(coin.into_balance());
    }

    public fun withdraw<T>(self: &mut Saving<T>, cap: &SavingCap, amount: Option<u64>, clock: &Clock, ctx: &mut TxContext): Coin<T> {
        assert!(self.id.to_inner() == cap.saving, ESavingCapMismatch);
        assert!(self.authorized_caps.contains(cap.id.as_inner()), EUnknownAuthorizedCap);


        if(self.target.is_some()) {
            let target = self.target.borrow();
            assert!(clock.timestamp_ms() >= target.date, EInvalidSavingTarget);
            assert!(self.balance.value() >= target.amount, EInvalidSavingTarget);
        };
        
        let amount = if(amount.is_some()){
            let amount = amount.destroy_some();
            assert!(self.balance.value() >= amount, EInSufficientSavingBalance);
            amount
        } else {
            self.balance.value()
        };

        coin::from_balance(self.balance.split(amount), ctx)
    }


    public fun deposit_from_fund<T>(self: &mut Saving<T>, fund: &mut Fund, saving_cap: &SavingCap, fund_cap: &FundCap, amount: u64, ctx: &mut TxContext) {
        let deposit = fund.withdraw(fund_cap, amount, ctx);
        self.deposit(saving_cap, deposit)
    }

    public fun withdraw_to_fund<T>(self: &mut Saving<T>, fund: &mut Fund, saving_cap: &SavingCap, amount: Option<u64>, clock: &Clock, ctx: &mut TxContext) {
        let coin = self.withdraw(saving_cap, amount, clock, ctx);
        fund.deposit(coin);
    }

    // ===== Read only functions =====

    public fun authorized_cap_index<T>(self: &Saving<T>, cap: ID): Option<u64> {
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

    // ===== Private functions =====

    fun new_saving_cap<T>(saving: &Saving<T>, ctx: &mut TxContext): SavingCap {
        SavingCap {
            id: object::new(ctx),
            saving: saving.id.to_inner()
        }
    }

}