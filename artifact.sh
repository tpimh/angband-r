#!/bin/bash

. ./func.sh

IN="$1"
OUT="$IN"

if [[ "$IN" =~ ^name:.* ]]; then
    ID=`echo $IN | sed 's/^name:\(.*\):.*$/\1/g'`
    ORIG=`echo $IN | sed 's/^name:.*:\(.*\)$/\1/g'`
    NAME=`get_name_by_id artifact "$ID"`
    TRANS=`get_trans_by_id artifact "$ID"`
    check_name "$NAME" "$ORIG"
    check_trans "$NAME" "$TRANS"
    if [[ "$TRANS" != "" ]]; then
        OUT="name:$ID:$TRANS"
    fi
fi

# TODO: desc

# TODO: base-object (object#NAME)

if [[ "$IN" =~ ^msg:.* ]]; then
    ORIG=`echo $IN | sed 's/^msg://g'`
    TRANS=`get_name_by_id messages "$ORIG"`
    check_trans "$ORIG" "$TRANS"
    if [[ "$TRANS" != "" ]]; then
        OUT="msg:$TRANS"
    fi
fi

printf "%s\n" "$OUT"
