#!/bin/bash

. ./func.sh

IN="$1"
OUT="$IN"

if [ "$TRANSLATE_MONSTERS" = "true" ]; then
    if [[ "$IN" =~ ^name:.* ]]; then
        ID=`echo $IN | sed 's/^name:\(.*\):.*$/\1/g'`
        ORIG=`echo $IN | sed 's/^name:.*:\(.*\)$/\1/g'`
        NAME=`get_name_by_id monster "$ID"`
        TRANS=`get_trans_by_id monster "$ID"`
        check_name "$NAME" "$ORIG"
        check_trans "$NAME" "$TRANS"
        if [[ "$TRANS" != "" ]]; then
            OUT="name:$ID:$TRANS"
        fi
    fi

    if [[ "$IN" =~ ^plural:.* ]]; then
        OUT=""
    fi

    if [[ "$IN" =~ ^friends:.* ]]; then
        EXTRA=`echo $IN | sed 's/^friends:\(.*\):\(.*\):.*$/\1:\2/g'`
        ORIG=`echo $IN | sed 's/^friends:.*:.*://g'`
        if [[ "$ORIG" != "Same" ]]; then
            TRANS=`get_trans_by_name monster "$ORIG"`
            check_trans "$ORIG" "$TRANS"
            if [[ "$TRANS" != "" ]]; then
                OUT="friends:$EXTRA:$TRANS"
            fi
        fi
    fi
fi

if [[ "$IN" =~ ^drop-artifact:.* ]]; then
    ORIG=`echo $IN | sed 's/^drop-artifact://g'`
    TRANS=`get_trans_by_name artifact "$ORIG"`
    check_trans "$ORIG" "$TRANS"
    if [[ "$TRANS" != "" ]]; then
        OUT="drop-artifact:$TRANS"
    fi
fi

printf "%s\n" "$OUT"
