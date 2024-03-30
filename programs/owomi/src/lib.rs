use anchor_lang::prelude::*;

pub mod instructions;
pub mod state;

declare_id!("CAExaUGyDw6HR93CuXipA2oXTf1QGnGpxeWSAJjFQx7p");

#[program]
pub mod owomi {
    use super::*;
    use super::instructions::*;
}
