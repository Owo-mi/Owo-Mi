use anchor_lang::prelude::*;

pub mod seeds;

#[account]
pub struct OwomiAccount {
    pub authority: Pubkey,
    pub savings_count: u16,
    pub bump: u8,
}

#[account]
pub struct TokenReserve {
    pub mint: Pubkey,
    pub vault: Pubkey,
    pub account: Pubkey,
    pub vault_bump: u8,
    pub bump: u8,
}

#[account]
pub struct Savings {
    pub index: u64,
    pub balance: u64,
    pub returns: u64,
    pub mint: Pubkey,
    pub principal: u64,
    pub account: Pubkey,
    pub created_at: u64,
    pub interest_rate: u16,
    pub kind: SavingsKind,
    pub status: SavingsStatus,
    pub interest_enabled: bool,
    pub bump: u8,
}

#[derive(Clone, AnchorSerialize, AnchorDeserialize)]

pub enum SavingsKind {
    Flexible,
    Fixed { maturity_date: u64 },
    Target { amount: u64, maturity_date: u64 },
}

#[derive(Clone, AnchorSerialize, AnchorDeserialize)]

pub enum SavingsStatus {
    Active,
    Paused,
    Closed,
}

impl OwomiAccount {
    pub const SIZE: usize = 8 + std::mem::size_of::<OwomiAccount>();
}

impl TokenReserve {
    pub const SIZE: usize = 8 + std::mem::size_of::<TokenReserve>();
}

impl Savings {
    pub const SIZE: usize = 8 + std::mem::size_of::<Savings>();
}
