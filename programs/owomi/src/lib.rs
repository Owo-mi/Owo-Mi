use anchor_lang::prelude::*;

use instructions::{
    deposit_token::{self, DepositToken},
    initialize_account::{self, InitializeAccount},
    initialize_savings::{self, InitializeSavings, InitializeSavingsArgs},
    initialize_token_reserve::{self, InitializeTokenReserve},
    topup_savings::{self, TopupSavings, TopupSavingsArgs},
    withdraw_savings::{self, WithdrawSavings},
    withdraw_token::{self, WithdrawToken},
};

pub mod instructions;
pub mod state;

declare_id!("CAExaUGyDw6HR93CuXipA2oXTf1QGnGpxeWSAJjFQx7p");

#[program]
pub mod owomi {
    use super::*;

    pub fn initialize_token_reserve(ctx: Context<InitializeTokenReserve>) -> Result<()> {
        initialize_token_reserve::initialize_token_reserve(ctx)
    }
    pub fn initialize_account(ctx: Context<InitializeAccount>) -> Result<()> {
        initialize_account::initialize_account(ctx)
    }
    pub fn deposit_token(ctx: Context<DepositToken>, amount: u64) -> Result<()> {
        deposit_token::deposit_token(ctx, amount)
    }
    pub fn withdraw_token(ctx: Context<WithdrawToken>, amount: u64) -> Result<()> {
        withdraw_token::withdraw_token(ctx, amount)
    }
    pub fn initialize_savings(
        ctx: Context<InitializeSavings>,
        args: InitializeSavingsArgs,
    ) -> Result<()> {
        initialize_savings::initialize_savings(ctx, args)
    }

    pub fn topup_savings(ctx: Context<TopupSavings>, args: TopupSavingsArgs) -> Result<()> {
        topup_savings::topup_savings(ctx, args)
    }
    pub fn withdraw_savings(ctx: Context<WithdrawSavings>, index: u64) -> Result<()> {
        withdraw_savings::withdraw_savings(ctx, index)
    }
}
