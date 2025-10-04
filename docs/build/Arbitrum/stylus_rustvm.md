---
sidebar_position: 6
---

# Arbitrum General Integration

Welcome to the Fairblock and RustVM Integration Tutorial, showcased with an Arbitrum Stylus chain that allows Fairblock Rust contracts to be deployed onto the integrating chain. This [repo](https://github.com/Fairblock/ArbitrumContracts) was used for the DevCon 2024 Stylus tutorial featuring Fairblock. Feel free to follow the `README` in the Fairblock ArbitrumContracts [repo](https://github.com/Fairblock/ArbitrumContracts), or follow this walk through (which is exactly the same and placed here for convenience).

> **If you are looking to learn how to build an app that integrates with Fairblock on a Stylus network, and already have the Decrypter modules and other setup complete, skip further into the [video!](https://www.youtube.com/watch?v=gIzPgSw11uU&t=1178s) Otherwise, keep going anon.**

> **This tutorial focuses on the integration path for RustVMs looking to work with Fairblock. It revolves around the deployment of decryption contracts onto said RustVM. Specifically, the tutorial showcases this by using Arbitrum Stylus, onto an EVM, specifically Sepolia. The decryption contracts allow developers and traditional EVM smart contracts to integrate with Fairblock by writing rust contracts onto an EVM, thus unlocking the power of a dynamic confidentiality network.**

<div style={{ textAlign: "center" }}>
  <iframe
    width="100%"
    height="315"
    src="https://www.youtube.com/embed/gIzPgSw11uU?si=SL-UlKg6DDzT9Ntg"
    title="RustVM Integration Tutorial (w/ Arbitrum Stylus Example)"
    frameBorder="0"
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
    referrerPolicy="strict-origin-when-cross-origin"
    allowFullScreen
    style={{ maxWidth: "560px" }}
  ></iframe>
</div>

Fairblock is a dynamic confidentiality network that delivers high performance, low overhead, and custom confidential execution to blockchain applications. Dynamic confidentiality unlocks the encrypted economy — onchain applications designed for real-world use cases, like optimizable financial markets, competitive PVP markets like auctions, predictions, and gaming, and privacy-preserving inference.

V1 is live on testnet with bespoke MPC-IBE which offer conditional confidentiality (for pre-execution confidentiality, sealed-bid auctions, selective disclosure, encypted limit orders etc) and HE for confidential stablecoin transfers.

> Typical integration steps, including the use of software such as the `Encrypter` and `FairyPort`, for transaction encryption and communication between the FairyRing and Destination chains, respectively, is not focused on or omitted from this tutorial. Please see the advanced sections for further detail pertaining to these two and other more detailed integration steps.

This tutorial has multiple steps, but to get developers building as fast as possible we have developed a quickstart consisting of running two bash scripts.

<!-- > If you would like to learn more about the steps involved underneath these bash scripts, and thus making up this repo, jump to the section after the Quickstart, [Detailed Tutorial](../../../build/evm_apps/stylus_detailed_quickstart.md) -->

By the end of this tutorial, developers will have:

- Part 1: Deploy their own Fairblock v1 tech stack into an Arbitrum Stylus integrated network, Sepolia. This will result in a deployed `Decrypter` contract on the Sepolia network.
- Part 2: Deploy and test a Sealed Bid Auction smart contract, written in Solidity, with the Decrypter contract from Part 1.
  - The underlying contracts and scripts will provide developers a sense of the integration process with the Stylus contracts and ultimately Fairblock's testnet, FairyRing.

> If there are any questions, or if you would like to build with the Fairblock ecosystem, please join our [Discord](https://discord.gg/fairblock)!

---

## A Word on Auctions

You may ask, why are we working with a Sealed Bid Auction as an example? Let's touch briefly on the importance of auctions, especially in a landscape that can integrate dynamic confidentiality networks.

Confidential decentralized auctions safeguard users against exploits like shilling, auctioneer/block proposer last looks, and bid censorship. This approach ensures credible, optimized outcomes for users in terms of execution quality and pricing.

By aligning incentives and enhancing credibility, confidential auctions enable impactful applications across various areas, including intents’ solver auctions, MEV supply chains, single-round Dutch auctions, NFTs, real-world assets (such as real estate, ads, traditional finance, or power dispatching systems), restricted access control to boost market efficiency, and innovative SocialFi applications like highest unique bid auctions.

For more information on auctions, refer to:

• [AFT 2024 Paper](https://drops.dagstuhl.de/storage/00lipics/lipics-vol316-aft2024/LIPIcs.AFT.2024.19/LIPIcs.AFT.2024.19.pdf)
• [Paradigm Leaderless Auctions](https://www.paradigm.xyz/2024/02/leaderless-auctions)
• [Arxiv Paper](https://arxiv.org/abs/2404.00475)

Simplicity is the pinnacle of art. Fairblock’s tailored confidentiality schemes deliver robust economic and cryptographic security without adding delays or bandwidth overhead, avoiding the pitfalls of overly complex, general-purpose cryptographic methods.

With all that, let's jump into the tutorial!

---

## Quickstart

1. General Setup: Make sure you have docker running. If you are new to docker, simply follow the instructions to install Docker Desktop provided on [Docker's website](https://www.docker.com/products/docker-desktop/). As well, make sure you have `jq` installed too, a lightweight command-line JSON processor. For MacOS and Linux supporting Homebrew, simply run `brew install jq`. On Windows, use an appropriate package manager to install `jq`.

2. Build the project; installing submodules, rust, stylus, foundry.

Run:

```bash
./build.sh
```

Update your .env, if you forget to, you can follow prompts that come up in the terminal when running the next command.

3. Deploy the decryption contracts, take the newly deployed `Decrypter` smart contract and update your `.env`, and subsequently deploy and test an example sealed bid auction. You will see all of this occurring within the `stylusTutorial.sh` script.

Run:

```bash
./stylusTutorial.sh
```

That's it! At this point you have deployed the decrypter contracts enabled by Stylus and Fairblock, a sealed bid auction example, and finally tested against it with two bidders on Sepolia.

When it comes to the Decryption contract deployments, what you will see within your terminal are detailed logs revolving around the deployment and initialization of the contract addresses on Sepolia.

When it comes to the Sealed Bid Auction Example, you will see terminal logs showing that:

- A Sealed Bid Auction Example contract was deployed,
- Encrypted bids were made in the auction, where the encrypted aspect was the bid amount itself using Fairblock.
- Two bids from different private wallets (as per the `.env`) are made, and then the auction ends.
- The sealed bid auction was completed and a winner has been announced with a bid of 150.

With the code running, let's dig into more of the details.

---

## The Decryption Contracts Deployed Using Arbitrum Stylus on Sepolia

The script `deploy_decryption_contracts_verbose.sh` is what is actually run to deploy the decryption contracts.

### The Decryption Contracts Details and Context

The decryption process involves 5 contracts. Below is a breakdown of each contract and their respective gas consumption:

#### 1. **IBE Contract (Hashing)**

- **Functionality:** Verifies the correctness of the ciphertext based on the Boneh-Franklin Condition ID-Based Encryption (BF-IBE) algorithm. It calculates a hash over the message and sigma, multiplies it by `P`, and verifies that the result matches the `U` component in the ciphertext.
- **Gas Consumption:** ~1,587,000
- **Key Contributor:** Scalar and G1 point multiplication, consuming 1,366,619 gas.

#### 2. **IBE Contract**

- **Functionality:** Decrypts the ciphertext and recovers the message (which is the symmetric key for the second layer of encryption). It leverages the IBE Contract (Hashing) for ciphertext validation.
- **Gas Consumption:** ~1,742,000(~1,587,000 of this comes from the IBE Contract (Hashing))
- **Note:** The majority of the gas consumption comes from the hashing contract.

#### 3. **ChaCha20 MAC Contract**

- **Functionality:** Computes the MAC for the ciphertext header using the key and ciphertext body.
- **Gas Consumption:** ~72,000
- **Note:** Minimal gas usage.

#### 4. **ChaCha20 Decryption Contract**

- **Functionality:** Performs symmetric key decryption using the provided key and returns the plaintext.
- **Gas Consumption:** ~55,000
- **Note:** Minimal gas usage.

#### 5. **Decryption Interface Contract**

- **Functionality:** Serves as the main interface for the decryption process. It accepts the decryption key and ciphertext, invoking the appropriate contracts to perform the full decryption.
- **Gas Consumption:** ~9,189,000
- **Breakdown:**
  - IBE, MAC, and ChaCha20 contracts: As described above.
  - ~1,565,000: Deserializing the decryption key.
  - ~5,445,000: Pairing operation.

> NOTE: The deployment script used is the more verbose bash script. If you would like a less verbose script, please check out `deploy_decryption_contracts.sh`. Although, currently that script is under development. The more verbose script will be presented by Fairblock at the DevCon 2024 Conference. Whereas the other is still undergoing final development.

---

### The Sealed Bid Auction Files

The Sealed Bid Auction files can be found within the directory `test-simple-auction-solidity`. Within it, you will see a solidity file, `SealedBidAuctionExample.sol`, and a `test.sh` file.

The Sealed Bid Auction:

- Simply stores bid amounts for an auction from bidders into the smart contract storage. The bids are kept encrypted using Fairblock encryption off-chain.
  - Fairblock repos such as `Encrypter` and `ShareGenerator` are used for this process for educational purposes.
- Bids are then revealed using the Decryption process from Fairblock.
- The winning bid is announced.

For the sake of the tutorial, typical smart contract aspects such as transference of ERC20s, ETH, or other tokens are not focused on within the smart contract. There are common patterns for the transference of funds. **The key thing to notice within these solidity files is that conditional encryption and decryption can be used easily within a solidity smart contract by leveraging Fairblock v1.**

All a developer really needs to do to start developing an auction contract that actually transfers values is follow typical smart contract patterns and take the decrypted bid amounts once the auction is over to carry out respective transactions.

The world unlocked with the dynamic confidentiality network provided by Fairblock is vast. As the ecosystem onboards more partners, we will write more tutorials and additional content building off of simple examples such as this. This quickstart simply shows an example of a sealed bid auction that can exist on a Arbitrum Stylust Integrated network. Thus there are far more possibilities to build.

Congratulations! You have now completed the quick start version of the Arbitrum Stylus and Fairblock FairyRing v1 quickstart tutorial.

<!-- If you are interested in going through the repo, step-by-step, versus using the two scripts, `build.sh`, `stylusTutorial.sh`, check out the detailed version of this tutorial within the [docs](../../../build/evm_apps/stylus_detailed_quickstart.md). -->
