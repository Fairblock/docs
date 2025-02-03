---
sidebar_position: 3
---

# Running a cApp on an EVM

What if you want to run a cApp on a different network? Well you're in luck anon. This tutorial is a bit longer than 5 minutes, but it's worth it 😉.

As mentioned throughout the docs, FairyRing and its power of confidential computation can be used within many other networks, not limited to but including: EVMs, Cosmos chains, and RustVM chains.

So let's start simple, and run your first cApp with an EVM leveraging FairyRing and its dynamic confidential computation. In this tutorial, you will run a Simple Sealed Bid Auction where encrypted bids are made, and once the auction is complete, are decrypted and assessed for the winning bid. The tutorial is ran using an testnet Arbitrum Orbit L3 Chain that has already been deployed for purely educational purposes. 

> This demo is expanded on more in detail within this [EVM tutorial inside of the build section](../build/evms/evms.md). The scripts alongside the tutorial README within the tutorial repo can be assessed further to help understand the workflow of integrating into an EVM.

<!-- TODO: make a script to make this truly only 5 minutes -->

Firstly, clone both of these repos onto your machine, and make sure you use the correct branch:

1. This repo - **make sure to use the branch `feat/fairblock-demo-orbit-chain`**: (Orbit Chain Setup Repo)[https://github.com/hashedtitan/orbit-setup-script]
2. This repo - **make sure to use the branch `feat/fairblock-precompile`**: (nitro Repo with Precompiles)[https://github.com/hashedtitan/nitro]

Within the `nitro` repo, at the root, run the following command to install the dependencies.

```shell
git submodule sync
git submodule update --init --recursive --force
```

Within the `orbit-setup-script` repo (this one), run `yarn` to install its dependencies.

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

Within this orbit-setup-script repo, you will find a folder called `quickstart` where there are two config JSON files. These JSON files correspond to a pre-initialized orbit chain and susbsequent smart contracts related to the Arbitrum Sepolia Orbit Chain Factory smart contract and process.

Simply move these files to the `config/` directory. Now this repo will work with the config details for the pre-existing orbit chain.

> This is simply to avoid having to set up a brand new orbit chain and its respective Arbitrum Sepolia Orbit Chain Factory smart contracts each time for the quickstart. This process can be seen here within the Arbitrum [docs](https://docs.arbitrum.io/launch-orbit-chain/orbit-quickstart).

Inside of the orbit-setup-script repo, with the config files are where they need to be, build the project out (installing submodules, rust, foundry) by running the following:

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

====

Using this example, many interesting apps can be built within EVMs. Make sure to join our [discord](https://discord.gg/jhNBCCAMPK) to discuss new ideas. A list of interesting ideas, currently worked on and to be worked on, will be available soon.

