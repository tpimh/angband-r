#!/bin/bash

. ./func.sh

IN="$1"
OUT="$IN"

if [[ "$IN" =~ ^store:.* ]]; then
    ID=`echo $IN | sed 's/^store:\(.*\):.*$/\1/g'`
    ORIG=`echo $IN | sed 's/^store:.*://g'`
    TRANS=`get_trans_by_name terrain "$ORIG"`
    check_trans "$ORIG" "$TRANS"
    if [[ "$TRANS" != "" ]]; then
        OUT="store:$ID:$TRANS"
    fi
fi

if [[ "$IN" =~ ^owner:.* ]]; then
    EXTRA=`echo $IN | sed 's/^owner:\(.*\):.*$/\1/g'`
    ORIG=`echo $IN | sed 's/^owner:.*://g' | sed 's/(\(.*\))/\\\(\1\\\)/g'`
    TRANS=`get_name_by_id owner "$ORIG"`
    check_trans "$ORIG" "$TRANS"
    if [[ "$TRANS" != "" ]]; then
        OUT="owner:$EXTRA:$TRANS"
    fi
fi

printf "%s\n" "$OUT"
