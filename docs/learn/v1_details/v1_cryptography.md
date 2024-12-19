---
sidebar_position: 1
---

# v1 Cryptography

Fairblock v1 mainly focuses on using Threshold Identity-Based Encryption (tIBE) (aka conditional decryption or witness encryption) for its services as a chain. After reading this section you will understand:

1. What is IBE and tIBE
2. What basic functions are exposed to chains and Apps integrating with Fairblock

## Conditional Encryption (IBE)

Identity-based Encryption (also known as witness encryption or conditional decryption) enables the encryption of messages or transactions so that they can only be decrypted once a specific decryption condition—or witness—has been provided. This decryption condition or witness is often referred to as an identity or ID in the cryptographic literature.

In general, there are two modes of use:

Private Shared State (PSS):
This mode allows encrypting transactions that can be publicly decrypted and executed once a global condition has been met. Examples include a specific block number, an oracle update such as a price feed, a zero-knowledge proof, or certain smart contract calls.

Private Access Control (PAC):
This mode allows encrypting private data or transactions so that only an individual or a group of individuals sharing a particular attribute can decrypt and access the data locally. Examples include specific addresses, NFT owners, members of a community, or GPUs with certain IDs.

Fairblock employs threshold IBE, ensuring that no single party controls the decryption keys. Validators perform distributed key generation to produce a pair of keys:

Master Public Key (MPK):
The MPK, combined with the “decryption condition,” can be used to encrypt a transaction (or a batch of transactions) that will be decrypted and executed once the specified “decryption condition” is met.
encrypt(private data/tx, mpk, condition ID)

Master Secret Key Shares:
Each validator holds a share of the master secret key, preventing any single entity from reconstructing the full master secret key. Once the “decryption condition” is met, each validator uses its master secret key share to generate a private key share for all transactions encrypted under that condition. When a threshold (e.g., 2/3) of these private key shares is collected, they can be combined to form a private key that decrypts all transactions tied to that same condition. In the case of Private Shared State, the data is decrypted publicly; for access control, the data is decrypted only for those who meet the required attributes.

The above can be described in three equations.

### Encryption:

- Done with a function, called `encrypt()`.
- A user wants to encrypt their transaction, `m`, to later be decrypted and executed once the condition is met.
- The encrypted output will be represented by `c`.
- A unique ` condition id` will be obtained from Fairyring.
<!-- TODO - confirm where id comes from -->

$$
encrypt(m, master public key, condition id) = c
$$

### Decryption Key Extraction

- Done with a function, called `extract()`.
- Uses `id` to derive a decryption key, `pk`, to decrypt the respective encrypted transaction.

$$
extract(id) = pk
$$

### Decryption Using the Decryption Key

- Done with a function, called `decrypt()`.
- Uses encrypted transaction (ciphertext), `c`, and decryption key, `pk`, to obtain the original transaction details, `m`.

$$
decrypt(c,pk) = m
$$

> Altogether, one can see that the following property holds true when using IBE.

$$
decrypt(encrypt(m, id), extract(id)) = m
$$

## Threshold IBE (tIBE)

The `fairyring` chain not only provides the capabilities to encrypt, decrypt, and communicate with inherent apps on its chain, and destination chains, but it also does so in a decentralized way. It does this by splitting up the master secret key amongst it's decentralized validator set and in order to obtain the respective decryption key for each condition ID, a threshold, `t`, of validators need to present their parts of private key; explaining the term Threshold IBE.

At a high-level, this is done through Lagrange interpolation, where the private key can be mathematically derived.

Let's say that `a_0` below is the private key, to derive it we will need a threshold amount of private key shares to properly interpolate what it is.

<!-- TODO - better elaborate on the equation below's relevance. -->

$$
p(x) = a_0 + a_1 x + a_2 x^2 + \dots + a_(t+1) x^(t)
$$

<!-- TODO need to fix above equation but t import giving issues on build -->

This is done by having each validator take n parts of the master secret key every epoch, where a threshold, `t`, amount of validators need to present their part of the private key to aggregate the resultant private key for all transactions or data encrypted for the specific condition ID. Note that validators can frequently reuse their master secret key shares without running the DKG process and only use their master secret key share to generate private key shares for each condition ID. This is possible since the private key shares doesn't leak any information about the secret shares thanks to IBE.
