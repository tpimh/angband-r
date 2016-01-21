#!/bin/bash

. ./func.sh

IN="$1"
OUT="$IN"

if [[ "$IN" =~ "^desc:.*" ]]; then
    OUT="TEST"
fi

printf "%s\n" "$OUT"
