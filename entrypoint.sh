#!/bin/sh
set -e

CONFIG_DIR="${OPENCLAW_STATE_DIR:-$HOME/.openclaw}"
CONFIG_FILE="$CONFIG_DIR/openclaw.json"

mkdir -p "$CONFIG_DIR"

# Only write config if it does not exist yet (first boot)
if [ ! -f "$CONFIG_FILE" ]; then
  cat > "$CONFIG_FILE" << 'EOCFG'
{
  "gateway": {
    "trustedProxies": ["10.42.0.0/16", "172.16.0.0/12", "10.0.0.0/8"],
    "controlUi": {
      "enabled": true,
      "allowInsecureAuth": true
    }
  }
}
EOCFG
  echo "[entrypoint] Wrote initial config to $CONFIG_FILE"
else
  echo "[entrypoint] Config already exists at $CONFIG_FILE, skipping write"
fi

exec node openclaw.mjs gateway --allow-unconfigured --bind lan
