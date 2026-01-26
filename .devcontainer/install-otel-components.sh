#!/usr/bin/env bash
set -euo pipefail

INSTALL_DIR="/usr/local/bin"
TMP_DIR="./tmp"

mkdir -p "$TMP_DIR"

RELEASES_API="https://api.github.com/repos/open-telemetry/opentelemetry-collector-releases/releases"
BASE_URL="https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download"

echo "Discovering latest versions..."

# --- OpAMP Supervisor ---

# Get the latest tag whose name contains "cmd/opampsupervisor/"
LATEST_SUPERVISOR_TAG=$(curl -sL "$RELEASES_API" \
  | grep -oP '"tag_name":\s*"\K[^"]+' \
  | grep 'cmd/opampsupervisor/' \
  | head -n 1)

if [[ -z "$LATEST_SUPERVISOR_TAG" ]]; then
  echo "Failed to determine latest OpAMP Supervisor tag"
  exit 1
fi

# Extract version from tag: cmd/opampsupervisor/v0.125.0 -> 0.125.0
SUPERVISOR_VERSION="${LATEST_SUPERVISOR_TAG##*/v}"

echo "Latest OpAMP Supervisor tag:     $LATEST_SUPERVISOR_TAG"
echo "Latest OpAMP Supervisor version: $SUPERVISOR_VERSION"

SUPERVISOR_BIN="opampsupervisor_${SUPERVISOR_VERSION}_linux_amd64"

echo "Downloading OpAMP Supervisor..."
curl -fSL "${BASE_URL}/${LATEST_SUPERVISOR_TAG}/${SUPERVISOR_BIN}" \
  -o "${TMP_DIR}/${SUPERVISOR_BIN}"

chmod +x "${TMP_DIR}/${SUPERVISOR_BIN}"
sudo cp "${TMP_DIR}/${SUPERVISOR_BIN}" "${INSTALL_DIR}/opampsupervisor"

# --- OTel Collector Contrib ---

LATEST_CONTRIB_TAG=$(curl -sL "$RELEASES_API" \
  | grep -oP '"tag_name":\s*"\K[^"]+' \
  | grep -E '^v[0-9]+\.[0-9]+\.[0-9]+$' \
  | head -n 1)

if [[ -z "$LATEST_CONTRIB_TAG" ]]; then
  echo "Failed to determine latest OTel Collector Contrib tag"
  exit 1
fi

CONTRIB_VERSION="${LATEST_CONTRIB_TAG#v}"
CONTRIB_TARBALL="otelcol-contrib_${CONTRIB_VERSION}_linux_amd64.tar.gz"

echo "Latest OTel Collector Contrib: $LATEST_CONTRIB_TAG ($CONTRIB_VERSION)"

echo "Downloading OTel Collector Contrib tarball..."
curl -fSL "${BASE_URL}/${LATEST_CONTRIB_TAG}/${CONTRIB_TARBALL}" \
  -o "${TMP_DIR}/${CONTRIB_TARBALL}"

echo "Extracting Contrib Collector..."
tar -xzf "${TMP_DIR}/${CONTRIB_TARBALL}" -C "${TMP_DIR}"

# The extracted folder contains the actual binary named "otelcol-contrib"
if [[ ! -f "${TMP_DIR}/otelcol-contrib" ]]; then
  echo "ERROR: Extracted tarball did not contain 'otelcol-contrib' binary"
  exit 1
fi

chmod +x "${TMP_DIR}/otelcol-contrib"
sudo cp "${TMP_DIR}/otelcol-contrib" "${INSTALL_DIR}/otelcol-contrib"

# --- Cleanup ---
rm -rf ${TMP_DIR}

echo
echo "Installation complete!"
echo "  - OpAMP Supervisor → ${INSTALL_DIR}/opampsupervisor"
echo "  - OTel Collector   → ${INSTALL_DIR}/otelcol"
