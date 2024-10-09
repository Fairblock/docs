---
sidebar_position: 1
---

# Developer Quickstart: Encrypt & Decrypt with EVMs & AppChains

<!-- Define the key gotchas of how apps and appchains work with Fairblock tech.
- Split this section into AppChain & EVMs
- Provide relevant SDKs
- Provide a quick start repo showcasing key simple integration points (easily understood for ppl wanting to bring it to their own projects)
- Deploy quickstart example to test appchains and test EVMs (that are compatible) -->

## What is an Encrypted/Decrypted App?

<!-- TODO - replace encrypted/decrypted with a name for apps that use fairblock - we need to finalize that term -->
An encrypted/decrypted App or Appchain unlocks programmable encryption and paired conditional decryption and execution using Fairblock's decentralized appchain, Fairyring.

Key concepts to help with the quickstart are:

- Apps or AppChains have active communication with the Fairyring chain. This communiation mainly consists of two steps:

   1. App or Appchain listens to the Fairyring for new Master Public Keys (MPKs) to encrypt their respective transactions.
   2. Fairyring listens for a condition, and corresponding ID, to trigger generating a decryption key (keyshare).
   3. Once generated, keyshare is shared with the respective App or Appchain. The App or Appchain then executes the transaction at the beginning of the block to avoid risks arising from delayed execution.

<!-- Show visual for apps and appchains talking to Fairyring -->

<!-- TODO - Consider either adding in schematic showing that the tx is executed at the beginning of the block, or do this in the learn section. I opt for the learn section. -->

## Start Building Encrypted/Decrypted Apps with Fairblock

There are two tutorials within this Quickstart:

1. [Encrypt & Decrypt with EVMs](TODO-GetLink)
2. [Encrypt & Decrypt with AppChains](TODO-GetLink)

Follow each of these tutorials to build either an app or appchain to:

1. Clone the respective repo and set up your dev environment
2. Write, compile, and test your first encrypted/decrypted app using Fairblock in a local dev environment
