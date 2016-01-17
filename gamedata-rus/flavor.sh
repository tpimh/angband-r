#!/bin/bash

cp flavor.txt.orig flavor.txt

# fixed object names
FILENAME=flavor.txt
PATCHNAME=object.tsv
while read in; do
    ID=`echo "$in" | awk -F'\t' '{print $2}' | sed -e 's/\\x60/\\x27/g' -e 's/\\x27\\x27/\\x22/g' -e 's/~//g' -e 's/& //g' -e 's@/@\\\/@g' -e 's/\[/\\\[/g' -e 's/\]/\\\]/g'`
    if [ "$ID" != "Name" ]; then
        NAME_B=`echo "$in" | awk -F'\t' '{print $3}' | sed -e 's/\\x60/\\x27/g' -e 's/\\x27\\x27/\\x22/g'  -e 's@/@\\\/@g' -e 's/\[/\\\[/g' -e 's/\]/\\\]/g'`

        NAME_ORIG=`sed -n 's/^fixed:.*:'"$ID"':.*:.*$/'"$ID"'/p' $FILENAME | head -n1 | sed 's@/@\\\/@g'`

        if [ "$NAME_ORIG" = "" ]; then
            # be silent if monster was not found
            echo -n
        else
            if [ "$ID" = "$NAME_B" ]; then
                echo "(warning) '$ID' object name not translated"
            else
                # replace the artifact
                sed -i 's/^fixed:\(.*\):'"$ID"':\(.*\):\(.*\)$/fixed:\1:'"$NAME_B"':\2:\3/' $FILENAME
            fi
        fi
    fi
done < $PATCHNAME

echo "Translation status of $FILENAME:"

LINESTOTAL=`grep -e '^fixed:' $FILENAME | wc -l`
NOTRANS=`comm -12 <(grep -e '^fixed:' $FILENAME | sort) <(grep -e '^fixed:' $FILENAME.orig | sort) | wc -l`
TRANS=`expr $LINESTOTAL - $NOTRANS`

echo "fixed: $TRANS/$LINESTOTAL (`expr ${TRANS}00 / $LINESTOTAL`%)"

LINESTOTAL=`grep -e '^flavor:' $FILENAME | wc -l`
NOTRANS=`comm -12 <(grep -e '^flavor:' $FILENAME | sort) <(grep -e '^flavor:' $FILENAME.orig | sort) | wc -l`
TRANS=`expr $LINESTOTAL - $NOTRANS`

echo "flavor: $TRANS/$LINESTOTAL (`expr ${TRANS}00 / $LINESTOTAL`%)"
