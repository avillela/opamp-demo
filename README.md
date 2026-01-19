# opamp-demo


## Setup

Run the OTel Collector to make sure that it starts up properly.

```bash
docker run -it --rm -p 4317:4317 -p 4318:4318 \
  -v $(pwd)/src/otel-collector/otelcol-config.yaml:/etc/otelcol-contrib/config.yaml \
  --name otelcol \
  otel/opentelemetry-collector-contrib:0.143.0 \
  --config=/etc/otelcol-contrib/config.yaml
```