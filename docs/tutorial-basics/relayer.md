---
sidebar_position: 3
---

# Relayer

An off-chain service for fetching aggregated keyshares to destination chains from `Fairyring` is also needed. The solution of using some form of Interchain Query does not quite work since verification of blocks on both chains delays the entire process by multiple blocks. This would allow for frontrunning on the destination chain as there is a window of decrypting transactions ahead of time.
The service has two components:

- A websocket client that listens to events on `Fairyring`
- A transaction handler that submits aggregated keyshares to the destination chain

Note that this method is currently permissionless, so anyone is able to submit aggregated keyshares. We perform a verification in `BeginBlock` to ensure that the decryption key is valid.
A destination chain can possibly alter the `decryption` module to only accept transactions from trusted relayers, though that is up to the destination chain.
