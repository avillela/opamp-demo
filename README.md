# opamp-demo


## Setup

### Use Case 1 - OpAMP Server + OpAMP Client

References: 
* [OpenTelemetry OpAMP: Getting Started Guide](https://getlawrence.com/blog/OpenTelemetry-OpAMP--Getting-Started-Guide)
* [OpenTelemetry at Scale: Controlling your Fleet with OpAMP](https://dev.to/agardnerit/opentelemetry-at-scale-controlling-your-fleet-49m2)
* [OpAMP Go Server](https://github.com/open-telemetry/opamp-go/blob/main/internal/examples/docker-compose.yml#L16-L31)

1- Run the OpAMP Server

Open up a new terminal window and build the OpAMP Go server.

```bash
docker compose build opamp-server --no-cache
```

Now, start up the OpAMP server.

```bash
docker compose up opamp-server
```

This starts the OpAMP Go server, listening at port `4320`. You can see what servers are registered by navigating to `http://localhost:4321`

2- Run the OTel Collector

Open up a new terminal window, and start up the OTel Collector.

```bash
docker compose up otel-collector
```

## Gotchas

### 1- Make sure that the OpAMP extension is added to the pipeline

Configuring the OpAMP extension is not enough. It must also be added to the `service` section of the Collector config.

```bash
service:
  extensions: [opamp]
```


### 2- If you're not using TLS, you need to tell the OpAMP server to ignore TLS

This is done in the OpAMP Extension config:

```bash
extensions:
  opamp:
    server:
      ws:
        endpoint: wss://opamp-server:4320/v1/opamp
        tls:
          insecure_skip_verify: true
```

The endpoint must always start with `wss://`, and for insecure endpoints, set the `tls` to `insecure_skip_verify: true`.

The name of the OpAMP server used above is `opamp-server`, because it is the name of the OpAMP service defined in [`docker-compose.yaml`](/docker-compose.yaml)