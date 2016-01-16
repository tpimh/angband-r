#!/bin/bash

cp store.txt.orig store.txt

# store owners
FILENAME=store.txt
PATCHNAME=store.tsv
while read in; do
    ID=`echo "$in" | awk -F'\t' '{print $1}'`
    if [ "$ID" != "Message" ]; then
        NAME_B=`echo "$in" | awk -F'\t' '{print $2}'`

        NAME_ORIG=`sed -n 's/^owner:.*:'"$ID"'$/'"$ID"'/p' $FILENAME`

        if [ "$NAME_ORIG" = "" ]; then
            # be silent if monster was not found
            echo -n
        else
            if [ "$ID" = "$NAME_B" ]; then
                echo "(warning) ID:$ID owner name not translated"
            else
                # replace the artifact
                sed -i 's/^owner:\(.*\):'"$ID"'$/owner:\1:'"$NAME_B"'/' $FILENAME
            fi
        fi
    fi
done < $PATCHNAME

# store names
FILENAME=store.txt
PATCHNAME=terrain.tsv
while read in; do
    ID=`echo "$in" | awk -F'\t' '{print $2}'`
    if [ "$ID" != "Message" ]; then
        NAME_B=`echo "$in" | awk -F'\t' '{print $3}'`

        NAME_ORIG=`sed -n 's/^store:.*:'"$ID"'$/'"$ID"'/p' $FILENAME`

        if [ "$NAME_ORIG" = "" ]; then
            # be silent if monster was not found
            echo -n
        else
            if [ "$ID" = "$NAME_B" ]; then
                echo "(warning) ID:$ID owner name not translated"
            else
                # replace the artifact
                sed -i 's/^store:\(.*\):'"$ID"'$/store:\1:'"$NAME_B"'/' $FILENAME
            fi
        fi
    fi
done < $PATCHNAME

echo "Translation status:"

LINESTOTAL=`grep -e '^owner:' $FILENAME | wc -l`
NOTRANS=`comm -12 <(grep -e '^owner:' $FILENAME | sort) <(grep -e '^owner:' $FILENAME.orig | sort) | wc -l`
TRANS=`expr $LINESTOTAL - $NOTRANS`

echo "owner: $TRANS/$LINESTOTAL (`expr ${TRANS}00 / $LINESTOTAL`%)"

LINESTOTAL=`grep -e '^store:' $FILENAME | wc -l`
NOTRANS=`comm -12 <(grep -e '^store:' $FILENAME | sort) <(grep -e '^store:' $FILENAME.orig | sort) | wc -l`
TRANS=`expr $LINESTOTAL - $NOTRANS`

echo "store: $TRANS/$LINESTOTAL (`expr ${TRANS}00 / $LINESTOTAL`%)"
