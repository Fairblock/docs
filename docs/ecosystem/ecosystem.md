---
sidebar_position: 0
---
# Ecosystem

Fairblock’s Dynamic Confidential Computing unlocks a new wave of blockchain applications by bringing confidentiality, efficiency, and credibility to Web3. It takes a thriving community to seize these opportunities and build a safer, more performant, and groundbreaking decentralized future.  

Check out our showcase projects, explore the ideas that need builders like you, and connect with the community pushing the boundaries of what's possible.  

See below for how the key features of Fairblock are used, showcase projects. Check out the [ideas page](https://fairblock.notion.site/Fairblock-Builders-Program-RFP-List-69cd0c7747904e89bd27257a359a80f1?pvs=74) for even more projects that are being built today or waiting for the right contributors.  

> Fill out this [type form](https://form.typeform.com/to/MtEp1IZ1) if you would like to discuss building any of these ideas with our Developer Relations team! 

---
## Examples Leveraging Confidential Computing

Fairblock has a vision of endless unique functions leveraging confidential computing. The FairyRing testnet has been live for over a year, and we're excited to explore new application ideas with various partners and the Fairblock ecosystem. Some present-day developments that are actively explored in applications are outlined in the table below.


| App Ideas | Selling Points | Partners / In Queue Exploration | *Tech Stack |
|-----------|---------------|----------------------------------|------------|
| **"Bank Messages" transferring tokens with a memo** | - Private, compliant messaging with tokens  <br> - Secure memo fields for institutional transactions | - Institutional partners working on compliant private transactions  <br> - Private order-books with several blockchain partners | A, F |
| **Encrypted Data DEXes** <br> **Gaming Loot Boxes** | - Loot boxes bring more attractive elements to onboard users from gaming to adjacent web3 gaming products | - XAI and other gaming ecosystems exploring hidden mechanics | B, C |
| **Private Data Marketplaces for AI Models** <br> **Content Behind Conditions and/or Paywalls** | - Self-managed data sold to AI agents or other actors in DEXes <br> - Confidential content access via smart contracts (ex. Twitter Content Gated Apps) | - New protocols similar to Vana  <br> - Exploration of apps where content is gated (e.g., Premium Twitter, FairyFans, etc.) | B, C |
| **Fair NFT Auctions** <br> **RWA auctions with regulatory processes** <br> **Fair token launch mechanisms** | - Prevents frontrunning, auction-leader maliciousness, and more in NFT and RWA auctions <br> - Confidential price discovery | - Arbitrum grant for sealed-bid auction infrastructure <br> - Plume for RWA auctions <br> - DeFi protocols utilizing fair token launches | D, E |
| **Fair and dynamic price discovery for intents** <br> **Fixed-Rate lending markets** | - Solvers bidding for intents using sealed-bid auctions to pursue truly fair intent pricing <br> - Lending and borrow rates both encrypted, such that a clearing price is found for both in a fair manner | - Arbitrum ecosystem DeFi projects <br> - Anoma <br> - SettleX | D, E |
| **Democratic governance systems where voting is truly confidential** | - Truly confidential on-chain voting <br> - Prevents governance manipulation | - Available as `x/privgov` module for Cosmos ecosystems | G |
| **Confidential Inference with AI** | - Confidential AI inference and on-chain machine learning <br> - Secure execution with privacy-preserving MPC and TEEs | - Ritual <br> - Quartz | H, I |

_*Technological Features from FairyRing to be Used_

_A. Encrypted Messages
B. Smart Contracts using General Conditions with Public Decryption
C. Smart Contracts using General Conditions with Private Decryption
D. Sealed-Bid Auctions
E. Smart Contracts using General Conditions with Sealed-Bid Auctions
F. Encrypted Messages with Compliant Settings
G. Private Governance
H. FHE (zkks)
I. MPC w/ TEEs_

## Showcase Projects  

The Fairblock ecosystem is rapidly expanding, with active development across DeFi, AI, gaming, and cross-chain infrastructure. Below are key areas where confidential computing is making a real impact, with links to deeper dives on each initiative. Further details are shared for each as well.

## Fair DeFi and Credible Auctions  

Fairblock is unlocking credible, confidential, and trustless financial mechanisms in DeFi. Leaderless, sealed-bid auctions are a core focus, enabling fair price discovery and reducing manipulation in everything from token sales to liquidation markets.  

### [DeBid Arbitrum Grant for Ecosystem Auctions](https://questbook.app/dashboard/?grantId=671a105a2047c84bb8a73770&chainId=10&isRenderingProposalBody=true&proposalId=6775ba29faef5017a8fafd6c)  

Fairblock has secured a large Arbitrum grant to build fully onchain confidential auction infrastructure for DeFi, NFTs, RWAs, and tokenized assets. By leveraging Stylus, Fairblock is bringing sealed-bid auctions onchain to enable more capital-efficient and credible auction mechanisms.  

This benefits a range of use cases, including:  

- Swaps and cross-chain routing  
- Perps and options settlement  
- Liquidations and fair token launches  

Stylus allows us to deploy Rust-based decryption contracts, making onchain sealed-bid auctions a reality within more chains and empowering users and protocols.  

### Anoma Sealed-Bid Auctions for General Intents  

Intent-based DeFi is a game-changer for performance but is still an emerging space with off-chain solvers becoming bottlenecks or monopolies. By integrating sealed-bid auctions into Anoma's intent-based system, Fairblock is creating a decentralized, confidential, and fair auction mechanism for matching liquidity.  

The first step is a DEX built on Anoma, where users can:  

- Specify intents and customize auction logic  
- Benefit from confidential, dynamic price discovery  
- Ensure fair and competitive solver selection  

Further innovations with Anoma and Fairblock will be announced soon.  

### Squid Sealed-Bid Auctions for Cross-Chain Intents  

Squid Router (powered by Axelar) enables cross-chain swaps, and Fairblock is working with Squid to bring confidential cross-chain intents to life.  

With FairyRing and Threshold IBE, Fairblock is enabling:  

- Fair and decentralized solver competition using sealed-bid auctions  
- Better price discovery and execution for users  
- Confidentiality in cross-chain swaps  

This is just the tip of the iceberg—cross-chain intents are still in their early days, and Fairblock is helping lead the charge in bringing confidential applications and decentralization to the space.  

### Fair Token Launches with Threshold-Encrypted Sealed-Bid Auctions  

Token launches have a history of being complex and unpredictable. Methods including dutch auctions, bonding curves, and AMM-based launches all introduce gameable mechanics that confuse participants and ultimately distort pricing.  

Fairblock brings confidential computing to token launches, making them simple, fair, and efficient:  

- Users submit sealed bids for tokens  
- Smart contracts determine the fair clearing price  
- Tokens are distributed, and refunds are processed automatically  

No confusion, just fair market pricing for everyone. Fairblock is working with token launchpad projects like Rova to bring this sealed-bid token launch mechanism and more to fruition.  

---

## Confidential AI  

### [Confidential AI Inference](https://medium.com/@0xfairblock/confidential-rituals-trustless-and-unstoppable-ai-with-dynamic-confidentiality-95ecaee66e4c)  

Fairblock and Ritual are building the future of confidential AI where onchain AI models can operate  without exposing sensitive data, inference logic, or outputs.  

With MPC-powered confidential inference, Fairblock is exploring the potential unlocks with:  

- Secure AI-powered decision-making in DeFi (e.g., optimal borrowing/lending parameters)  
- Private data marketplaces, where users can sell encrypted datasets for model fine-tuning  
- Trustless agent execution, ensuring AI agents don’t require direct wallet permissions  

By decentralizing AI execution and access control, Fairblock and Ritual are making AI-driven Web3 applications secure, confidential, and unstoppable.  

---

## Hidden Information GameFi  

One of the biggest challenges in blockchain gaming is the lack of hidden information, as blockchains are inherently transparent. This makes it difficult to implement even basic games like poker, where secrecy is essential.  

Fairblock’s confidential computing fixes this by bringing MPC-powered encryption to blockchain games. Some ideas within this realm, among many, include:  

- **Sealed-bid auctions with a twist** (bid games where a prize pool is given to the highest unique bid, where if two bids match, they cancel out)  
- **Verifiable randomness for fair gameplay** (provably fair onchain randomness with customizable delivery options, unlocking new game features, flexible infrastructure setup to accommodate different chain costs, and more)  
- **Secret moves and hidden cards** (poker, strategy games)  
- **Prediction games mechanisms** (Parimutuel prediction)

Building with Fairblock enables new blockchain game types where known fun aspects of traditional gaming meet decentralized ownership and financial innovation.  

Fairblock is already working with XAI to integrate confidential computing into GameFi, with developers using Fairblock Decrypter contracts on XAI’s testnet (via Arbitrum Stylus) to build the next generation of hidden-information blockchain games.  

---

## Join the Builders Pushing the Limits of Web3  

Fairblock’s Dynamic Confidential Computing is helping reshape Web3, making it safer and more efficient across DeFi, AI, cross-chain platforms, gaming, and more. Whether you’re a developer, researcher, or a general user, we’re happy to have you along for the ride.  

- Explore our showcase projects  
- Get involved in building the next big thing  
- Join the community and collaborate with top minds in Web3  

Ready to build? Check out our [ideas page](https://fairblock.notion.site/Fairblock-Builders-Program-RFP-List-69cd0c7747904e89bd27257a359a80f1?pvs=74) and start making an impact today.  
