---
sidebar_position: 4
---
# Fairyport

Fairyport is an off-chain service for fetching aggregated keyshares to Destination Chains from Fairyring. This tutorial explains how to setup & run fairyport. Ensure you have followed the [prerequisites](https://github.com/Fairblock/docs/blob/main/docs/running-a-node/prerequisites.md) and installed the [`fairyring binary`](https://github.com/Fairblock/docs/blob/main/docs/running-a-node/installation.md) prior to following the instructions below.

## Install `Fairyport`

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

## Setup `Fairyport`

Initialize `fairyport` config:

```bash
fairyport init
```

`init` command create a default config `config.yml` in the default directory `$HOME/.fairyport` . The config looks like this:

```yml
destinationnode:
    grpcport: 9090
    ip: 127.0.0.1
    port: 26657
    protocol: rpc
fairyringnode:
    grpcport: 9090
    ip: 127.0.0.1
    port: 26657
    protocol: rpc
mnemonic: '# mnemonic'
```

Detail explanation on the config:

**FairyRing Node**

| Option    | Description                                                                      |
|-----------|----------------------------------------------------------------------------------|
| ip        | The IP address that Fairy Ring Node will use.                                    |
| port      | The port that Fairy Ring Node will use for TendermintRPC                         |
| protocol  | The protocol used for communication via the TendermintRPC                        |
| grpcport  | The port that Fairy Ring Node will use for gRPC communication with other nodes.  |

**Destination Node**

| Option | Description |
| ---- | ---- |
| ip | The IP address that Destination Node will use. |
| port | The port that Destination Node will use for TendermintRPC |
| protocol | The protocol used for communication via the TendermintRPC |
| grpcport | The port that Destination Node will use for gRPC communication with other nodes. |

**Mnemonic**

|  Option   | Description                                                                      |
|-----------|----------------------------------------------------------------------------------|
| Mnemonic  | The seed phrase used to generate the private key for the account responsible for making transactions to the Destination Chain|

Update the node ip and ports for `fairyport` to connect to, `# mnemonic` to your mnemonic phase, `fairyport` derive your address with path `m/44'/118'/0'/0/0` by default. 

The updated config should looks like this:

```yml
FairyRingNode:
  ip: "127.0.0.1"
  port: 26657
  protocol: "tcp"
  grpcport: 9090

DestinationNode:
  ip: "127.0.0.1"
  port: 26659
  protocol: "tcp"
  grpcport: 9092

Mnemonic: "banana unusual correct orange dwarf fortune tennis sell primary giggle canal ask fish movie loud elite region glory session wonder frozen clap mountain barrel"
```

## Start `Fairyport`

After you setup `Fairyport`, you can start running `Fairyport` by:

```bash
fairyport start --config $HOME/.fairyport/config.yml
```
