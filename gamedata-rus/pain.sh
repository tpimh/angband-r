#!/bin/bash

cp pain.txt.orig pain.txt

# pain messages
FILENAME=pain.txt
PATCHNAME=pain.tsv
while read in; do
    ID=`echo "$in" | awk -F'\t' '{print $1}' | sed -e 's/\[/\\\[/g' -e 's/\]/\\\]/g'`
    if [ "$ID" != "Name" ]; then
        NAME_B=`echo "$in" | awk -F'\t' '{print $2}' | sed -e 's/\[/\\\[/g' -e 's/\]/\\\]/g'    `

        NAME_ORIG=`sed -n 's/^message:'"$ID"'$/'"$ID"'/p' $FILENAME`

        if [ "$NAME_ORIG" = "" ]; then
            # be silent if monster was not found
            echo -n
        else
            if [ "$ID" = "$NAME_B" ]; then
                echo "(warning) '$ID' message not translated"
            else
                # replace the artifact
                sed -i 's/^message:'"$ID"'$/message:'"$NAME_B"'/' $FILENAME
            fi
        fi
    fi
done < $PATCHNAME

echo "Translation status of $FILENAME:"

LINESTOTAL=`grep -e '^message:' $FILENAME | wc -l`
NOTRANS=`comm -12 <(grep -e '^message:' $FILENAME | sort) <(grep -e '^message:' $FILENAME.orig | sort) | wc -l`
TRANS=`expr $LINESTOTAL - $NOTRANS`

echo "message: $TRANS/$LINESTOTAL (`expr ${TRANS}00 / $LINESTOTAL`%)"
