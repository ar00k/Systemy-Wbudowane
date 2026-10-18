#!/usr/bin/env bash
# Eksport diagramów Mermaid do PNG w katalogu rys/ (używane w dokument.tex).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
MERMAID_VERSION="${MERMAID_VERSION:-10.9.1}"
PUPPETEER_CFG="$ROOT/kod/mermaid-puppeteer.json"

npx --yes "@mermaid-js/mermaid-cli@${MERMAID_VERSION}" \
  -p "$PUPPETEER_CFG" \
  -i "$ROOT/kod/diagram-architektura.mmd" \
  -o "$ROOT/rys/diagram-architektura.png" \
  -b white -w 1400

npx --yes "@mermaid-js/mermaid-cli@${MERMAID_VERSION}" \
  -p "$PUPPETEER_CFG" \
  -i "$ROOT/kod/diagram-sesja-polaczenia.mmd" \
  -o "$ROOT/rys/diagram-sesja-polaczenia.png" \
  -b white -w 1400

echo "OK: zapisano $ROOT/rys/diagram-architektura.png oraz diagram-sesja-polaczenia.png"
