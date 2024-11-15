---
sidebar_position: 1
---

# Installation

This tutorial goes over building and installing the `fairyring` binary.
This tutorial assumes you completed the [prerequisites](./prerequisites.md).

1. Remove any existing `fairyring` nodes & clone the repository:

```bash
cd $HOME
rm -rf fairyring
git clone https://github.com/Fairblock/fairyring.git
cd fairyring
```

2. Checkout to the latest release of `fairyring` (currently `v0.10.2`):

```bash
git checkout v0.10.2
```

3. Install `fairyringd` binary:

```bash
make install
```

4. Verify the installation:

```bash
fairyringd version
```

The output should show `0.10.2`

## Upgrading your binary

To upgrade your binary, you can install the latest version from the instructions above and restart your node.
You can check the latest version [here](https://github.com/Fairblock/fairyring/releases).
If you run into any issues, refer to the [troubleshooting section](../faqs/troubleshooting_fairyring.md).
