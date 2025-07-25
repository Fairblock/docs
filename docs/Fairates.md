---
sidebar_position: 4
---

# Fairates

***Leaderless sealed‑bid fixed‑rate lending: the way TradFi already does it, finally onchain.***

---

## TL;DR

Traditional Finance (TradFi) has been relying on sealed-bid, single-price auctions to sell trillions of dollars of fixed-rate debt (US Treasury bills and repo) because they hide order flow and clear at a single, fair price. By contrast, onchain lending is dominated by variable-rate even as appetite for fixed income soars. The fixed-rate auction designs in the market today still leak bids by keepers. Fairates brings TradFi’s auction model onchain with *leaderless* sealed-bid auctions: one fixed rate for everyone who wins and no one can censor or frontrun your order. 

- TradFi solved fixed‑rate lending [decades ago](https://home.treasury.gov/system/files/136/archive-documents/upas.pdf) with sealed‑bid, single price auctions so nobody can copy‑trade you, everyone clears at one fair rate, and price discovery is fast. The [U.S. Treasury](https://www.treasurydirect.gov/auctions/how-auctions-work/) still finances itself this way.
- DeFi lending is massive ([$65B+ TVL](https://defillama.com/protocols/lending)) but still mostly floating‑rate. Fixed‑rate income is clearly in demand, but fixed‑rate lending itself is still tiny and leaks information.
- Morpho V2 [announced](https://morpho.org/blog/morpho-v2-liberating-the-potential-of-onchain-loans/) fixed‑rate, fixed‑term direction, but bids are remain fully exposed onchain. Fairates runs the auction itself confidentially and leaderlessly, then settles onchain at a single clearing rate.
- Fairates: leaderless, sealed‑bid auctions (no privileged decryptor, no manipulation, no slippage tax) that clear one fixed rate for all winners, replicating how the world’s largest debt markets already operate.

---

## What TradFi already figured out and DeFi hasn’t

The largest, safest fixed‑income markets use sealed‑bid, single‑price auctions because they hide order‑flow, prevent copy‑trading, and clear everyone at the same price. The U.S. Treasury runs uniform‑price auctions; [repo](https://www.bis.org/publ/cgfs59.pdf) and commercial paper are also priced in tightly run, information‑minimizing markets.

In contrast, DeFi lending today:

- $65+B of lending TVL is still predominantly floating‑rate (Aave, Compound, Morpho Blue, Spark, JustLend, etc.)
- Fixed‑income demand is exploding (Pendle alone has [$6B](https://defillama.com/protocol/pendle)+ TVL) but the *lending* side of fixed‑rate is still underserved and often leaks information.
- Early fixed‑rate lenders like [Term Finance](https://www.blocmates.com/articles/term-finance-introducing-collateralized-fixed-rate-auctions-on-chain) run auctions, but keepers still reveal bids, which re‑introduces leakage and coordination risk.
- AMMs impose an implicit tax (slippage and price impact). Notional highlighted 10 bps [slippage](https://gov.angle.money/t/new-yield-strategy-fixed-rate-lending-on-notional-finance/285) on a $1M stablecoin trade. Auctions clear one rate for everyone.

---

## Why auctions beat AMMs for fixed‑rate credit

Single‑price sealed‑bid acutions provide:

1. One price for everyone: no AMM curve to climb.
2. Encrypted bidding until the end: no copy trading, no frontrunning.
3. Deterministic price discovery at a fixed time, not a constantly shifting curve.

This is why the [US Treasury](https://www.treasurydirect.gov/auctions/how-auctions-work/) standardized on single‑price auctions. Fairates is bringing that muscle memory onchain.

---

## Why now

- The market is asking for fixed‑rate, fixed‑term rails (Morpho V2), and fixed‑income trading is booming (Pendle). Tom Zschach, Swift’s Chief Innovation Officer, is raising [concerns](https://www.linkedin.com/feed/update/urn:li:activity:7354149262349271040/) about information leakage and the need for “selective confidentiality.” Fairates is arriving exactly as the market realizes fixed‑rate price discovery and confidentiality are the missing pieces.
- Institutions are here: [Coinbase](https://www.coinbase.com/en-ca/blog/now-get-a-USDC-loan-without-selling-your-bitcoin) baked Morpho loans directly into the app. Those same institutions will not leak size or intent if they can avoid it. Confidential auctions are the obvious bridge.
- TradFi’s [playbook](https://home.treasury.gov/system/files/136/archive-documents/upas.pdf) says auctions are superior to AMMs for fixed‑rate credit. Fairates has the cryptography (MPC, DKG, IBE) to deliver it in DeFi *without* a trusted auctioneer.

---

## Introducing Fairates

**Fairates**: a fixed‑rate lending market that clears via a *leaderless*, sealed‑bid, single‑price auction.

- **Leaderless**: there is no trusted auctioneer who can decrypt, censor, or peek. Decryption keys are split among a decentralized validator set via MPC and DKG (multi‑party computation + distributed key generation).
- **Sealed‑bid**: your size, rate, and timing stay confidential until the auction closes.
- **Single clearing rate**: every winning lender and borrower gets the same fixed rate, like a Treasury auction.
- **Composable**: the resulting fixed‑rate notes can be tokenized and traded in DeFi without leaking the original bid sizes.

---

## How Fairates works

1. Pick your term (e.g., 4 weeks) and the rate you want.
2. Submit an encrypted bid. Nobody (not even Fairates) can see it.
3. Auction closes: decentralized decryption (no leader, no privileged key).
4. One fixed clearing rate is determined.
5. Winners settle onchain: borrowers get their loan; lenders receive a fixed‑income note they can hold to maturity.

---

## Go‑to‑Market Strategy

**Objective**: Make “Confidential Fixed‑Rate” a default button next to every major lending UI and every yield trading venue.

### Where we launch & who we serve first

- Chains: Testnet live on Arbitrum. Next up Hyperliquid L1 (where speed and native orderbook UX matters and confidentiality is a selling point). Arbitrum already [supports](https://questbook.app/dashboard/?isRenderingProposalBody=true&proposalId=6775ba29faef5017a8fafd6c&grantId=671a105a2047c84bb8a73770&chainId=10) Fairblock’s sealed‑bid infrastructure and we capitalize on that momentum.
- First users:
    - Whales/yield farmers holding USDC and ETH looking earn yield with rate certainty
    - DAO and protocol treasuries that budget quarterly and hate showing their hand
    - Funds and market makers that need block liquidity without slippage

### **Distribution via Morpho (coopetition)**

Morpho V2 is launching a fixed‑rate/fixed‑term product, validating market demand. The strategy is to slot in as the confidentiality and price discovery layer for users who (a) move above a set amount and (b) want rate certainty without leaking intent.

- “Confidential Fixed‑Rate” tab inside Morpho’s interface: identical UX, but bids are sealed and cleared at a single uniform price. Morpho already proved it will surface non‑native flows e.g. [Coinbase](https://morpho.org/blog/coinbase-launches-crypto-backed-loans-powered-by-morpho/) loans is powered by Morpho. We are exploring the inverse: Morpho surfaces Fairates auctions for its users.
- Morpho routes bids above a certain size to Fairates’ sealed-bid auction to avoid AMM slippage and MEV leakage, then settles the result back to the user.

Value for Morpho:

- They get institutional‑grade orderflow that currently won’t touch open mempools.
- They keep the user relationship and settlement. We increase the total fixed‑rate pie instead of fighting over it.

### **Secondary liquidity via Pendle**

- Tokenize Fairates’ fixed‑rate notes (principal and coupon): Pendle traders can price, hedge, or lever them without ever seeing the original auction sizes.
- Pendle benefits from new, clean, encrypted amount fixed‑rate supply while Fairates benefits from deep secondary market liquidity and discoverability.
- We pitch Pendle a joint “Fixed‑Rate Income Hub”: Fairates mints primary fixed‑rate, Pendle trades it.

---

## Sources

- DeFi lending TVL ($67.2B) & protocol stats — [DefiLlama](https://defillama.com/protocols/lending), July 25, 2025
- Pendle TVL (~$6.3B) — [DefiLlama](https://defillama.com/protocol/pendle), July 25, 2025
- Morpho V2 = fixed‑rate, fixed‑term — [Morpho blog](https://morpho.org/blog/morpho-v2-liberating-the-potential-of-onchain-loans/) (June 12, 2025)
- Coinbase Loans powered by Morpho — [Coinbase](https://www.coinbase.com/en-ca/blog/now-get-a-USDC-loan-without-selling-your-bitcoin) and [Morpho](https://morpho.org/blog/coinbase-launches-crypto-backed-loans-powered-by-morpho/) announcements (Jan 2025).
- Treasury uniform‑price (single‑price) auction mechanics — [TreasuryDirect](https://www.treasurydirect.gov/auctions/how-auctions-work/), [FAQ](https://www.treasurydirect.gov/help-center/faqs/auction-faqs/), [U.S. Treasury studies](https://home.treasury.gov/system/files/136/archive-documents/upas.pdf), and [Kellogg School of Management](https://www.kellogg.northwestern.edu/faculty/weber/decs-452/Treasury_Report.pdf?utm_source=chatgpt.com)
- Repo market is multi‑trillion — [BIS repo statistics](https://www.bis.org/publ/cgfs59.pdf)
- Term Finance keepers reveal — [Blocmates](https://www.blocmates.com/articles/term-finance-introducing-collateralized-fixed-rate-auctions-on-chain?utm_source=chatgpt.com) explainer
- Notional large‑trade slippage example (~10 bps on $1M) — [Angle Governance Forum](https://gov.angle.money/t/new-yield-strategy-fixed-rate-lending-on-notional-finance/285?utm_source=chatgpt.com)
- Fairblock’s leaderless sealed‑bid auctions & MPC/DKG stack — [Shoal Research](https://www.shoal.gg/p/fairblock-incorruptible-markets-and), [GitHub](https://github.com/Fairblock/fairyring), and architecture [posts](https://medium.com/%400xfairblock/fast-fairy-series-fairyring-architecture-i-d5293e0ce665)