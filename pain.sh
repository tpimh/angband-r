#!/bin/bash

. ./func.sh

IN="$1"
OUT="$IN"

if [[ "$IN" =~ ^message:.* ]]; then
    ORIG=`echo $IN | sed 's/^message://g' | sed 's/\[\(.*\)\]/\\\[\1\\\]/g'`
    TRANS=`get_name_by_id pain "$ORIG"`
    check_trans "$ORIG" "$TRANS"
    if [[ "$TRANS" != "" ]]; then
        OUT="message:$TRANS"
    fi
fi

printf "%s\n" "$OUT"
