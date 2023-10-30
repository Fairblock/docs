---
sidebar_position: 5
---

# ABCI++

Currently, `Fairyring` chain requires each validator to submit keyshares every block in order to generate an aggregated decryption key.
With `ABCI++`, we can make use of the `VoteExtensions` functionality to submit keys instead of relying on transactions.
Additionally, this would allow for same block execution for encrypted transactions, removing the need for the 1 block delay.

The block generation process would become:

1. The block proposer will propose a block (with a fixed ordering of encrypted transactions): `PrepareProposal`
2. `ProcessProposal` logic
3. Validators will vote on the proposed block.
4. `VoteExtension`: keyshares for each validator is attached in this step.
5. `VerifyVoteExtension`: keyshares for each validator is verified to ensure they submit correct keyshares and to prevent malicious activity. (This may cause liveness issues though, so we will have to think more about what an incorrect vote will mean).
6. Once enough votes (and/or correct keyshares) are received, finalize commit. `FinalizeBlock` logic is called.
7. In `FinalizeBlock`, decrypt all the encrypted transactions using aggregated key.
