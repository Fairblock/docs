# Sealed-Bid Auction Infrastructure on Arbitrum

## 1. Why sealed-bid auctions on Arbitrum?

Auctions are a core primitive for token launchpads, NFT primary sales, debt-
liquidations, and the emerging class of intent-based DeFi protocols.  
Today most on-chain auctions are transparent Dutch or English formats: easy to
build, but can be gamed and often fail to produce optimal price discovery. Sealed-bid auctions solve those issues but existing
implementations are typically off-chain and centralised, re-introducing trust
assumptions and single points of failure.

This section explains how to run a **fully on-chain, trust-minimised sealed-bid
auction system** native to Arbitrum.  We combine:

* **FairyRing threshold key management** to issue per-auction IDs a corresponding decryption key once the bidding window closes.  
* **Stylus decrypter contracts** that perform on-chain decryption.  
* **Gateway Contract + FairyPort relayer** for seamless message passing
  between FairyRing and Arbitrum.  

The result is **DeBid**: Bidders submit encrypted bids that stay private until the reveal time. When the bidding window closes, the decryption key is generated and used to decrypt and process all bids directly on chain.

<!-- #
Below is the steps to build and test sealed-bid auctions (DeBid) on Arbitrum Testnet.

## Requirements
First make sure you have both [Rust](https://www.rust-lang.org/tools/install) and [Go](https://go.dev/doc/install) installed on your system.
Use the below script to install Rust, Go, and the rest of dependencies (Ubuntu):
```sh
# Core packages
sudo apt-get update && sudo apt-get install -y \
  git curl build-essential make python3 python3-pip

# Go
sudo snap install go --classic   # or use official tarball

# Foundry
curl -L https://foundry.paradigm.xyz | bash
foundryup

# Docker
sudo apt-get install -y docker.io docker-compose
sudo usermod -aG docker $USER 

sudo apt-get install -y jq
```

Next, clone the following repositories and install them:
```sh
git clone https://github.com/Fairblock/DeBid.git 
cd DeBid
git clone https://github.com/Fairblock/GatewayContract.git
git clone -b feat/arbitrum https://github.com/Fairblock/fairyring.git
git clone https://github.com/Fairblock/fairyringclient.git
git clone https://github.com/Fairblock/ShareGenerationClient.git
git clone -b feat/evm-support --single-branch https://github.com/Fairblock/fairyport.git
git clone --recurse-submodules https://github.com/Fairblock/ArbitrumContracts.git

cd GatewayContract && forge build && cd ..
cd fairyringclient && go install && cd ..
cd ShareGenerationClient && go mod tidy && go install && cd ..
cd fairyring && make install && cd ..
cd fairyport && make install && cd ..
cd ArbitrumContracts && forge build && cd ..
```
Theabove repositories cover all required components for an end-to-end testing.
## Local Fairyring Setup
Run a local version of fairyring to provide encryption and decryption keys.
```sh
cd fairyring
make devnet-up
cd ..
```
## Gateway Contract Deployment 
Deploy the Gateway contract on Arbitrum Sepolia Testnet to facilitate the communication between FairyRing and Arbitrum.
```sh
cd GatewayContract
forge script script/Gateway.s.sol:GatewayScript --rpc-url $SEPOLIA_RPC_URL --private-key $DEPLOYER_KEY --broadcast
cd ..
```
## Fairyport Setup
Next, set up and run Fairyport to connect Gateway contract and Fairyring. Replace `${GATEWAY_ADDRESS}` with the address of Gateway contract deployed in the previous step and `${DEPLOYER_KEY}` with the same private key as used for Gateway development.
```
CONFIG_FILE="$HOME/.fairyport/config.yml"

mkdir -p "$(dirname "$CONFIG_FILE")"

cat >"$CONFIG_FILE" <<YAML
cosmosrelayconfig:
    derivepath: m/44'/118'/0'/0/0
    destinationnode:
        accountprefix: fairy
        chainid: fairyring_devnet
        grpcport: 9090
        ip: 127.0.0.1
        port: 26657
        protocol: tcp
    metricsport: 2224
evmrelaytarget:
    chainrpc:  ${ARBITRUM_SEPOLIA_RPC}
    contractaddress: ${GATEWAY_ADDRESS}
fairyringnodews:
    ip: 127.0.0.1
    port: 26657
    protocol: tcp
YAML

cd fairyport
touch .env
cat > .env <<EOF
EVM_PKEY=${DEPLOYER_KEY}
COSMOS_MNEMONIC="rend powder seat defy design column life tape second zebra myth cousin tell gravity good trash joy report eyebrow woman uncle lounge describe clarify"
EOF
nohup fairyport start --config $HOME/.fairyport/config.yml > fairyport.log 2>&1 </dev/null &
cd ..

```

## Decrypter Contract Deployment
In this step, we deploy the decrypter contracts on Arbitrum to later be used for decryption. Before running the below commands, make sure to set `PRIVATE_KEY_1` and `rpc_url` in `ArbitrumContracts/.env`:
```sh
cd ArbitrumContracts
./deploy_decryption_contracts_verbose.sh
cd ..
```
After running the above script, you will have the address of the Decrypter contract on Arbitrum.

## Creating and Testing an Auction
First deploy the MultiAuction contract which allows for creating several auctions. Replace `$DEPLOYED_DECRYPTER_ADDRESS` with the address of the deployed decrypter contract in the previous step.


```
source .env
forge create --broadcast --rpc-url $SEPOLIA_RPC_URL --private-key $AUCTIONEER_PRIVATE_KEY ./MultiAuctionV2.sol:MultiAuction --constructor-args $DEPLOYED_DECRYPTER_ADDRESS
```
Next, before creating an auction, get a new general ID (`FAIRYRING_ID`) from Fairyring to assign to our auction. `ADDR` is the :

```sh

  GATEWAY_ID=$(cast call $GATEWAY_ADDRESS "addressGeneralID(address)(uint256)" $AUCTIONEER_ADDR --rpc-url $SEPOLIA_RPC_URL)
  cast send $GATEWAY_ADDRESS "requestGeneralID()" --rpc-url $SEPOLIA_RPC_URL --private-key $AUCTIONEER_PRIVATE_KEY

  while true; do
    raw=$(cast call "$GATEWAY_ADDRESS" "fids(address,uint256)(string)" "$AUCTIONEER_ADDR" "$GATEWAY_ID" --rpc-url "$SEPOLIA_RPC_URL" 2>/dev/null || echo "")
    FAIRYRING_ID=$(echo "$raw" | tr -d '"[:space:]')
    [[ -n "${FAIRYRING_ID// }" ]] && { echo "✔️  Found FAIRYRING_ID: $FAIRYRING_ID"; break; }
    sleep 2
  done
```
Now, create a new auction using the `createAuction` function on the MutliAcution contract and pass `GATEWAY_ID` and `FAIRYRING_ID`.

In order to encrypt bids for the auction, first fetch the public key from Gateway contract and then use the encrypter tool for encryption:

```sh
cd ArbitrumContracts
PUBLIC_KEY=$(cast call $GATEWAY_ADDRESS "latestEncryptionKey()(bytes)" --rpc-url $SEPOLIA_RPC_URL)
PUBLIC_KEY=${PUBLIC_KEY#0x}

cd ./encrypter && go build && cd ../test-simple-auction-solidity
Encrypted=$(../encrypter/encrypter "$FAIRYRING_ID" "$PUBLIC_KEY" "$bid_value")
BID_DATA=$(python3 convert_to_array.py "$Encrypted")
```
Now, submit the `BID_DATA` as an encrypted bid to the auction using `submitEncryptedBid` function.

Once the auction deadline is reached, request and get the decryption key from Gateway contract:
```sh
  cast send --rpc-url $SEPOLIA_RPC_URL --private-key $AUCTIONEER_PRIVATE_KEY $GATEWAY_ADDRESS "requestGeneralDecryptionKey(uint256)" "$GATEWAY_ID"

  DECRYPTION_KEY=$(cast call "$GATEWAY_ADDRESS" "generalDecryptionKeys(address,uint256)(bytes)" $AUCTIONEER_ADDR $GATEWAY_ID --rpc-url "$SEPOLIA_RPC_URL")
  while [[ "$DECRYPTION_KEY" == 0x ]]; do
    echo "Decryption key not found, waiting..."
    sleep 2
    DECRYPTION_KEY=$(cast call "$GATEWAY_ADDRESS" "generalDecryptionKeys(address,uint256)(bytes)" $AUCTIONEER_ADDR $GATEWAY_ID --rpc-url "$SEPOLIA_RPC_URL")
  done
```
Having the `DECRYPTION_KEY`, repeately call `revealBids` to decrypt bids in batches of three and calculate the winner bid once all bids as decrypted.

## Test Script
All above steps from cloning the repositories up to creating and bidding and finallizing auctions can be performed and tested with our end-to-end script (`FullDeployScript.sh`)
Make sure to set required variables in `.env`.  -->


---

## 2. Quick-start variables

Below are the environment variables used in the process.

| Variable                     | Purpose                                         |
| ---------------------------- | ----------------------------------------------- |
| `SEPOLIA_RPC_URL`            | Arbitrum Sepolia endpoint                       |
| `DEPLOYER_KEY`               | Private key of an account on Arbitrum testnet used to deploy Gateway + sign FairyPort txs |
| `AUCTIONEER_PRIVATE_KEY`     | Private key of an account on Arbitrum testnet that creates auctions & triggers reveals    |
| `PRIVATE_KEY_1…5`            | Accounts that place test bids                   |
| `GATEWAY_ADDRESS`            | Filled after Gateway deployment                 |
| `DEPLOYED_DECRYPTER_ADDRESS` | Filled after decrypter deployment               |

---

## 3. Toolchain & environment setup
Install required tools and packages for the test setup.

```sh
# Ubuntu 22.04+

# Core packages
sudo apt-get update && sudo apt-get install -y \
  git curl build-essential make python3 python3-pip

# Go
sudo snap install go --classic   # or download the official tarball

# Foundry (forge & cast)
curl -L https://foundry.paradigm.xyz | bash
foundryup

# Docker (used by FairyRing)
sudo apt-get install -y docker.io docker-compose
sudo usermod -aG docker $USER   

sudo apt-get install -y jq      
```

---

## 4. Building components

Clone all required repos and build them exactly once:

```sh
git clone https://github.com/Fairblock/DeBid.git 
cd DeBid
git clone https://github.com/Fairblock/GatewayContract.git
git clone -b feat/arbitrum https://github.com/Fairblock/fairyring.git
git clone https://github.com/Fairblock/fairyringclient.git
git clone https://github.com/Fairblock/ShareGenerationClient.git
git clone -b feat/evm-support --single-branch https://github.com/Fairblock/fairyport.git
git clone --recurse-submodules https://github.com/Fairblock/ArbitrumContracts.git

cd GatewayContract          && forge build && cd ..
cd fairyringclient          && go install && cd ..
cd ShareGenerationClient    && go mod tidy && go install && cd ..
cd fairyring                && make install && cd ..
cd fairyport                && make install && cd ..
cd ArbitrumContracts        && forge build && cd ..
```
---

## 5. Local FairyRing devnet
Run an instance of FairyRing devnet using the below commnad:

```sh
cd fairyring
make devnet-up
cd ..
```

---

## 6. Deploying the Gateway on Arbitrum Sepolia

```sh
cd GatewayContract
forge script script/Gateway.s.sol:GatewayScript \
  --rpc-url $SEPOLIA_RPC_URL \
  --private-key $DEPLOYER_KEY \
  --broadcast
cd ..
```

Use the printed **Gateway address** as `GATEWAY_ADDRESS`.

---

## 7. Configuring & running FairyPort
Use the below script to configure and run FairyPort: 
```sh
CONFIG_FILE="$HOME/.fairyport/config.yml"
mkdir -p "$(dirname "$CONFIG_FILE")"

cat >"$CONFIG_FILE" <<YAML
cosmosrelayconfig:
    derivepath: m/44'/118'/0'/0/0
    destinationnode:
        accountprefix: fairy
        chainid: fairyring_devnet
        grpcport: 9090
        ip: 127.0.0.1
        port: 26657
        protocol: tcp
    metricsport: 2224
evmrelaytarget:
    chainrpc:  ${SEPOLIA_RPC_URL}
    contractaddress: ${GATEWAY_ADDRESS}
fairyringnodews:
    ip: 127.0.0.1
    port: 26657
    protocol: tcp
YAML

cd fairyport
cat > .env <<EOF
EVM_PKEY=${DEPLOYER_KEY}
COSMOS_MNEMONIC="rend powder seat defy design column life tape second zebra myth cousin tell gravity good trash joy report eyebrow woman uncle lounge describe clarify"
EOF

nohup fairyport start --config "$CONFIG_FILE" \
      > fairyport.log 2>&1 </dev/null &
cd ..

echo "FairyPort running in background."
```

---

## 8. Deploying the decrypter contracts and **MultiAuctionV2**

### 8.1 Decrypter

```sh
cd ArbitrumContracts
# ensure ArbitrumContracts/.env contains PRIVATE_KEY_1 and rpc_url for Arbitrum testnet
./deploy_decryption_contracts_verbose.sh
cd ..
```

Use the printed decrypter address as `DEPLOYED_DECRYPTER_ADDRESS`.

### 8.2 MultiAuctionV2
MultiAuctionV2 is a generalized auction contract capable of managing multiple concurrent sealed-bid auctions. It handles encrypted bid storage, auction lifecycle tracking, and bid reveal logic. 

Use the below command to deploy the MultiAuctionV2:

```sh
forge create --broadcast \
  --rpc-url $SEPOLIA_RPC_URL \
  --private-key $AUCTIONEER_PRIVATE_KEY \
  ./MultiAuctionV2.sol:MultiAuction \
  --constructor-args $DEPLOYED_DECRYPTER_ADDRESS
```

**Important:** This auction contract is a minimal reference implementation intended for demonstration only. Deploying to production will require further hardening and feature completion.

---

## 9. Auction lifecycle

### 9.1 Create FAIRYRING\_ID
To create a unique ID for an auction, first get the `GATEWAY_ID` corresponding to the `AUCTIONEER_ADDR` by calling `addressGeneralID()` on Gateway contract (`GATEWAY_ID` is a sequence that increments each time the user requests an ID). Then submit a request to the Gateway contract through `requestGeneralID()`and wait until the ID is generated. Once the ID is ready, it can be read from Gateway contract by calling the `fids()` with the `AUCTIONEER_ADDR` and `GATEWAY_ID`. This generated ID (`FAIRYRING_ID`) will be used by bidders to encrypt their bids.
```sh
GATEWAY_ID=$(cast call $GATEWAY_ADDRESS \
             "addressGeneralID(address)(uint256)" \
             $AUCTIONEER_ADDR --rpc-url $SEPOLIA_RPC_URL)

cast send $GATEWAY_ADDRESS "requestGeneralID()" \
  --rpc-url $SEPOLIA_RPC_URL --private-key $AUCTIONEER_PRIVATE_KEY

while true; do
  raw=$(cast call $GATEWAY_ADDRESS "fids(address,uint256)(string)" \
        $AUCTIONEER_ADDR $GATEWAY_ID --rpc-url $SEPOLIA_RPC_URL 2>/dev/null || echo "")
  FAIRYRING_ID=$(echo "$raw" | tr -d '"[:space:]')
  [[ -n ${FAIRYRING_ID// } ]] && break
  sleep 2
done
```

### 9.2 Create an auction

```sh
cast send --rpc-url $SEPOLIA_RPC_URL --private-key $AUCTIONEER_PRIVATE_KEY \
  $CONTRACT_ADDRESS \
  "createAuction(uint256,uint256,string,uint256)" \
  "$AUCTION_DEADLINE" 0 "$FAIRYRING_ID" "$GATEWAY_ID"
```

### 9.3 Encrypt & submit bids
In order to submit a bid, first fetch the latest active encryption key from Gateway contract. 
Next, use the encrypter tool (`ArbitrumContracts/encrypter`) to encrypt the bid using the encryption key and `FAIRYRING_ID` specific to this auction. Then reformat the encrypted data using the `ArbitrumContracts/test-simple-auction-solidity/convert_to_array.py` python script.
The final encrypted bid data can be submitted to the corresponding auction using the `AUCTION_ID` (a sequence number that increments with each auction creation).
```sh
PUBLIC_KEY=$(cast call $GATEWAY_ADDRESS "latestEncryptionKey()(bytes)" \
             --rpc-url $SEPOLIA_RPC_URL)
PUBLIC_KEY=${PUBLIC_KEY#0x}

cd ArbitrumContracts/encrypter && go build && cd ../test-simple-auction-solidity

Encrypted=$(../encrypter/encrypter "$FAIRYRING_ID" "$PUBLIC_KEY" "$bid_value")
BID_DATA=$(python3 convert_to_array.py "$Encrypted")

cast send --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY_1 \
  $CONTRACT_ADDRESS "submitEncryptedBid(uint256,uint8[])" \
  "$AUCTION_ID" "$BID_DATA" --value 0
```

### 9.4 Request key & reveal bids
Once the auction deadline is reached, the auctioneer can request and get the decryption key from Gateway contract. Then reformat the key using the same python script used for the bid data. The final decryption key can be submitted to the auction using `revealBids()` to decrypt the bids in batched of at most 3. If the number of submitted bids is more than 3, this function should be called repeatedly until all bids are decrypted and processed. Once this step is complete, the winner bidder and bid value can be read from the auction contract.
```sh
cast send --rpc-url $SEPOLIA_RPC_URL --private-key $AUCTIONEER_PRIVATE_KEY \
  $GATEWAY_ADDRESS "requestGeneralDecryptionKey(uint256)" "$GATEWAY_ID"

DECRYPTION_KEY=$(cast call $GATEWAY_ADDRESS \
                 "generalDecryptionKeys(address,uint256)(bytes)" \
                 $AUCTIONEER_ADDR $GATEWAY_ID --rpc-url $SEPOLIA_RPC_URL)
while [[ "$DECRYPTION_KEY" == 0x ]]; do
  sleep 2
  DECRYPTION_KEY=$(cast call $GATEWAY_ADDRESS \
                   "generalDecryptionKeys(address,uint256)(bytes)" \
                   $AUCTIONEER_ADDR $GATEWAY_ID --rpc-url $SEPOLIA_RPC_URL)
done

DECRYPTION_KEY=${DECRYPTION_KEY#0x}
DECRYPTION_KEY=$(python3 convert_to_array.py "$DECRYPTION_KEY")

# reveal in batches of three
cast send --rpc-url $SEPOLIA_RPC_URL --private-key $AUCTIONEER_PRIVATE_KEY \
  $CONTRACT_ADDRESS "revealBids(uint256,uint8[],uint256)" \
  "$AUCTION_ID" "$DECRYPTION_KEY" 3
```

---
## 10. Full end-to-end deployment script

We provide a single script that handles **every** step from cloning the
repositories to finalising several test auctions. To perform this end-to-end test, clone the `DeBid` repository and run the script:
(The script will ask you to add the environment variables in the `.env` file as needed.)
```bash
git clone https://github.com/Fairblock/DeBid.git 
cd DeBid
./FullDeployScript.sh
```
---
