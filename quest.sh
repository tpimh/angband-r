#!/bin/bash

. ./func.sh

IN="$1"
OUT="$IN"

if [ "$TRANSLATE_MONSTERS" = "true" ]; then
    if [[ "$IN" =~ ^race:.* ]]; then
        ORIG=`echo $IN | sed 's/^race://g'`
        TRANS=`get_trans_by_name monster "$ORIG"`
        check_trans "$ORIG" "$TRANS"
        if [[ "$TRANS" != "" ]]; then
            OUT="race:$TRANS"
        fi
    fi
fi

printf "%s\n" "$OUT"
