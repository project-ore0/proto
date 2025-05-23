#!/bin/bash
set -e

PROTO_DIR=proto
OUT_C=generated/c
OUT_TS=generated/ts

mkdir -p "$OUT_C" "$OUT_TS"

# Generate nanopb C
protoc -I="$PROTO_DIR" \
  --nanopb_out="$OUT_C" \
  "$PROTO_DIR"/*.proto

# Generate TS
protoc -I="$PROTO_DIR" \
  --js_out=import_style=commonjs,binary:"$OUT_TS" \
  --ts_out="$OUT_TS" \
  "$PROTO_DIR"/*.proto
