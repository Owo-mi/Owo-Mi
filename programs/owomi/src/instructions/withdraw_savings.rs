use anchor_lang::prelude::*;
use anchor_spl::token::{Mint, Token, TokenAccount, transfer, Transfer};

use crate::state::{OwomiAccount, Savings, SavingsKind, SavingsStatus, seeds, TokenReserve};

pub fn withdraw_savings(ctx: Context<WithdrawTokenBalance>, index: u64) -> Result<()> {
    let savings = &mut ctx.accounts.savings;
    let current_date = Clock::get()?.unix_timestamp as u64;

    // user can break this before the maturity date, lose interest and a 1% fee is charged
    // if user does not achieve the target before the maturity date, they lose the interest only
    // user cannot break a locked target

    let (withdrawal, penalty) = match savings.kind {
        SavingsKind::Flexible => (savings.balance, 0),
        SavingsKind::Fixed { maturity_date } => {
            if current_date >= maturity_date {
                (savings.balance, 0)
            } else {
                (0, 0)
            }
        }
        SavingsKind::Target {
            amount,
            maturity_date,
        } => {
            if current_date >= maturity_date {
                if savings.principal >= amount {
                    (savings.balance, 0)
                } else {
                    (savings.principal, savings.returns)
                }
            } else {
                let penalty = savings.principal.saturating_mul(1).saturating_div(100);
                let withdrawal = savings.principal.checked_sub(penalty).unwrap();
                (withdrawal, savings.returns + penalty)
            }
        }
    };

    savings.status = SavingsStatus::Closed;

    if (penalty > 0) {
        // transfer penalty fee to our own treasury
    }

    let cpi = CpiContext::new_with_signer(
        ctx.accounts.token_program.to_account_info(),
        Transfer {
            to: ctx.accounts.signer.to_account_info(),
            from: ctx.accounts.vault.to_account_info(),
            authority: ctx.accounts.account.to_account_info(),
        },
        &[&[
            seeds::SEED_PREFIX,
            seeds::SEED_ACCOUNT,
            ctx.accounts.signer.key().as_ref(),
        ]],
    );

    transfer(cpi, withdrawal)?;

    Ok(())
}

#[derive(Clone, AnchorSerialize, AnchorDeserialize)]
pub struct WithdrawSavingsArgs {
    index: u64,
    amount: u64,
}

#[derive(Accounts)]
#[instruction(index: u64)]
pub struct WithdrawTokenBalance<'info> {
    pub mint: Account<'info, Mint>,
    pub signer: Signer<'info>,
    #[account(
        mut,
        seeds = [
            seeds::SEED_PREFIX,
            seeds::SEED_SAVINGS,
            mint.key().as_ref(),
            signer.key().as_ref(),
            &index.to_le_bytes()
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
