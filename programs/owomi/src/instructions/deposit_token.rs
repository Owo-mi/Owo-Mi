use anchor_lang::prelude::*;
use anchor_spl::token::{self, Mint, Token, TokenAccount, Transfer};

use crate::state::{seeds, TokenReserve};

pub fn deposit_token(ctx: Context<DepositToken>, amount: u64) -> Result<()> {
    let from = ctx.accounts.signer_token_account.to_account_info();
    let to = ctx.accounts.vault.to_account_info();
    let authority = ctx.accounts.signer.to_account_info();

    let token_program = ctx.accounts.token_program.to_account_info();

    token::transfer(
        CpiContext::new(
            token_program,
            Transfer {
                to,
                from,
                authority,
            },
        ),
        amount,
    )?;

    Ok(())
}

#[derive(Accounts)]
pub struct DepositToken<'info> {
    #[account(mut)]
    signer: Signer<'info>,
    pub mint: Account<'info, Mint>,
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
    pub signer_token_account: Account<'info, TokenAccount>,
    pub token_program: Program<'info, Token>,
    pub system_program: Program<'info, System>,
}
