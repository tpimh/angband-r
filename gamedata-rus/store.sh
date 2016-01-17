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

# store objects
FILENAME=store.txt
PATCHNAME=object.tsv
while read in; do
    ID=`echo "$in" | awk -F'\t' '{print $2}' | sed -e 's/\\x60/\\x27/g' -e 's/\\x27\\x27/\\x22/g' -e 's/~//g' -e 's/& //g' -e 's@/@\\\/@g' -e 's/\[/\\\[/g' -e 's/\]/\\\]/g'`
    if [ "$ID" != "Name" ]; then
        NAME_B=`echo "$in" | awk -F'\t' '{print $3}' | sed -e 's/\\x60/\\x27/g' -e 's/\\x27\\x27/\\x22/g'  -e 's@/@\\\/@g' -e 's/\[/\\\[/g' -e 's/\]/\\\]/g'`

        NAME_ORIG=`sed -n 's/^\(normal\|always\):.*:'"$ID"'$/'"$ID"'/p' $FILENAME | head -n1 | sed 's@/@\\\/@g'`

        if [ "$NAME_ORIG" = "" ]; then
            # be silent if monster was not found
            echo -n
        else
            if [ "$ID" = "$NAME_B" ]; then
                echo "(warning) '$ID' object name not translated"
            else
                # replace the artifact
                sed -i 's/^\(normal\|always\):\(.*\):'"$ID"'$/\1:\2:'"$NAME_B"'/' $FILENAME
            fi
        fi
    fi
done < $PATCHNAME


echo "Translation status of $FILENAME:"

LINESTOTAL=`grep -e '^owner:' $FILENAME | wc -l`
NOTRANS=`comm -12 <(grep -e '^owner:' $FILENAME | sort) <(grep -e '^owner:' $FILENAME.orig | sort) | wc -l`
TRANS=`expr $LINESTOTAL - $NOTRANS`

echo "owner: $TRANS/$LINESTOTAL (`expr ${TRANS}00 / $LINESTOTAL`%)"

LINESTOTAL=`grep -e '^store:' $FILENAME | wc -l`
NOTRANS=`comm -12 <(grep -e '^store:' $FILENAME | sort) <(grep -e '^store:' $FILENAME.orig | sort) | wc -l`
TRANS=`expr $LINESTOTAL - $NOTRANS`

echo "store: $TRANS/$LINESTOTAL (`expr ${TRANS}00 / $LINESTOTAL`%)"

LINESTOTAL=`grep -e '^normal:' $FILENAME | wc -l`
NOTRANS=`comm -12 <(grep -e '^normal:' $FILENAME | sort) <(grep -e '^normal:' $FILENAME.orig | sort) | wc -l`
TRANS=`expr $LINESTOTAL - $NOTRANS`

echo "normal: $TRANS/$LINESTOTAL (`expr ${TRANS}00 / $LINESTOTAL`%)"

LINESTOTAL=`grep -e '^always:' $FILENAME | wc -l`
NOTRANS=`comm -12 <(grep -e '^always:' $FILENAME | sort) <(grep -e '^always:' $FILENAME.orig | sort) | wc -l`
TRANS=`expr $LINESTOTAL - $NOTRANS`

echo "always: $TRANS/$LINESTOTAL (`expr ${TRANS}00 / $LINESTOTAL`%)"
