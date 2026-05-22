#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FLUTTER_DIR="${FLUTTER_DIR:-$HOME/flutter}"

cd "$ROOT_DIR"

if ! command -v flutter >/dev/null 2>&1; then
  if [ ! -d "$FLUTTER_DIR" ]; then
    git clone --depth 1 -b stable https://github.com/flutter/flutter.git "$FLUTTER_DIR"
  fi
  export PATH="$FLUTTER_DIR/bin:$PATH"
fi

export PATH="$FLUTTER_DIR/bin:$PATH"

flutter --version
flutter config --no-analytics
flutter clean
flutter pub get
flutter build web --release \
  --dart-define=SUPABASE_URL=${SUPABASE_URL:-} \
  --dart-define=SUPABASE_ANON_KEY=${SUPABASE_ANON_KEY:-}
