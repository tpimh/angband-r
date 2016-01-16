#!/bin/sh

cp history.txt.orig history.txt

# monster artifact part
FILENAME=history.txt
PATCHNAME=history.tsv
while read in; do
    ID=`echo "$in" | awk -F'\t' '{print $1}' | sed -e 's/\\x60/\\x27/g' -e 's/\\x27\\x27/\\x22/g'`
    if [ "$ID" != "Phrase" ]; then
        NAME_B=`echo "$in" | awk -F'\t' '{print $2}' | sed -e 's/\\x60/\\x27/g' -e 's/\\x27\\x27/\\x22/g'`

        NAME_ORIG=`sed -n 's/^phrase:'"$ID"'$/'"$ID"'/p' $FILENAME | head -n1`

        if [ "$NAME_ORIG" = "" ]; then
            # be silent if monster was not found
            echo -n
        else
            if [ "$ID" = "$NAME_B" ]; then
                echo "(warning) ID:$ID phrase not translated"
            else
                # replace the artifact
                sed -i 's/^phrase:'"$NAME_ORIG"'/phrase:'"$NAME_B"'/' $FILENAME
            fi
        fi
    fi
done < $PATCHNAME
