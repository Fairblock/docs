---
sidebar_position: 2
---

# Keyshares

Each MPK is derived from a Master Secret Key (MSK), which is generated each epoch by the [Share Generation Client](../running-a-node/share_generation_client.md).
Once the MSK is generated, the [Share Generation Client](../running-a-node/share_generation_client.md) then performs a function to

1. Derive the MPK
2. Splits up the MSK into individual keyshares encrypted by each validator's public key
3. Submits the encrypted keyshares along with the MPK to `fairyring`
4. Discards the full MSK.

Each validator stores its share of the MSK locally and uses the [`fairyringclient`](../running-a-node/submit_keyshare.md#fairyringclient)
to derive the private keyshare for each block height corresponding to the `ActivePubKey`.
After the private keyshare is generated, the validator submits it via a transaction to `fairyring`.
`fairyring` aggregates the private keyshares, and when the threshold for private key construction is met, derives the private key for the current block height.

Each validator needs to run the `fairyringclient` in order to receive their MSK share each time it changes,
derive their private keyshare according to the `ActivePubKey` for each condition,
and then submit the private keyshare to `fairyring` for private key construction.

The initial release will be a Proof of Authority (PoA) chain similar to the approach used by [Noble](https://github.com/strangelove-ventures/noble).
There are some simple slashing conditions implemented for now (such as submitting incorrect keyshares, or skipping blocks), but this may change.
