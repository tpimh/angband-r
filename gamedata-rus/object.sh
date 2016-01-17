#!/bin/bash

cp object.txt.orig object.txt

# object
FILENAME=object.txt
PATCHNAME=object.tsv
while read in; do
    ID=`echo "$in" | awk -F'\t' '{print $1}'`
    if [ "$ID" != "ID" ]; then
        NAME_A=`echo "$in" | awk -F'\t' '{print $2}' | sed -e 's/\\x60/\\x27/g' -e 's/\\x27\\x27/\\x22/g' -e 's@/@\\\/@g'`
        NAME_B=`echo "$in" | awk -F'\t' '{print $3}' | sed -e 's/\\x60/\\x27/g' -e 's/\\x27\\x27/\\x22/g' -e 's@/@\\\/@g'`
        DESC_A=`echo "$in" | awk -F'\t' '{print $4}' | sed -e 's/\\x60/\\x27/g' -e 's/\\x27\\x27/\\x22/g' -e 's@/@\\\/@g'`
        DESC_B=`echo "$in" | awk -F'\t' '{print $5}' | sed -e 's/\\x60/\\x27/g' -e 's/\\x27\\x27/\\x22/g' -e 's@/@\\\/@g'`

        NAME_ORIG=`sed -n 's/^name:'$ID'://p' $FILENAME | sed 's@/@\\\/@g'`

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

            if [ "$DESC_A" != "" ]; then
                if [ "$DESC_A" = "$DESC_B" ]; then
                    echo "(warning) ID:$ID description not translated"
                else
                    #TODO: replace the description
                    echo -n
                fi
            fi
        fi
    fi
done < $PATCHNAME


echo "Translation status of $FILENAME:"

LINESTOTAL=`grep -e '^name:' $FILENAME | wc -l`
NOTRANS=`comm -12 <(grep -e '^name:' $FILENAME | sort) <(grep -e '^name:' $FILENAME.orig | sort) | wc -l`
TRANS=`expr $LINESTOTAL - $NOTRANS`

echo "name: $TRANS/$LINESTOTAL (`expr ${TRANS}00 / $LINESTOTAL`%)"
echo "desc: 0%"
