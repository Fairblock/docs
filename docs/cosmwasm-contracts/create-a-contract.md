---
sidebar_position: 1
---

# Create a cosmwasm contract

The  [cosmwasm-book](https://book.cosmwasm.com/basics.html) provides a detailed step by step documentation on how to write a simple cosmwasm contract.

Sample contracts can also be found in [cosmwasm-examples](https://github.com/deus-labs/cw-contracts/tree/main).

For the rest of this tutorial, we use the `to-do-list` contract from the above link as an example.

## Compile the contract

Inside the contract directory, run the following command to compile and build the contract (In this example, the corresponding directory is: `cw-contracts/contracts/cw-to-do-list`). Note that in order to use this command, `docker` needs to be installed on the system: 
```sh
docker run --rm -v "$(pwd)":/code \
  --mount type=volume,source="$(basename "$(pwd)")_cache",target=/code/target \
  --mount type=volume,source=registry_cache,target=/usr/local/cargo/registry \
  cosmwasm/rust-optimizer:0.12.11

```

Running the above command will generate a `.wasm` file stored in the `artifacts` folder. Next step is to store the contract on chain. For this purpose, a funded account on the FairyRing testnet is required. 
Fairblock's testnet faucet can be used for funding the accounts. An account can be added to the keyring using the following command:

```sh
fairyringd keys add wallet
```

Now, this account can be used to deploy and use the contract on the testnet.
For this purpose, first the contract should be stored on chain:
This command requires the testnet rpc url: `https://testnet-rpc.fairblock.network:443`, the testnet's chain id: `fairyring-testnet-1`, and specifies the gas amount and the path to the built contract. 

```sh
RES=$(fairyringd tx wasm store artifacts/cw_to_do_list.wasm --from wallet --node https://testnet-rpc.fairblock.network:443 --chain-id fairyring-testnet-1 --gas 4925931 --gas-adjustment 1.3 -y --output json -b sync)

echo $RES
```
The output of the above command prints the tx hash which can be used to query the logs using the below command:

```sh
fairyringd query tx ${tx-hash} --node https://testnet-rpc.fairblock.network:443
```
In the logs, the code id can be found which will then be used to instantiate the contract as follows:
The instantiation command requires an input which depends on the required input for the contract's instantiate function. Since for this example, the `to-do-list` contract is used, the instantiate function requires no input which will be passed as `"{}"`. The instantiation also requires specifying an admin (here specified as `--no-admin`) and a label (here specified as `test`).

```sh
RES=$(fairyringd tx wasm instantiate ${code-id} "{}" --from wallet --no-admin --label test --node https://testnet-rpc.fairblock.network:443 --chain-id fairyring-testnet-1 --gas 4925931 --gas-adjustment 1.3 -y --output json -b sync)

echo $RES
```

Querying the tx hash of the above tx shows the contract address in the logs. Now the contract is ready to interact with. The contract can be executed using its specific inputs. For the `to-do-list` contract, an example execution is adding and entry as follows:

```sh
RES=$(fairyringd tx wasm execute ${contract-address} '{"new_entry":{"description":"test_entry", "priority":"low"}}' --from wallet --node https://testnet-rpc.fairblock.network:443 --chain-id fairyring-testnet-1 --gas 4925931 --gas-adjustment 1.3 -y --output json -b sync)

echo $RES
```

