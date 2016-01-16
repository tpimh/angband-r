#!/bin/sh

cp activation.txt.orig activation.txt

# activation
FILENAME=activation.txt
PATCHNAME=messages.tsv
while read in; do
    ID=`echo "$in" | awk -F'\t' '{print $1}' | sed -e 's/\\x60/\\x27/g' -e 's/\\x27\\x27/\\x22/g'`
    if [ "$ID" != "Message" ]; then
        NAME_B=`echo "$in" | awk -F'\t' '{print $2}' | sed -e 's/\\x60/\\x27/g' -e 's/\\x27\\x27/\\x22/g'`

        NAME_ORIG=`sed -n 's/^msg:'"$ID"'$/'"$ID"'/p' $FILENAME`

        if [ "$NAME_ORIG" = "" ]; then
            # be silent if monster was not found
            echo -n
        else
            if [ "$ID" = "$NAME_B" ]; then
                echo "(warning) ID:$ID message not translated"
            else
                # replace the artifact
                sed -i 's/^msg:'"$ID"'$/msg:'"$NAME_B"'/' $FILENAME
            fi
        fi
    fi
done < $PATCHNAME
