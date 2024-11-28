---
sidebar_position: 4
---

# `fairyport`

`fairyport` is an off-chain service for sending aggregated keyshares to destination chains from `fairyring`.
This tutorial explains how to setup and run `fairyport`.
Ensure you have followed the [prerequisites](https://github.com/Fairblock/docs/blob/main/docs/running-a-node/prerequisites.md) and installed the [`fairyring` binary](https://github.com/Fairblock/docs/blob/main/docs/running-a-node/installation.md) prior to following the instructions below.

## Install `fairyport`

1. Cloning the repository:

```bash
cd $HOME
git clone https://github.com/Fairblock/fairyport.git
cd fairyport
```

2. Install `fairyport` binary:

```bash
go mod tidy
go install
```

## Setup `fairyport`

Initialize `fairyport` config:

```bash
fairyport init
```

`init` command create a default config `config.yml` in the default directory `$HOME/.fairyport` . The config looks like this:

```yml
cosmosrelayconfig:
    derivepath: m/44'/118'/0'/0/0
    destinationnode:
        accountprefix: fairy
        chainid: fairyring-testnet-3
        grpcport: 9090
        ip: 127.0.0.1
        port: 26657
        protocol: tcp
    metricsport: 2224
    mnemonic: '# mnemonic'
evmrelaytarget:
    chainrpc: wss://ws.sketchpad-1.forma.art
    contractaddress: 0xcA6cC5c1c4Fc025504273FE61fc0E09100B03D98
fairyringnodews:
    ip: 127.0.0.1
    port: 26657
    protocol: tcp
```

Detailed explanation on the config:

**Cosmos Relay Config**

| Option           | Description                                                                |
|------------------|----------------------------------------------------------------------------|
| Destination Node | The Destination Cosmos Node to relay to.                                   |
| Metrics Port     | The port that lets prometheus collect metrics                              |
| Mnemonic         | The seed phrase used making transactions to the Destination Chain          |
| Derive Path      | The path Fairyport uses to derive the private key from the mnemonic phase. |

**Destination Node**

| Option         | Description                                                      |
|----------------|------------------------------------------------------------------|
| IP             | The IP address that Destination Cosmos Node.                     |
| Port           | The port that Destination Cosmos Node will use for TendermintRPC |
| Protocol       | The protocol used for communication via the TendermintRPC        |
| gRPC Port      | The port that Destination Node will use for gRPC communication.  |
| Chain ID       | The chain id of the destination cosmos chain.                    |
| Account Prefix | The account prefix of the Destination Cosmos Chain.              |

**EVM Relay Target**

| Option             | Description                                             |
|--------------------|---------------------------------------------------------|
| Chain RPC          | The WS endpoint to the Destination EVM chain            |
| Contract Address   | The Fairyring Contract address on Destination EVM chain |

**Fairyring Node WS**

| Option   | Description                                      |
|----------|--------------------------------------------------|
| IP       | The IP address of given Fairyring node endpoint. |
| Port     | The Port of the given Fairyring node endpoint.   |
| Protocol | The Protocol of Fairyring node endpoint.         | 

### Update Config

1. Update the `ip`, `protocol` and `port` in the `fairyringnodews` no matter which type of chain (EVM / Cosmos) you want the aggreagated keyshares to relay to.

2. Depends on which type of chain you want to relay to

- Relaying to **COSMOS** Chain:
  - Update `cosmosrelayconfig` config
  
- Relaying to **EVM** Chain:
  - Update `evmrelaytarget` and add the private key in hex without '0x' prefix to `EVM_PKEY` environment variable.

- Relaying to **BOTH** Chain:
  - Update all config, and add the private key in hex without '0x' prefix to `EVM_PKEY` environment variable.


For the EVM chain private key, you can do one of the following:

1. Pass the environemnt variable to `fairyport` when starting it
  
```bash
EVM_PKEY=your_hex_private_key fairyport start --config $HOME/.fairyport/config.yml
```

2. Set the environment before running `fairyport`
   
```bash
export EVM_PKEY=your_hex_private_key
fairyport start --config $HOME/.fairyport/config.yml
```

3. Create a `.env` file in the same directory you are running `fairyport`

```bash
EVM_PKEY=your_hex_private_key
```

then run `fairyport start --config $HOME/.fairyport/config.yml`

#### Example

##### Relaying to ONLY EVM Chain

`$HOME/.fairyport/config.yml`

```yml
cosmosrelayconfig: # can just leave the entire section as is
    derivepath: m/44'/118'/0'/0/0
    destinationnode:
        accountprefix: fairy
        chainid: fairyring-testnet-3
        grpcport: 9090
        ip: 127.0.0.1
        port: 26657
        protocol: tcp
    metricsport: 2224
    mnemonic: '# mnemonic' 
evmrelaytarget:
    chainrpc: wss://ws.sketchpad-1.forma.art # Update to target EVM chain websocket endpoint
    contractaddress: 0xcA6cC5c1c4Fc025504273FE61fc0E09100B03D98 # Update to Fairyring Contract Address on target EVM chain
fairyringnodews:
    ip: 127.0.0.1 # Update to Fairyring node IP
    port: 26657 # Default port for the node is 26657, update if it is set to other
    protocol: tcp # Should always be TCP
```

and also setting the `EVM_PKEY` environment variable

##### Relaying to ONLY COSMOS Chain

`$HOME/.fairyport/config.yml`

```yml
cosmosrelayconfig: 
    derivepath: m/44'/118'/0'/0/0 # Update derive path if needed
    destinationnode:
        accountprefix: dest # Update to destination chain account prefix
        chainid: destination-chain-id # Update to destination chain chain id
        grpcport: 9090 # Update to destination chain endpoint grpc port
        ip: 127.0.0.1 # Update to destination chain endpoint ip
        port: 26657 # Update to destination chain endpoint rpc port
        protocol: tcp # Protocol should always be TCP, change if needed
    metricsport: 2224 # Update the metrics port if you would like the metrics running on different port
    mnemonic: 'banana unusual correct orange dwarf fortune tennis sell primary giggle canal ask fish movie loud elite region glory session wonder frozen clap mountain barrel' # Update to your mnmonic phase
evmrelaytarget: # can just leave the entire section as is
    chainrpc: ''
    contractaddress: '' 
fairyringnodews:
    ip: 127.0.0.1 # Update to Fairyring node IP
    port: 26657 # Default port for the node is 26657, update if it is set to other
    protocol: tcp # Should always be TCP
```

##### Relaying to BOTH Chain

`$HOME/.fairyport/config.yml`

```yml
cosmosrelayconfig: 
    derivepath: m/44'/118'/0'/0/0 # Update derive path if needed
    destinationnode:
        accountprefix: dest # Update to destination chain account prefix
        chainid: destination-chain-id # Update to destination chain chain id
        grpcport: 9090 # Update to destination chain endpoint grpc port
        ip: 127.0.0.1 # Update to destination chain endpoint ip
        port: 26657 # Update to destination chain endpoint rpc port
        protocol: tcp # Protocol should always be TCP, change if needed
    metricsport: 2224 # Update the metrics port if you would like the metrics running on different port
    mnemonic: 'banana unusual correct orange dwarf fortune tennis sell primary giggle canal ask fish movie loud elite region glory session wonder frozen clap mountain barrel' # Update to your mnmonic phase
evmrelaytarget:
    chainrpc: wss://ws.sketchpad-1.forma.art # Update to target EVM chain websocket endpoint
    contractaddress: 0xcA6cC5c1c4Fc025504273FE61fc0E09100B03D98 # Update to Fairyring Contract Address on target EVM chain
fairyringnodews:
    ip: 127.0.0.1 # Update to Fairyring node IP
    port: 26657 # Default port for the node is 26657, update if it is set to other
    protocol: tcp # Should always be TCP
```

and also setting the `EVM_PKEY` environment variable

## Start `fairyport`

After you setup `fairyport`, you can start running `fairyport` by:

```bash
fairyport start --config $HOME/.fairyport/config.yml
```
