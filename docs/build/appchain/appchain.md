---
sidebar_position: 0
---

# Appchain Tutorials

<!-- 
Cosmos Chains:

How to integrate:

1. pep module (required)
2. private gov module (optional)
3. wasm module (optional)
4. fairyport relayer (chain selects some addresses which can be relayers)

if 1 - 4 are present, then D chain can:
1. submit encrypted transactions
2. have decrypted transactions be executed in BeginBlock
3. request custom IDs and decryption keys via IBC
4. If private gov, private voting
5. If wasm, conditional decryption
6. fairyport will submit decryption keys per fairying block
7. fairyport will submit master public key updates from fairyring

Developer side:

1. frontend gets master public key from D-Chain
2. the user (or applicaiton on behalf of user) would select a decryption height (custom id)
3. the user would sign the transaction (tx)
4. SubmitEncryptedTransaction(Encrypt(tx, custom_id)) to pep module on D-Chain
5. Wait for decryption key
6. Decrypted and executed in begin block of D-Chain -->
