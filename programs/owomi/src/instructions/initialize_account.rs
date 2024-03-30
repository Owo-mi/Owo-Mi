use anchor_lang::prelude::*;
use anchor_spl::token::TokenAccount;

use crate::state::{OwomiAccount, seeds};

#[derive(Accounts)]
pub struct InitializeAccount<'info> {
    #[account(mut)]
    authority: Signer<'info>,
    #[account(
        init,
        payer = authority,
        space = OwomiAccount::SIZE,
        seeds = [
            seeds::SEED_PREFIX,
            seeds::SEED_ACCOUNT,
            authority.key().as_ref()
        ],
        bump
    )]
    account: Account<'info, OwomiAccount>,
    vault: Account<'info, TokenAccount>,
    system_program: Program<'info, System>,
}

pub fn initialize_account(ctx: Context<InitializeAccount>) -> Result<()> {
    let authority = &mut ctx.accounts.authority;
    let account = &mut ctx.accounts.account;

    account.authority = *authority.key;
    account.bump = ctx.bumps.account;
    account.savings_count = 0;

    Ok(())
}
