#!/bin/sh

cp terrain.txt.orig terrain.txt

# terrain
FILENAME=terrain.txt
PATCHNAME=terrain.tsv
while read in; do
    ID=`echo "$in" | awk -F'\t' '{print $1}'`
    if [ "$ID" != "ID" ]; then
        NAME_A=`echo "$in" | awk -F'\t' '{print $2}'`
        NAME_B=`echo "$in" | awk -F'\t' '{print $3}'`

        NAME_ORIG=`sed -n 's/^name:'$ID'://p' $FILENAME`

        if [ "$NAME_ORIG" = "" ]; then
            echo "(error) ID:$ID not found"
        else
            if [ "$NAME_A" = "$NAME_B" ]; then
                echo "(warning) ID:$ID name not translated"
            else
                if [ "$NAME_A" != "$NAME_ORIG" ]; then
                    echo "(warning) ID:$ID original name doesn't match ($NAME_A != $NAME_ORIG)"
                fi
                # replace the name
                sed -i 's/^name:'"$ID"':'"$NAME_ORIG"'$/name:'"$ID"':'"$NAME_B"'/' $FILENAME
            fi
        fi
    fi
done < $PATCHNAME



