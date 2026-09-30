#! /bin/bash

docker network create -d=bridge -o com.docker.network.bridge.enable_ip_masquerade=true -o com.docker.network.driver.mtu=1500 --subnet fc00:f853:ccd:e793::/64 kind

kind create cluster --name otel-opamp-demo

# kind delete clusters otel-opamp-demo