---
sidebar_position: 2
---

# EVMs Modified with Pre-Compiles

Welcome to the Fairblock and EVM Integration Tutorial. Please note that the App Quickstart within these docs is the exact same content as the repo README (aside from Fairblock context in the repo). They are placed in different locations for convenience to the reader.

_**‼️ All code within this tutorial is purely educational, and it is up to the readers discretion to build their applications following industry standards, practices, and applicable regulations.**_

A walk through of this tutorial, alongside context on Fairblock, EVM integration, and Arbitrum Orbit is provided in the video below. If you prefer learning by reading on your own, feel free to skip it and continue onward in this README!

<div style={{ textAlign: "center" }}>
  <iframe
    width="100%"
    height="315"
    src="https://www.youtube.com/embed/79pSFHolMuI?si=dubh8pPQKypHThBp"
    title="Fairblock tIBE with EVMs - Orbit Chain Integration Tutorial"
    frameBorder="0"
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
    referrerPolicy="strict-origin-when-cross-origin"
    allowFullScreen
    style={{ maxWidth: "560px" }}
  ></iframe>
</div>

> **This tutorial focuses on the deployment of pre-compiles logic into an EVM. This can be done for any EVM.**

Today's tutorial focuses on showcasing this using an Arbitrum Orbit chain (L3). The pre-compiles allow developers and traditional EVM smart contracts to integrate with Fairblock FairyRing network, thus unlocking the power of a dynamic confidentiality network.

Typical integration steps, including the use of software such as the `Encrypter` and `FairyPort`, for transaction encryption and communication between the FairyRing and Destination chains, respectively, is not focused on or omitted from this tutorial. Please see the advanced sections for further detail pertaining to these two and other more detailed integration steps.

This tutorial has multiple steps, but to get developers building as fast as possible we have developed a quickstart consisting of running only a few bash commands and scripts.

<!-- > If you would like to learn more about the steps involved underneath these bash scripts, and thus making up this repo, jump to the section after the Quickstart, [Detailed Tutorial](./README_detailed.md) -->

By the end of this tutorial, developers will have:

- Part 1: Deploy their own EVM with Fairblock pre-compiles into an Arbitrum Orbit chain that communicates with the Arbitrum Sepolia test network. This will result in accessible Fairblock functionality at address 0x94 on the Orbit Chain, hosted by a Docker Container locally within this tutorial.
- Part 2: Deploy and test a Sealed Bid Auction smart contract, written in Solidity, working with the pre-compiles logic from Part 1.
  - The underlying contracts and scripts will provide developers a sense of the integration process with the Orbit chain pre-compile logic and ultimately Fairblock's testnet, FairyRing.

As always, please feel free to skip to the respective part you are interested in. Smart Contract Developers who want to work within an EVM that has Fairblock precompiles can do so by using the [example smart contracts within this repo as a reference](https://github.com/Fairblock/ArbitrumContracts/blob/master/test-simple-auction-solidity/SealedBidAuctionExample.sol). For chain developers, the details on the precompiles will be of most interest. There are details on the precompiles [near the end of this README](#the-pre-compiles-deployed-into-an-evm).

> If there are any questions, or if you would like to build with the Fairblock ecosystem, please join our [discord](https://discord.gg/jhNBCCAMPK)!

---

## Quickstart

Firstly, clone both of these repos onto your machine, and make sure you use the correct branch:

1. This repo - **make sure to use the branch `feat/fairblock-demo-orbit-chain`**: [Orbit Chain Setup Repo](https://github.com/hashedtitan/orbit-setup-script)
2. This repo - **make sure to use the branch `feat/fairblock-precompile`**: [Nitro Repo with Precompiles](https://github.com/hashedtitan/nitro)

The `nitro` repo will have the pre-compiles within its code and be running a node within a local docker container. The `orbit-setup-script` repo is a fork from Arbitrum Orbit that has pre-deployed chain contract config files within it. These two repos were made for the sake of time for this Quickstart. If you would like to learn more and go through the steps underlying the quickstart today, please see our docs.

At a high-level, what needs to be done now includes the following (don't worry we'll expand on everything step by step):

1. Run the docker container for the modified nitro node so it running persistently on your local machine.
2. Running your orbit-chain locally where it ties into the local node instead of the typical nitro node setup from Arbitrum.

Make sure you have docker running. If you are new to docker, simply follow the instructions to install Docker Desktop provided on [Docker's website](https://www.docker.com/products/docker-desktop/). As well, make sure you have `jq` installed too, a lightweight command-line JSON processor. For MacOS and Linux supporting Homebrew, simply run `brew install jq`. On Windows, use an appropriate package manager to install `jq`.

## Dependencies

Within the `nitro` repo, at the root, run the following command to install the dependencies.

```shell
git submodule sync
git submodule update --init --recursive --force
```

Within the `orbit-setup-script` repo (this one), run `yarn` to install its dependencies.

## Start the Local Docker Container for The Modified Nitro Node

First, go to your nitro repo, and find a folder called `quickstart`. Within this folder, you will find a version of `contracts.go` that has the FairBlock pre-compiles already added in.

Move the `contracts.go` to the path `go-ethereum/core/vm`, replacing the `contracts.go` file already there.

Next, go back to the `quickstart` folder and move the `nodeConfig.json` file to the `config` folder. This config file corresponds to the registered Arbitrum Orbit Chain contracts on Arbitrum Sepolia that we have gone ahead and implemented. Again, these are just for educational purposes and not production.

With all that in place, run the following command to regenerate your `nitro-node` docker image locally:

```bash
make docker
```

Run the following command within the terminal inside of your local nitro repo:

```bash
docker run --rm -it -v $(pwd)/config:/home/user/.arbitrum -p 8449:8449 nitro-node-dev --conf.file /home/user/.arbitrum/nodeConfig.json
```

What this is doing:

- Creating a nitro node local docker container running in the background until it is closed.
- Exposing it via port 8449
- Tagging the docker container under the name `nitro-node-dev`

Now you have your nitro node running locally. You can now setup your Orbit chain and run tests with a sealed bid auction example on said chain.

## Setup the Orbit Chain Repo with Pre-Deployed and Initialized Orbit Contracts

For those new to Arbitrum technologies, here are the main pre-requisite knowledge to understand the tutorial:

- Arbitrum Orbit (Orbit) is a framework to create L2s or L3s with many different configurations.
- By default, it settles onto the Arbitrum One L2, and thus leverages the security of Ethereum Mainnet.
- New Orbit chains are deployed with initial registration on the respective settlement layer, typically Arbitrum One, but can be Nova or other settlement layers.

Within this orbit-setup-script repo, you will find a folder called `quickstart` where there are two config JSON files. These JSON files correspond to a pre-initialized orbit chain and susbsequent smart contracts related to the Arbitrum Sepolia Orbit Chain Factory smart contract and process.

Simply move these files to the `config/` directory. Now this repo will work with the config details for the pre-existing orbit chain.

> This is simply to avoid having to set up a brand new orbit chain and its respective Arbitrum Sepolia Orbit Chain Factory smart contracts each time for the quickstart. This process can be seen here within the Arbitrum [docs](https://docs.arbitrum.io/launch-orbit-chain/orbit-quickstart).

## Building Out the Dependencies, setting up `.env` and Running Sealed Bid Auction Tests

Now that the config files are where they need to be, build the project out (installing submodules, rust, foundry) by running the following:

```bash
./build.sh
```

This should take about 1-2 minutes but may vary based on your internet connetion speeds.

Next, make sure to update your .env.

> a `.env` file is provided with ready-to-go wallets with a pre-deployed Orbit Chain for your convenience. Please do not go and drain the ETH from these wallets, there's no point anon, it's a test Orbit chain. 💁🏻‍♂️

Finally, we can deploy the the Sealed Bid Auction test contract and run tests against it. This showcases the use of the precompiles within the nitro node on your local docker container. Run the test script by running:

```bash
./sealedBidAuction.sh
```

That's it! At this point you have deployed the Fairblock pre-compile logic onto an EVM, via an Orbit Chain running on your local docker container, and tested it with a sealed bid auction example.

When it comes to the Sealed Bid Auction Example, you will see terminal logs showing that:

- A Sealed Bid Auction Example contract was deployed,
- Encrypted bids were made in the auction, where the encrypted aspect was the bid amount itself using Fairblock technologies.
- Two bids from different private wallets (as per the `.env`) are made, and then the auction ends.
- The sealed bid auction was completed and a winner has been announced with a bid of 200.

## Congratulations

Your local Orbit chain is now running. Let's recap what you've accomplished through this quickstart:

- Modified an EVM such that it works with precompiled functionality specific to FairyRing confidentiality technology.
- Deployed an Arbitrum Orbit chain, `Fairyring Orbit Chain Demo`, that has base contracts registered to the Arbitrum Orbit ecosystem on the Arbitrum Sepolia Testnet.
- Connected the `Fairyring Orbit Chain Demo` to an EVM with encryption and decryption functionality, via a modified nitro node, all in a local docker container.
- Deployed, and ran a sealed bid auction using the functionality of the Fairblock precompiles on the new EVM Orbit Chain

The key checkpoints highlighted have now provided the key steps to include when modifying your own custom EVM chain to use the FairyRing functionalities. For more specific questions, please reach out either on [Discord](https://discord.gg/jhNBCCAMPK).

**Now that you have gone through the quickstart, feel free to dig into other tutorials or build with fellow Fairblock devs! If you would like a bit of detail on pre-compiles and the Sealed Bid Auction example, read onward. Otherwise, consider this the end of the quickstart tutorial!**

## The Pre-Compiles Deployed into an EVM

The functionality enabled by the Fairblock pre-compiles is highlighted below.

The `nitros` repo is the base EVM code that includes the precompiles, contracts and main functionality of the chain.

- When it comes to the dependencies, here are some notes:
  - The IBE encryption, kyber bls dependencies are needed for encryption and the types specifically from the latter library. Some of the sub-modules are not in there, so we need to update the submodules within the nitro repo as well.
- When it comes to the actual Pre-Compile implementation logic:
  - They’re all in one part: contracts.go
    - Inside contracts.go you’ll see all the details.

The actual code modifications added to the `contracts.go` file within the nitros repo mainly revolve around:

- The `decrypt()`function
  - for all of the pre-compiles, there’s an entry point, the RUN function at the bottom.
  - This function calls the actual function we want, in this case it is decrypt().
  - The two inputs: decryption key, cyphertext concatenated together where the first 96 bytes is the decryption key and the rest is the cyphertext.
  - In terms of the rest of the function: we need to convert the decryption key to the right type.
  - We start with one G2 point (from the BLS library), and need to read the cipherbytes to a cipher buffer.
  - From there, it uses all of these inputs and calls the Decrypt() library to output the plain text.
    - DistributedIBE is the library that has DECRYPT() in it and it relies on it
- Once that is all complete, the appropriate pre-compile address, `0x94` is established in the respective `PrecompileContract` vars such that it can be accessed from said address on the new EVM network that we are revising. In the tutorial's case, it's the Arbitrum Orbit Chain.

## The Sealed Bid Auction Files

The Sealed Bid Auction files can be found within the directory `test-simple-auction-solidity`. Within it, you will see a solidity file, `SealedBidAuctionExample.sol`, and a `test.sh` file.

The Sealed Bid Auction:

- Simply stores bid amounts for an auction from bidders into the smart contract storage. The bids are kept encrypted using Fairblock encryption off-chain.
  - Fairblock repos such as `Encrypter` and `ShareGenerator` are used for this process for educational purposes.
- Bids are then revealed using the Decryption process from Fairblock Technologies.
- The winning bid is announced.

For the sake of the tutorial, typical smart contract aspects such as transference of ERC20s, ETH, or other tokens are not focused on within the smart contract. There are common patterns for the transference of funds. **The key thing to notice within these solidity files is that conditional encryption and decryption can be used easily within a solidity smart contract by leveraging Fairblock v1 technologies.**

All a developer really needs to do to start developing an auction contract that actually transfers values is follow typical smart contract patterns and take the decrypted bid amounts once the auction is over to carry out respective transactions.

<!-- If you are interested in going through setting up a new orbit chain, and integrating the pre-compiles into it, see the [README_detailed.md](./README_detailed.md) file. -->
