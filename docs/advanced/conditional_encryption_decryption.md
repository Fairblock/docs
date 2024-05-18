---
sidebar_position: 5
---

# Conditional Encryption/Decryption

In the [overview](/docs/basics/overview.md), we saw a general flow for how to interact with `fairyring`.
In particular, the chain provides functionality on requesting specific encryption keys corresponding to conditions set by the developer.

We provide a more detailed explanation in this section via an example.
Suppose one wishes to create a sealed-bid auction application.
A sealed-bid auction is an auction mechanism in which bids submitted to the auction are not made available to the participants during the course of the auction.
Using `fairyring` as a mechanism for encrypting the bids, a developer wanting to create this application will take the following steps:

1. For each auction, request a new identity from `fairyring`. This identity will be crucial for encrypting the bids.
2. Provide users with some functionality to encrypt their bids. This can be done using our [`encrypter` tool](/docs/advanced/encrypt_tx.md).
3. Accept and store the encrypted bids within the applcation. This logic will primarily be the responsibility of the application developer.
4. Have a way to notify `fairyring` that the auction has concluded. This can be built into the application itself (meaning the chain initiates the request for decryption to `fairyring`) or can be a simple keeper that notifies `fairyring` when a certain condition has been met (end of auction).
5. Relay the decryption key from `fairyring` to the application. This can be done using our [`fairyport` tool](/docs/advanced/fairyport.md).

# Requesting a new identity

Any user can request a new identity by running the command

```bash
fairyringd tx pep request-general-keyshare --from wallet1 --chain-id fairyring_devnet --home ./devnet_data/fairyring_devnet --keyring-backend test --gas-prices 1ufairy -y 2>&1
```

# Querying identities

You can also query the chain to find the identities that have been generated via the command

```bash
fairyringd q pep list-keyshare-req
```

# Requesting a decryption key

Once encrypted data has been committed by users of your application, you need to notify `fairyring` to generate the decryption key.
To start the generation process, one can run the command

```bash
fairyringd tx pep get-general-keyshare [req-id] --from wallet1 --chain-id fairyring_devnet --home ./devnet_data/fairyring_devnet --keyring-backend test --gas-prices 1ufairy -y 2>&1
```

One can also then query the generated decryption key by using the same query command as above.

# Decrypting and executing

Using the generated decryption key, we are now able to decrypt previously encrypted data.
The `x/pep` module provides some functionality to automatically handle the decryption and execution of transactions once a particular decryption key is made available.
