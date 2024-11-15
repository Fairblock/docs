---
sidebar_position: 2
---

# Running a Testnet

Make sure you have installed the [`fairyring` binary](./installation.md) prior to following the instructions below.

## Initialize the `fairyring` node

1. Use `fairyringd` to initialize your node (replace the `NODE_NAME` with a name of your choosing):

```bash
fairyringd init NODE_NAME
```

2. If you are unable to get the genesis file from the link above:

```bash
cp ~/fairyring/networks/testnets/fairyring-testnet-3/genesis.json ~/.fairyring/config/genesis.json
```

3. Set peers in the `$HOME/.fairyring/config/config.toml`:

```bash
SEEDS=$(cat $HOME/fairyring/networks/testnets/fairyring-testnet-3/peers-node.txt)
echo $SEEDS
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$SEEDS\"/" $HOME/.fairyring/config/config.toml
```

4. Start the node

```bash
fairyringd start
```

## Next Steps

If you would like to become a validator in the testnet, please follow [this guide](./validating_on_testnet.md).

If you run into any issues, please refer to the [troubleshooting section](../faqs/troubleshooting_fairyring.md)
