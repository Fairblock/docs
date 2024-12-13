---
sidebar_position: 1
---

# EVM App Tutorials

This page is under progress and will be updated shortly.

<!-- TODO - fill out with EVM tutorial as we develop them -->

<!-- TODO: some ideas below from past chats with Bowen, port over to a github issue once the patterns repo is started.
  -->
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
