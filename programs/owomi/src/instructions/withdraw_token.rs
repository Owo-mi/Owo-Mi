use anchor_lang::prelude::*;
use anchor_spl::token::{self, Mint, Token, TokenAccount, Transfer};

use crate::state::{OwomiAccount, seeds, TokenReserve};

pub fn withdraw_token(ctx: Context<WithdrawToken>, amount: u64) -> Result<()> {
    let to = ctx.accounts.destination_token_account.to_account_info();
    let from = ctx.accounts.vault.to_account_info();

    let account = &ctx.accounts.account;

    let token_program = ctx.accounts.token_program.to_account_info();
    token::transfer(
        CpiContext::new_with_signer(
            token_program,
            Transfer {
                to,
                from,
                authority: account.to_account_info(),
            },
            &[&[
                seeds::SEED_PREFIX,
                seeds::SEED_ACCOUNT,
                ctx.accounts.signer.key().as_ref(),
                &[account.bump],
            ]],
        ),
        amount,
    )?;

    Ok(())
}

#[derive(Accounts)]
pub struct WithdrawToken<'info> {
    #[account(mut)]
    signer: Signer<'info>,
    pub mint: Account<'info, Mint>,
    #[account(
        seeds = [
            seeds::SEED_PREFIX,
            seeds::SEED_ACCOUNT,
            signer.key().as_ref()
        ],
        bump = account.bump
    )]
    pub account: Account<'info, OwomiAccount>,

    #[account(
        seeds = [
            seeds::SEED_PREFIX,
            seeds::SEED_TOKEN_RESERVE,
            mint.key().as_ref(),
            signer.key().as_ref()
        ],
        bump = reserve.bump
    )]
    pub reserve: Account<'info, TokenReserve>,
    #[account(
        mut,
        seeds = [seeds::SEED_PREFIX, reserve.key().as_ref()],
        bump = reserve.vault_bump
    )]
    pub vault: Account<'info, TokenAccount>,
    #[account(mut)]
    pub destination_token_account: Account<'info, TokenAccount>,
    pub token_program: Program<'info, Token>,
    pub system_program: Program<'info, System>,
}
