---
sidebar_position: 4
---

# `FairyPort`

`FairyPort` is an off-chain service for sending aggregated keyshares to destination chains from `fairyring`.
This tutorial explains how to setup and run `FairyPort`.
Ensure you have followed the [prerequisites](https://github.com/Fairblock/docs/blob/main/docs/running-a-node/prerequisites.md) and installed the [`fairyring` binary](https://github.com/Fairblock/docs/blob/main/docs/running-a-node/installation.md) prior to following the instructions below.

## Install `FairyPort`

1. Cloning the repository:

```bash
cd $HOME
git clone https://github.com/Fairblock/fairyport.git
cd fairyport
```

2. Install `FairyPort` binary:

```bash
go mod tidy
go install
```

## Setup `FairyPort`

Initialize `FairyPort` config:

```bash
fairyport init
```

`init` command create a default config `config.yml` in the default directory `$HOME/.fairyport` . The config looks like this:

```yml
FairyRingNode:
  grpcport: 9090
  ip: 127.0.0.1
  port: 26657
  protocol: rpc
DestinationNode:
  grpcport: 9090
  ip: 127.0.0.1
  port: 26657
  protocol: rpc
Mnemonic: '# mnemonic'
```

Detailed explanation on the config:

**FairyRingNode**

| Option   | Description                                                                     |
| -------- | ------------------------------------------------------------------------------- |
| ip       | The IP address that Fairy Ring Node will use.                                   |
| port     | The port that Fairy Ring Node will use for TendermintRPC                        |
| protocol | The protocol used for communication via the TendermintRPC                       |
| grpcport | The port that Fairy Ring Node will use for gRPC communication with other nodes. |

**DestinationNode**

| Option   | Description                                                                      |
| -------- | -------------------------------------------------------------------------------- |
| ip       | The IP address that Destination Node will use.                                   |
| port     | The port that Destination Node will use for TendermintRPC                        |
| protocol | The protocol used for communication via the TendermintRPC                        |
| grpcport | The port that Destination Node will use for gRPC communication with other nodes. |

**Mnemonic**

| Option   | Description                                                                                                                   |
| -------- | ----------------------------------------------------------------------------------------------------------------------------- |
| Mnemonic | The seed phrase used to generate the private key for the account responsible for making transactions to the Destination Chain |

Update the node ip and ports for `FairyPort` to connect to and `Mnemonic` to your mnemonic phase.
Note that `FairyPort` derives your address with path `m/44'/118'/0'/0/0` by default.

The updated config should looks like this:

```yml
FairyRingNode:
  ip: '127.0.0.1'
  port: 26657
  protocol: 'tcp'
  grpcport: 9090

DestinationNode:
  ip: '127.0.0.1'
  port: 26659
  protocol: 'tcp'
  grpcport: 9092

Mnemonic: 'banana unusual correct orange dwarf fortune tennis sell primary giggle canal ask fish movie loud elite region glory session wonder frozen clap mountain barrel'
```

## Start `FairyPort`

After you setup `FairyPort`, you can start running `FairyPort` by:

```bash
fairyport start --config $HOME/.fairyport/config.yml
```
