---
sidebar_position: 0
---

# Prerequisites

This page will go over setting up your machine to run the `fairyring` binary and `fairyringclient`.

## Install dependencies

This guide assumes that you are using Ubuntu.

1. Upgrade your operating system:

```bash
sudo apt update && sudo apt upgrade -y
 ```

2. Install essential packages:

```bash
sudo apt install git curl tar wget libssl-dev jq build-essential gcc make
```

3. Download and install Go:

```bash
sudo add-apt-repository ppa:longsleep/golang-backports
sudo apt update
sudo apt install golang-go
```

4. Add `/usr/local/go/bin` & `$HOME/go/bin` directories to your `$PATH`:

```bash
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.profile
source $HOME/.profile
```

5. Verify Go was installed correctly. Note that the `fairyring` binary requires Go `v1.22`:

```bash
go version
```
