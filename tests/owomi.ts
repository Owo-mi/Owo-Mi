import * as anchor from "@coral-xyz/anchor";
import {Program, web3} from "@coral-xyz/anchor";
import {Owomi} from "../target/types/owomi";

describe("owomi", () => {
    // Configure the client to use the local cluster.
    const provider = anchor.AnchorProvider.env()
    anchor.setProvider(provider);

    const program = anchor.workspace.Owomi as Program<Owomi>;

    it("Is initialized!", async () => {
        // Add your test here.
        const keypair = anchor.web3.Keypair.generate();

        const signature = await provider.connection.requestAirdrop(
            keypair.publicKey,
            web3.LAMPORTS_PER_SOL
        );
        await provider.connection.confirmTransaction(signature);


        const [account] = await anchor.web3.PublicKey.findProgramAddress(
            [keypair.publicKey.toBuffer()],
            program.programId
        );

        const tx = await program.methods
            .createAccount()
            .accounts({
                account,
                authority: keypair.publicKey,
                systemProgram: anchor.web3.SystemProgram.programId,
            })
            .signers([keypair])
            .rpc();

        console.log("Your transaction signature", tx);
    });
});
