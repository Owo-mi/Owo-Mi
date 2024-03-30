use anchor_lang::prelude::*;
use anchor_spl::token::{Mint, Token, TokenAccount};

use crate::state::{OwomiAccount, seeds, TokenReserve};

pub fn initialize_token_reserve(ctx: Context<InitializeTokenReserve>) -> Result<()> {
    let reserve = &mut ctx.accounts.reserve;

    reserve.bump = ctx.bumps.reserve;
    reserve.vault_bump = ctx.bumps.vault;

    reserve.mint = ctx.accounts.mint.key();
    reserve.vault = ctx.accounts.vault.key();
    reserve.account = ctx.accounts.account.key();

    Ok(())
}

#[derive(Accounts)]
pub struct InitializeTokenReserve<'info> {
    pub mint: Account<'info, Mint>,
    pub authority: Signer<'info>,
    #[account(
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
        init,
        payer = fee_payer,
        space = TokenReserve::SIZE,
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
        init,
        token::mint = mint,
        token::authority = account,
        payer = fee_payer,
        seeds = [seeds::SEED_PREFIX, reserve.key().as_ref()],
        bump
    )]
    pub vault: Account<'info, TokenAccount>,
    pub token_program: Program<'info, Token>,
    pub system_program: Program<'info, System>,
}
