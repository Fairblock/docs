---
sidebar_position: 6
---

# Integration with Skip

This is a high level overview for how a partnership with Skip's POB might look like.
As VoteExtension functionality has not been enabled yet in CosmosSDK, the ideas discussed later may change.

Through vote extensions, we can enable sealed-bid auctions for top of block space. Our current understanding of Skip's POB architecture is that the auction process
takes place in the `PrepareProposal` and `ProcessProposal` phases of block generation.

By using encrypted bids (from `fairyring`), searchers can submit bids for blockspace in `PrepareProposal`,
and execution of auction winners will occur in `FinalizeBlock`, after decryption occurs, and before the regular encrypted transactions are executed.
