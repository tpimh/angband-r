#!/bin/bash

. ./func.sh

IN="$1"
OUT="$IN"

if [[ "$IN" =~ ^name:.* ]]; then
    ID=`echo $IN | sed 's/^name:\(.*\):.*$/\1/g'`
    ORIG=`echo $IN | sed 's/^name:.*:\(.*\)$/\1/g'`
    NAME=`get_name_by_id class "$ID"`
    TRANS=`get_trans_by_id class "$ID"`
    check_name "$NAME" "$ORIG"
    check_trans "$NAME" "$TRANS"
    if [[ "$TRANS" != "" ]]; then
        OUT="name:$ID:$TRANS"
    fi
fi

if [[ "$IN" =~ ^title:.* ]]; then
    ORIG=`echo $IN | sed 's/^title://g'`
    TRANS=`get_name_by_id title "$ORIG"`
    check_trans "$ORIG" "$TRANS"
    if [[ "$TRANS" != "" ]]; then
        OUT="title:$TRANS"
    fi
fi

if [[ "$IN" =~ ^spell:.* ]]; then
    ORIG=`echo $IN | sed 's/^spell:\(.*\):.*:.*:.*:.*$/\1/g'`
    EXTRA=`echo $IN | sed 's/^spell:.*:\(.*:.*:.*:.*\)$/\1/g'`
    TRANS=`get_name_by_id spell "$ORIG"`
    check_trans "$ORIG" "$TRANS"
    if [[ "$TRANS" != "" ]]; then
        OUT="spell:$TRANS:$EXTRA"
    fi
fi

# desc

printf "%s\n" "$OUT"
