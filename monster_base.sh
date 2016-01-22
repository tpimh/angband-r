#!/bin/bash

. ./func.sh

IN="$1"
OUT="$IN"

if [[ "$IN" =~ ^desc:.* ]]; then
    ORIG=`echo $IN | sed 's/^desc://g' | sed 's/(\(.*\))/\\\(\1\\\)/g'`
    TRANS=`get_name_by_id monster_base "$ORIG"`
    check_trans "$ORIG" "$TRANS"
    if [[ "$TRANS" != "" ]]; then
        OUT="desc:$TRANS"
    fi
fi

printf "%s\n" "$OUT"
