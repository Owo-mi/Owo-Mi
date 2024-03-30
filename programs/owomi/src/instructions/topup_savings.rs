use anchor_lang::prelude::*;
use anchor_spl::token::{Mint, Token, TokenAccount};

use crate::state::{OwomiAccount, Savings, seeds, TokenReserve};

pub fn topup_savings(ctx: Context<TopupTokenBalance>, args: TopupSavingsArgs) -> Result<()> {
    let savings = &mut ctx.accounts.savings;

    let balance = savings.balance.checked_add(args.amount).unwrap();
    savings.balance = balance;

    Ok(())
}

#[derive(Clone, AnchorSerialize, AnchorDeserialize)]
pub struct TopupSavingsArgs {
    index: u64,
    amount: u64,
}

#[derive(Accounts)]
#[instruction(args: TopupSavingsArgs)]
pub struct TopupTokenBalance<'info> {
    pub mint: Account<'info, Mint>,
    pub signer: Signer<'info>,
    #[account(
        mut,
        seeds = [
            seeds::SEED_PREFIX,
            seeds::SEED_SAVINGS,
            mint.key().as_ref(),
            signer.key().as_ref(),
            &args.index.to_le_bytes()
        ],
        bump
    )]
    pub savings: Account<'info, Savings>,
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
