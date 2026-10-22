#! /bin/bash

# Load image into KinD using docker command because somehow `kind load` caused things to crap out
# docker exec otel-opamp-demo-control-plane crictl pull docker pull ghcr.io/jaronoff97/opamp-elixir:sha-533d769
docker pull ghcr.io/jaronoff97/opamp-elixir:latest
docker exec otel-opamp-demo-control-plane crictl pull ghcr.io/jaronoff97/opamp-elixir:latest

docker pull postgres:16
docker exec otel-opamp-demo-control-plane crictl pull postgres:16
# kind load docker-image ghcr.io/avillela/opamp-server:20260930 -n otel-opamp-demo

# docker pull postgres:16
# kind load docker-image postgres:16 --name otel-opamp-demo

# docker pull ghcr.io/jaronoff97/opamp-elixir:latest
# kind load docker-image ghcr.io/jaronoff97/opamp-elixir:latest --name otel-opamp-demo