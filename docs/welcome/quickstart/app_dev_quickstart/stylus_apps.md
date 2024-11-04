---
sidebar_position: 1
---

# Stylus App Quickstart

The first version, v1, of this quickstart simply has Fairblock technologies deployed using rust and Arbitrum Stylus onto the respective test network.

The intent of this tutorial is to have:

- Deployed fairblock technologies via several rust contracts using Arbitrum Stylus into the respective Arbitrum test network.
- Provide a solidity smart contract that interacts with the main Fairblock `Decrypter` contract that provides Fairblock decryption methodologies.
- Run simple tests showcasing the new smart contract carrying out conditional decryption and execution using the `Decrypter`.

The repo for this tutorial can be found [here](https://github.com/Fairblock/ArbitrumContracts). For convenience, steps to set up and walk through the tutorial are listed below as well.

---
# Decryption Contracts


Run the following command to clone the appropriate repo:

```bash
git clone https://github.com/Fairblock/ArbitrumContracts.git
cd ArbitrumContracts
```

This repository includes the contracts implemented to perform the IBE decryption process on Arbitrum chain. 

## Contract Description and Gas Consumption

The decryption process involves 5 contracts. Below is a breakdown of each contract and their respective gas consumption:

### 1. **IBE Contract (Hashing)**
- **Functionality:** Verifies the correctness of the ciphertext based on the Boneh-Franklin Identity-Based Encryption (BF-IBE) algorithm. It calculates a hash over the message and sigma, multiplies it by `P`, and verifies that the result matches the `U` component in the ciphertext.
- **Gas Consumption:** ~1,587,000
  - **Key Contributor:** Scalar and G1 point multiplication, consuming 1,366,619 gas.

### 2. **IBE Contract**
- **Functionality:** Decrypts the ciphertext and recovers the message (which is the symmetric key for the second layer of encryption). It leverages the IBE Contract (Hashing) for ciphertext validation.
- **Gas Consumption:** ~1,742,000(~1,587,000 of this comes from the IBE Contract (Hashing))
  - **Note:** The majority of the gas consumption comes from the hashing contract.

### 3. **ChaCha20 MAC Contract**
- **Functionality:** Computes the MAC for the ciphertext header using the key and ciphertext body.
- **Gas Consumption:** ~72,000
  - **Note:** Minimal gas usage.

### 4. **ChaCha20 Decryption Contract**
- **Functionality:** Performs symmetric key decryption using the provided key and returns the plaintext.
- **Gas Consumption:** ~55,000
  - **Note:** Minimal gas usage.

### 5. **Decryption Interface Contract**
- **Functionality:** Serves as the main interface for the decryption process. It accepts the decryption key and ciphertext, invoking the appropriate contracts to perform the full decryption.
- **Gas Consumption:** ~9,189,000
  - **Breakdown:**
    - IBE, MAC, and ChaCha20 contracts: As described above.
    - ~1,565,000: Deserializing the decryption key.
    - ~5,445,000: Pairing operation.


## Testing


This project contains multiple contracts, each with its own test scripts and examples for deployment and interaction on the blockchain. These tests demonstrate how the contracts can be used both independently and from within another contract (e.g., an application contract).

### Overview

#### Contract Testing

- **Rust Contract**: Implements a basic auction application where bids are encrypted and decrypted using decrypter contracts once the decryption key is provided. For simplicity, some checks have been removed. This example is only to demonstrate how to use the decryption contracts and is not suitable for production use.
- **Solidity Contract**: Implements a contract that allows the submission of encrypted messages and decrypts them once a key is submitted.

Both contracts can be tested using their respective `test.sh` files in their corresponding folders.

#### Network Configuration

By default, all contracts will be deployed on the Arbitrum testnet. However, the RPC URL can be modified in the `test.sh` scripts if you wish to use another network.

#### Addresses and Private Key Setup

Addresses for the deployed contracts are hardcoded in the decrypter contract and ibe contract. You can modify these addresses by replacing them with newly deployed contract addresses if necessary. Ensure that you have a private key (`sk`) set to an account on the Arbitrum testnet (if testing on the testnet) that has enough funds to cover gas fees for deploying and interacting with the contracts.

### Installation Requirements

Before running the tests, ensure that the following dependencies and tools are installed:

#### 1. Install Rust Nightly Toolchain

The test scripts use a specific nightly version of Rust. Install and configure Rust by running:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup install nightly-2024-05-20
rustup override set nightly-2024-05-20
```

You also need to install the following target:
```bash
rustup target add wasm32-unknown-unknown
```

 #### 2. Install Foundry and Cast
Foundry is used for deploying Solidity contracts and interacting with the blockchain. Install Foundry and initialize it:

```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```
Verify that both forge and cast are installed correctly:
```bash
forge --version
cast --version
```
#### 3. Install Stylus
Stylus is required for deploying Rust contracts. Install it via Cargo:
```bash
cargo install --force cargo-stylus
```
#### 4. Private Key Setup
You will need a private key to interact with the blockchain. You can replace the <PRIVATE_KEY> placeholder in the scripts.

### Running Tests

Navigate to the contract folder, for educational purposes, we advise looking at the `test-simple-auction-solidity` directory. It goes over a simple sealed bid auction example.

```bash
cd test-simple-auction-solidity
```
Run the test script:
```bash
./test.sh
```

Review the bash script, `./test.sh` for a better understanding of how the solidity smart contract example interacts with the `Decrypter` contract.
