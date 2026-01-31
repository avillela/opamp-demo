# Running the Supervisor and Collector as Local Executable Binaries

1. Choose a base OpenTelemetry Collector version and use the same version for the OpAMP Supervisor. This example uses v0.144.0, the latest release at the time of writing.
2. Download the OpAMP Supervisor and OpenTelemetry Collector Contrib executables from [the official OpenTelemetry Collector Releases on GitHub](https://github.com/open-telemetry/opentelemetry-collector-releases/releases).
3. [View the OpenTelemetry docs](https://opentelemetry.io/docs/collector/install/binary/) to learn more about installing on your OS.

Sample below is for macOS:

```bash
# Supervisor
curl --proto '=https' --tlsv1.2 -fOL \
https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/cmd%2Fopampsupervisor%2Fv0.144.0/opampsupervisor_0.144.0_darwin_arm64
mv opampsupervisor_0.144.0_darwin_arm64 supervisor
chmod 755 supervisor

# Collector Contrib
curl --proto '=https' --tlsv1.2 -fOL \
https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v0.144.0/otelcol-contrib_0.144.0_darwin_arm64.tar.gz
tar -xzf otelcol-contrib_0.144.0_darwin_arm64.tar.gz
```

Start the Supervisor:

```bash
./supervisor --config ./supervisor.yaml
```

The Supervisor will launch the Collector as a managed subprocess and begin reporting health, logs, metrics, and effective configuration over OpAMP.
