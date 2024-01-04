# Metrics

`Fairyring` & `Fairyringclient` provide support for metrics to allow users to monitor the health, performance and status of `Fairyring` chain & `Fairyringclient`

## Fairyring Setup

`Fairyring` uses [Prometheus](https://prometheus.io/) to publish metrics, It can be enabled through the `config.toml` file.

```toml
#######################################################
###       Instrumentation Configuration Options     ###
#######################################################
[instrumentation]

# When true, Prometheus metrics are served under /metrics on
# PrometheusListenAddr.
# Check out the documentation for the list of available metrics.
prometheus = true

# Address to listen for Prometheus collector(s) connections
prometheus_listen_addr = ":26660"

# Maximum number of simultaneous connections.
# If you want to accept a larger number than the default, make sure
# you increase your OS limits.
# 0 - unlimited.
max_open_connections = 3

# Instrumentation namespace
namespace = "fairyring"
```

After enabling metrics in `config.toml`, If you restart your node, you can check if metrics is working by:

`curl localhost:26660/metrics`

### Fairyringclient Setup

`Fairyringclient` enable metrics on port `:2222` by default, you can check your metrics port by:

```bash
fairyringclient config show
```

Example Output:

```bash
Using config file: /Users/fairblock/.fairyringclient/config.yml
GRPC Endpoint: 127.0.0.1:9090
FairyRing Node Endpoint: http://127.0.0.1:26657
Chain ID: fairytest-2
Chain Denom: ufairy
InvalidSharePauseThreshold: 5
MetricsPort: 2222
Share API Url: https://7d3q6i0uk2.execute-api.us-east-1.amazonaws.com
```

You can update the metrics port by the following command:

```bash
fairyringclient config update --metrics-port NEW_PORT
```

### Prometheus Installation and Setup

After enabling metrics on `Fairyring` node / `Fairyringclient`, you will need a program to scrape its data, we suggest using `Prometheus` in this example.

1. Install Prometheus by following the [Official Installation guide](https://prometheus.io/docs/prometheus/latest/installation/) in the same machine as your node.
2. Create a Prometheus config file, we will create one at `$HOME/.fairyring/config/prometheus.yml` in this example.

The config file should look something like this:

```yml
global:
  scrape_interval: 15s # Set the scrape interval to every 15 seconds. Default is every 1 minute.

# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: 'Fairyring'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:26660']
  - job_name: 'FairyringClient'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:2222']
```
3. Start Prometheus server:

`prometheus --config.file="$HOME/.fairyring/config/prometheus.yml" --web.listen-address="0.0.0.0:2112"`

Prometheus runs its server on port `9090` by default, we suggest to run prometheus in a different port, `2112` in this case, to avoid conflict with Fairyring node gRPC port (`9090` by default`.

## Visualization

After Installing Prometheus and enabling Fairyring metrics, you will need something to visualize the data it got, we suggest using [Grafana](https://grafana.com/) for building a dashboard to visualize the data.

You can use their cloud service of run it yourself. You can follow their [Official Installation Guide](https://grafana.com/docs/grafana/latest/setup-grafana/installation/) for tutorial on installing `Grafana`. After installing `Grafana`, you can start it by:

```bash
grafana server
```

The command above will start a server on `localhost:3000`.

After you started a Grafana server, you can now create your own dashboard or import the one we already created for [Fairyring](fairyring_dashboard.json) & [Fairyringclient](fairyringclient_dashboard.json).