use anchor_lang::prelude::*;
use anchor_spl::token::{Mint, Token, TokenAccount};

use crate::state::{OwomiAccount, Savings, SavingsKind, SavingsStatus, seeds, TokenReserve};

pub fn initialize_savings(
    ctx: Context<InitializeSavings>,
    args: InitializeSavingsArgs,
) -> Result<()> {
    let savings = &mut ctx.accounts.savings;

    savings.mint = ctx.accounts.mint.key();
    savings.account = ctx.accounts.account.key();
    savings.bump = ctx.bumps.savings;
    savings.kind = args.kind;
    savings.index = args.index;
    savings.balance = 0;
    savings.created_at = Clock::get()?.unix_timestamp as u64;
    savings.interest_enabled = false;
    savings.interest_rate = 0;
    savings.principal = 0;
    savings.returns = 0;
    savings.status = SavingsStatus::Active;

    Ok(())
}

#[derive(Clone, AnchorSerialize, AnchorDeserialize)]
pub struct InitializeSavingsArgs {
    index: u64,
    kind: SavingsKind,
}

#[derive(Accounts)]
#[instruction(args: InitializeSavingsArgs)]
pub struct InitializeSavings<'info> {
    pub mint: Account<'info, Mint>,
    pub authority: Signer<'info>,
    #[account(
        init,
        payer = fee_payer,
        space = Savings::SIZE,
        seeds = [
            seeds::SEED_PREFIX,
            seeds::SEED_SAVINGS,
            mint.key().as_ref(),
            authority.key().as_ref(),
            &args.index.to_le_bytes()
        ],
        bump
    )]
    pub savings: Account<'info, Savings>,
    #[account(
        mut,
        seeds = [
            seeds::SEED_PREFIX,
            seeds::SEED_ACCOUNT,
            authority.key().as_ref()
        ],
        bump = account.bump
    )]
    pub account: Account<'info, OwomiAccount>,
    #[account(mut)]
    pub fee_payer: Signer<'info>,
    #[account(
        seeds = [
            seeds::SEED_PREFIX,
            seeds::SEED_TOKEN_RESERVE,
            mint.key().as_ref(),
            authority.key().as_ref()
        ],
        bump
    )]
    pub reserve: Account<'info, TokenReserve>,
    #[account(
        mut,
        seeds = [seeds::SEED_PREFIX, reserve.key().as_ref()],
        bump
    )]
    pub vault: Account<'info, TokenAccount>,
    pub token_program: Program<'info, Token>,
    pub system_program: Program<'info, System>,
}
