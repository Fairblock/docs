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

1. For each auction, request a new condition id from `fairyring`. This condition id will be crucial for encrypting the bids.
2. Provide users with some functionality to encrypt their bids. This can be done using our [`encrypter` tool](/docs/advanced/encrypt_tx.md).
3. Accept and store the encrypted bids within the applcation. This logic will primarily be the responsibility of the application developer.
4. Have a way to notify `fairyring` that the auction has concluded. This can be built into the application itself (meaning the chain initiates the request for decryption to `fairyring`) or can be a simple keeper that notifies `fairyring` when a certain condition has been met (end of auction).
5. Relay the decryption key from `fairyring` to the application. This can be done using our [`fairyport` tool](/docs/advanced/fairyport.md).

# Requesting a new condition id

Any user can request a new condition id by running the command

```bash
fairyringd tx pep request-general-identity 30s testing123 --from wallet1 --chain-id fairyring_devnet --home ./devnet_data/fairyring_devnet --keyring-backend test --gas-prices 1ufairy -y 2>&1
```
- `testing123` is the custom identity, it can be anything you want, but it can only be used once per address

# Querying identities

You can also query the chain to find the identities that have been generated via the command

```bash
fairyringd q pep list-general-identities
```

# Requesting a decryption key

Once encrypted data has been committed by users of your application, you need to notify `fairyring` to generate the decryption key.
To start the generation process, one can run the command

```bash
fairyringd tx pep request-general-decryption-key [req-id] --from wallet1 --chain-id fairyring_devnet --home ./devnet_data/fairyring_devnet --keyring-backend test --gas-prices 1ufairy -y 2>&1
```

Remember the `req-id` is different from the `identity`, `req-id` is: `{YOUR_ADDRESS}/{IDENTITY}`

Let's say you address is `fairy18hl5c9xn5dze2g50uaw0l2mr02ew57zkynp0td` and you requested identity `testing123`

Then your request id would be `fairy18hl5c9xn5dze2g50uaw0l2mr02ew57zkynp0td/testing123`

- The generated decryption key can only be queried by the identity creator

# Decrypting and executing

Using the generated decryption key, we are now able to decrypt previously encrypted data.
The `x/pep` module provides some functionality to automatically handle the decryption and execution of transactions once a particular decryption key is made available.
