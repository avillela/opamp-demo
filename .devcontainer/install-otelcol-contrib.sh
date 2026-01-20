#!/usr/bin/env bash
set -euo pipefail

# Requirements: curl, tar, jq, uname, sudo

# Detect architecture
ARCH=$(uname -m)
case "$ARCH" in
    x86_64)
        ARCH="amd64"
        ;;
    aarch64 | arm64)
        ARCH="arm64"
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

echo "Detected architecture: $ARCH"

# Fetch latest release metadata
echo "Fetching latest release metadata..."
LATEST_JSON=$(curl -fsSL https://api.github.com/repos/open-telemetry/opentelemetry-collector-releases/releases/latest)

# Extract version tag (optional, just for logging)
VERSION=$(echo "$LATEST_JSON" | jq -r '.tag_name')
echo "Latest version: $VERSION"

# Find correct asset URL for otelcol-contrib Linux + arch
ASSET_URL=$(echo "$LATEST_JSON" \
  | jq -r --arg arch "$ARCH" '
      .assets[]
      | select(.name
          | test("^otelcol-contrib_.*_linux_" + $arch + "\\.tar\\.gz$"))
      .browser_download_url
    ')

if [ -z "${ASSET_URL:-}" ] || [ "$ASSET_URL" = "null" ]; then
    echo "Could not find a matching otelcol-contrib tarball for architecture: $ARCH"
    echo "Check the latest release assets at:"
    echo "  https://github.com/open-telemetry/opentelemetry-collector-releases/releases/latest"
    exit 1
fi

echo "Downloading: $ASSET_URL"
curl -fSLo otelcol-contrib.tar.gz "$ASSET_URL"

echo "Extracting otelcol-contrib.tar.gz"
tar -xvf otelcol-contrib.tar.gz

# Move binary into place
if [ -f "otelcol-contrib" ]; then
    sudo mv otelcol-contrib /usr/local/bin/
    sudo chmod +x /usr/local/bin/otelcol-contrib
    echo "otelcol-contrib installed to /usr/local/bin/otelcol-contrib"
else
    echo "Binary 'otelcol-contrib' not found after extraction"
    exit 1
fi

# Cleanup
rm otelcol-contrib.tar.gc

echo "Done."
