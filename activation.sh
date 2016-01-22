#!/bin/bash

. ./func.sh

IN="$1"
OUT="$IN"

if [[ "$IN" =~ ^desc:.* ]]; then
    # TODO
    OUT=$IN
fi

if [[ "$IN" =~ ^msg:.* ]]; then
    ORIG=`echo $IN | sed 's/^msg://g'`
    TRANS=`get_name_by_id messages "$ORIG"`
    check_trans "$ORIG" "$TRANS"
    if [[ "$TRANS" != "" ]]; then
        OUT="msg:$TRANS"
    fi
fi

printf "%s\n" "$OUT"
