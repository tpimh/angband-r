#!/bin/bash

cp pit.txt.orig pit.txt

# pit mon-ban
FILENAME=pit.txt
PATCHNAME=monster.tsv
while read in; do
    ID=`echo "$in" | awk -F'\t' '{print $2}' | sed -e 's/\\x60/\\x27/g' -e 's/\\x27\\x27/\\x22/g'`
    if [ "$ID" != "Name" ]; then
        NAME_B=`echo "$in" | awk -F'\t' '{print $3}' | sed -e 's/\\x60/\\x27/g' -e 's/\\x27\\x27/\\x22/g'`

        NAME_ORIG=`sed -n 's/^mon-ban:'"$ID"'$/'"$ID"'/p' $FILENAME`

        if [ "$NAME_ORIG" = "" ]; then
            # be silent if monster was not found
            echo -n
        else
            if [ "$ID" = "$NAME_B" ]; then
                echo "(warning) ID:$ID monster name not translated"
            else
                # replace the artifact
                sed -i 's/^mon-ban:'"$ID"'$/mon-ban:'"$NAME_B"'/' $FILENAME
            fi
        fi
    fi
done < $PATCHNAME

echo "Translation status of $FILENAME:"

LINESTOTAL=`grep -e '^mon-ban:' $FILENAME | wc -l`
NOTRANS=`comm -12 <(grep -e '^mon-ban:' $FILENAME | sort) <(grep -e '^mon-ban:' $FILENAME.orig | sort) | wc -l`
TRANS=`expr $LINESTOTAL - $NOTRANS`

echo "mon-ban: $TRANS/$LINESTOTAL (`expr ${TRANS}00 / $LINESTOTAL`%)"
