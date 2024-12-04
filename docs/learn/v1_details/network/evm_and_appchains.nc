---
sidebar_position: 6
---
TODO: Finalize this section.

# How Fairblock Works with EVMs and Appchains

<!-- Details:
- Fairblock works with EVMs and Appchains. The main difference is that Appchains integrate with a typical module provided by Fairblock technologies, whereas EVM apps rely on precompiles integrated into the EVM itself.
- Outline key steps with Appchains (where encrypted txs are stored, etc.)
- Outline key steps with EVM Apps (communicating with immutable contract that exposes precompile functions) -->



## EVMs

<!-- EVM Chains:

How to integrate:
- custom precompile
- fairyport relayer

- on EVM, pep module doesn't exist anymore
- all we need on EVM is a way to decrypt transactions in a gas efficient manner.

Precompile
- custom logic for functions that are too expensive to be implemented in EVM op-code
- charge custom gas per function call

custom precompile: decrypt(c, pk) = m stored in a contract 0x000000000D, call{0x0000000D, data}

Solidity smart contract can now:
1. emit events for custom id request
2. store the received custom id
3. store the encrypted transactions
4. condition verification to request for decryption key
5. use decryption key (decrypt(c, pk) on all your encrypted transactions)
6. execute whatever logic you want now.

Ex.
Encrypt(Uniswap swap, oracle_price) = c

Store c inside a smart contract.
Smart contract verify(price) -> bool,
when true, emit RequestKeyEvent(oracle_price)

fairyport picks it up, tells fairyring to generate the decryption key, once generated sends back

contract:

Tx[] encrypted_tx;

call {
    call {0x0000000D, encrypted_tx[1], pk } = uniswap swap 1
    call {0x0000000D, encrypted_tx[2], pk } = uniswap swap 2
}



 -->


## Appchains

<!-- Cosmos Chains:

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
6. Decrypted and executed in begin block of D-Chain

 -->
