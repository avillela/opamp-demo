# OpenTelemetry OpAMP Examples for The Rest of Us!

This is the companion repository for the NDC London talk, [OpenTelemetry At Scale 101: Intro to OpAMP](https://ndclondon.com/agenda/opentelemetry-at-scale-101-intro-to-opamp-06w1/0ai54vh0exn)

## Tutorials

These tutorials showcase different ways in which OpAMP works.

### Tutorial 1 - OpAMP Server + OTel Collector with OpAMP Extension

In this scenario, we'll be running the [OpAMP Go Server](https://github.com/open-telemetry/opamp-go/tree/main/internal/examples/server) and an [OTel Collector](https://github.com/open-telemetry/opentelemetry-collector-contrib) with the [OpAMP Extension](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/extension/opampextension).

Since the OpAMP Extension only reports on configuration state, you will not be able to alter the OTel Collector configs in this scenario.

1- Run the OpAMP Server

Open up a new terminal window and start up the OpAMP Server. Note that the first time you run this, it will build the image if it doesn't already exist.

```bash
docker compose up opamp-server
```

This starts the OpAMP Go server, listening at port `4320`. You can see what servers are registered by navigating to `http://localhost:4321`

![OpAMP server](/images/opamp-server-startup.png)

**NOTE:** The Dockerfile for the OpAMP Go server provided in this repo gets the job done for the purposes of this example. There's an "official" OpAMP Go server Docker image on GitHub, which you can grab from [here](https://github.com/open-telemetry/opamp-go/pkgs/container/opamp-go%2Fopamp-server-example). Unfortunately, there isn't an ARM image; however, the [OpAMP Go repo has a Dockerfile for the server](https://github.com/open-telemetry/opamp-go/blob/main/internal/examples/Dockerfile.server), which you can build locally. You might be wondering why I don't use that instead. Because I learned about it later. Feel free to use it, though!

2- Run the OTel Collector

Open up a new terminal window, and start up the OTel Collector. Note that the first time you run this, it will build the image if it doesn't already exist.

```bash
docker compose up otel-collector
```

When you refresh the OpAMP server UI, you should now see your OTel Collector listsed there.

![OpAMP server](/images/opamp-server-collector.png)

If you click on your OTel Collector, you'll see the Collector config, and a spot to update your config. You can try to update the Collector config, but since the OpAMP Extension is read-only, you won't be able to update the configs.

![OpAMP server](/images/opamp-server-collector-config.png)

### Tutorial 2 - OpAMP Server + OpAMP Supervisor Binary + OTel Collector Binary

In this scenario, both the OpAMP Supervisor and the OpenTelemetry Collector run as native binaries on your local machine. This is the simplest way to understand how the Supervisor manages a Collector and is ideal for both local development and configuring production-ready Supervisors on VMs or bare-metal servers.

1- Start the OpAMP server

Open up a new terminal window start the OpAMP Server. Note that the first time you run this, it will build the image if it doesn't already exist.

```bash
docker compose up opamp-server
```

2- Start the OpAMP Supervisor binary

If you're running this in a Dev Container, the OpAMP Supervisor and OTel Collector were installed in [install-otel-components.sh](/.devcontainer/install-otel-components.sh) on initial Dev Container build.

If you're not running this using the Dev Container, install the OpAMP Supervisor and OTel Collector binaries on your local filesystem by running:

```bash
./.devcontainer/install-otel-components.sh
```

And then start up the OpAMP Supervisor binary:

```bash
opampsupervisor --config ./src/opamp-supervisor/supervisor-3.yaml
```

The Supervisor will launch the Collector as a managed subprocess and begin reporting health, logs, metrics, and effective configuration over OpAMP.
This local-binary setup is recommended for most initial use cases and is the easiest way to understand how OpAMP works end to end.

### Tutorial 3 - OpAMP Server + OpAMP Supervisor + OTel Collector

In this example, we run 2 [OpAMP Supervisors](https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/main/cmd/opampsupervisor/README.md) with the [OpAMP Go Server](https://github.com/open-telemetry/opamp-go/tree/main/internal/examples/server). 

The first OpAMP Supervisor uses the OpAMP Supervisor Docker image and references a Collector binary mounted as a volume to the container.

The second OpAMP Supervisor is a custom Docker image that includes both the Supervisor and the OTel Collector.

1- Start the OpAMP server

Open up a new terminal window and run:

```bash
docker compose up opamp-server
```

2- Start the OpAMP Supervisor

Open up a new terminal window and run the following command. Note that the first time you run this, it will build the image if it doesn't already exist.

```bash
docker compose up opamp-supervisor-2
```

Again, the Supervisor will launch the Collector as a managed subprocess, but it will do so within the custom Supervisor/Collector combination container.

![OpAMP server](/images/opamp-server-2-collectors.png)


## OpAMP Servers

The OpAMP Go server is just one example of an OpAMP server. Here are some examples:
* [OpAMP Go server (OpenTelemetry)](https://github.com/open-telemetry/opamp-go/tree/main/internal/examples/server)
* [OpAMP Elixir server (Jacob Aronoff)](https://github.com/jaronoff97/opamp-elixir)
* [OpAMP Python server (Adam Gardner)](https://github.com/agardnerIT/opamp-server-py)

>! 🚨 **NOTE**: These are NOT production-ready servers. Use at your own risk.

You can also write your own OpAMP Server, implementing the [OpAMP protobuf specs](https://opentelemetry.io/docs/specs/opamp/)!

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