---
sidebar_position: 2
---

# Keyshares

Each MPK is derived from a Master Secret Key (MSK), which is generated each epoch by the [Share Generation API](../running-a-node/share_generation_api.md).
Once the MSK is generated, the [Share Generation API](../running-a-node/share_generation_api.md) then performs a function to derive the MPK,
then breaks up and distributes the MSK to the validators in the network via Verifiable Secret Sharing (VSS),
such that each validator holds a share of the MSK, known as the **MSK share**.
After the MSK shares are distributed, the [Share Generation API](../running-a-node/share_generation_api.md) discards the full MSK.

Each validator stores its share of the MSK locally and uses the [`fairyringclient`](../running-a-node/submit_keyshare.md#fairyringclient)
to derive the private key share for each block height corresponding to the `ActivePubKey`.
After the private key share is generated, the validator submits it to via a transaction to `fairyring`.
`fairyring` aggregates the private key shares, and when the threshold for private key construction is met, derives the private key for the current block height.

Each validator needs to run the `fairyringclient` in order to receive their MSK share each time it changes,
derive their private key share according to the `ActivePubKey` for each condition,
and then submit the private key share to `fairyring` for private key construction.

The initial release will be a Proof of Authority (PoA) chain similar to the approach used by [Noble](https://github.com/strangelove-ventures/noble).
There are some simple slashing conditions implemented for now (such as submitting incorrect keyshares, or skipping blocks), but this may change.
