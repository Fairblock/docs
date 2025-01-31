---
sidebar_position: 0
---

# Fairblock and Cryptography

Fairblock Network has three core functions:

1. Offload confidential compute for a network of blockchains and applications requiring confidentiality.
2. Host an ecosystem of [next-generation applications](https://www.notion.so/69cd0c7747904e89bd27257a359a80f1?pvs=21) that are only possible with native in-protocol access to dynamic confidentiality.
3. Orchestrate custom protocol/app needs with specialized MPEC clusters of our validator set.

For the protocols and applications leveraging Fairblock, our network offers optimized Multi-Party Encrypted Computation and multimodal cryptography techniques. These MPEC schemes include cryptographic computations such as threshold decryption, computation over encrypted data, private input verification, re-encryption and randomness. TEEs and ZKPs are not required for most MPEC applications. However, Fairblock’s multimodal cryptography approach can leverage them for complementary security-in-depth and further optimization. Accessible confidential computation will expedite the development of cutting-edge apps that require confidentiality.

## Fairblock V1

For our V1, we’ve launched FairyRing on testnet with threshold condition id-based encryption (TIBE), an encryption scheme built for pre-execution confidentiality.

Learn more about the v1 architecture, including its cryptography and network design [here](./v1_overview.md).

Compared to alternative encryption schemes, [we chose to deliver TIBE](https://eprint.iacr.org/2024/1516.pdf) in our V1 because it is lightweight, efficient, compliant and addresses 90% of the use cases for onchain confidentiality today without needing added complexity like zero-knowledge computation. These referred-to use cases are confidential AI supply chains and optimized onchain markets.

For more sensitive applications within emerging encrypted economies such as confidential inference there are additional needs beyond IBE and tradeoffs to consider between use cases, performance, and security before the network can offer additional confidentiality schemes. We’re expanding the functionality of our network in V2 to offer specialized MPEC and confidentiality solutions such as SPDZ, BDOZ, CKKS, tracing algorithms, and hybrid multimodal designs that combine multiple confidentiality solutions catered towards specialized use cases. Read more about our plans below.

## V2: Extending the Dynamic Confidentiality Network

There is no one-size-fits-all solution for confidentiality services — they exist on a spectrum, each requiring different operational and technical overhead and consisting of various tradeoffs. To serve the widest range of confidentiality needs for AI and DeFi applications, we are partnering with Symbiotic to expand our dynamic confidentiality network with specialized clusters of our operator set customized to execute concentrated confidentiality needs. These clusters will be connected by their shared participation in FairyRing and secured by the Fairy token. FairyRing orchestrates the allocation of confidential computation to the most capable clusters and coordinates fee distribution as well as slashing penalties in cases of misbehavior.

These clusters deliver specialized confidentiality solutions to applications requiring tailored economic and cryptographic security. Examples of tailored solutions include:

- MPEC + TEE network for collaborative snarks, threshold decryption, or decentralized inference.
- ZK + MPEC networks to prove the validity of private inputs or correct execution of computations over encrypted data.
- Networks will require custom economic security based on the sensitivity of the data they are securing. Clusters allow for programmatic security, which can change depending on the stage and needs of reliant protocols or apps.

[**Read our announcement with Symbiotic for more information.**](https://medium.com/@0xfairblock/introducing-dynamic-operator-sets-secured-by-symbiotic-53fd2b0ecdef)

## Our Partners

Fairblock is the confidentiality station for an ecosystem of native applications, protocols, and external apps that leverage our network for confidential execution. The right integration paths for our partners depend on which delivers the most optimal use cases, performance, and security needed.

### External Integration Paths

**FairyKit: Confidentiality in a Click**

Fairblock plugs into any chain via a confidentiality module that allow enables confidential execution inside smart contracts. There are a variety of developer and user needs for confidentiality — whether for encrypting the state of smart contracts or application logic, protecting trading strategies, or enforcing coercion resistance inside governance polls or prediction markets. Each of these use cases can be brought into any chain or application with a simple 15-minute FairyKit installation.

FairyKit is available on testnet to all Cosmos and EVM chains.

**Glue + Coprocessor Architectures**

Many established blockchains have high integration barriers for new infrastructure and may not be able to quickly support FairyKit. This is where the [glue and coprocessor architecture](https://vitalik.eth.limo/general/2024/09/02/gluecp.html) comes in.

Leading blockchain VMs are mainly optimized for general computation that is not very resource-intensive. Instead, these VMs should act as the “glue” for a number of specialized opcodes, precompiles, or hardware like ASICs, GPUs, and CPUs that act as coprocessors for more specialized and resource-intensive computation. With this architecture, complex computation can be processed FairyRing and delivered to Ethereum and other established chains for efficient in-contract processing.
