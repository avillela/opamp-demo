# opamp-demo


## Setup

### Use Case 1 - OpAMP Server + OTel Collector

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

![OpAMP server](/images/opamp-server-startup.png)

**NOTE:** The Dockerfile for the OpAMP Go server provided in this repo gets the job done for the purposes of this example. There's an "official" OpAMP Go server Docker image on GitHub, which you can grab from [here](https://github.com/open-telemetry/opamp-go/pkgs/container/opamp-go%2Fopamp-server-example). Unfortunately, there isn't an ARM image; however, the [OpAMP Go repo has a Dockerfile for the server](https://github.com/open-telemetry/opamp-go/blob/main/internal/examples/Dockerfile.server), which you can build locally. You might be wondering why I don't use that instead. Because I learned about it later. Feel free to use it, though!

2- Run the OTel Collector

Open up a new terminal window, and start up the OTel Collector.

```bash
docker compose up otel-collector
```

When you refresh the OpAMP server UI, you should now see your OTel Collector listsed there.

![OpAMP server](/images/opamp-server-collector.png)

If you click on your OTel Collector, you'll see the Collector config, and a spot to update your config.

![OpAMP server](/images/opamp-server-collector-config.png)

## OpAMP Servers

The OpAMP Go server is just one example of an OpAMP server. You can create your own, or use any of the following open source OpAMP servers:
* [OpAMP Go server (OpenTelemetry)](https://github.com/open-telemetry/opamp-go/tree/main/internal/examples/server)
* [OpAMP Elixir server (Jacob Aronoff)](https://github.com/jaronoff97/opamp-elixir)
* [OpAMP Python server (Adam Gardner)](https://github.com/agardnerIT/opamp-server-py)

### Use Case 2 - OpAMP Server + OpAMP Supervisor + OTel Collector

1- Start the OpAMP server

Open up a new terminal window and run:

```bash
docker compose up opamp-server
```

2- Start the OpAMP supervisor

Open up a new terminal window and run:

```bash
docker compose up opamp-supervisor
```

3- Start the OTel Collector

Open up a new terminal window and run:

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

At the time of this writing, the [OpAMP extension readme](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/extension/opampextension) was out of date.

This is done in the OpAMP Extension config in the [Collector's config YAML](https://github.com/avillela/opamp-demo/blob/ead9ce8c9c220ae339dd2c315a697af6f4863760/src/otel-collector/otelcol-config.yaml#L31-L39):

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

## Resources/Rerences

* [OpenTelemetry OpAMP: Getting Started Guide](https://getlawrence.com/blog/OpenTelemetry-OpAMP--Getting-Started-Guide)
* [OpenTelemetry at Scale: Controlling your Fleet with OpAMP](https://dev.to/agardnerit/opentelemetry-at-scale-controlling-your-fleet-49m2)
* [OpAMP Supervisor](https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/main/cmd/opampsupervisor/README.md)
* [OpAMP Extension](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/extension/opampextension#example)
* [#otel-opamp channel on CNCF Slack](https://cloud-native.slack.com/archives/C02J58HR58R)