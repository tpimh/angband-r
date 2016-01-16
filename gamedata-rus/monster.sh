#!/bin/sh

cp monster.txt.orig monster.txt

# monster
FILENAME=monster.txt
PATCHNAME=monster.tsv
while read in; do
    ID=`echo "$in" | awk -F'\t' '{print $1}'`
    if [ "$ID" != "ID" ]; then
        NAME_A=`echo "$in" | awk -F'\t' '{print $2}' | sed -e 's/\\x60/\\x27/g' -e 's/\\x27\\x27/\\x22/g'`
        NAME_B=`echo "$in" | awk -F'\t' '{print $3}' | sed -e 's/\\x60/\\x27/g' -e 's/\\x27\\x27/\\x22/g'`
        DESC_A=`echo "$in" | awk -F'\t' '{print $4}' | sed -e 's/\\x60/\\x27/g' -e 's/\\x27\\x27/\\x22/g'`
        DESC_B=`echo "$in" | awk -F'\t' '{print $5}' | sed -e 's/\\x60/\\x27/g' -e 's/\\x27\\x27/\\x22/g'`

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
                # replace friends
                sed -i 's/^friends:\(.*\):\(.*\):'"$NAME_ORIG"'$/friends:\1:\2:'"$NAME_B"'/i' $FILENAME
            fi

            if [ "$DESC_A" = "$DESC_B" ]; then
                echo "(warning) ID:$ID description not translated"
            else
                #TODO: replace the description
                echo -n
            fi
        fi
    fi
done < $PATCHNAME

# monster artifact part
FILENAME=monster.txt
PATCHNAME=artifact.tsv
while read in; do
    ID=`echo "$in" | awk -F'\t' '{print $2}' | sed -e 's/\\x60/\\x27/g' -e 's/\\x27\\x27/\\x22/g'`
    if [ "$ID" != "ID" ]; then
        NAME_B=`echo "$in" | awk -F'\t' '{print $3}' | sed -e 's/\\x60/\\x27/g' -e 's/\\x27\\x27/\\x22/g'`

        NAME_ORIG=`sed -n 's/^drop-artifact:'"$ID"'$/'"$ID"'/p' $FILENAME`

        if [ "$NAME_ORIG" = "" ]; then
            # be silent if artifact was not found
            echo -n
        else
            if [ "$ID" = "$NAME_B" ]; then
                echo "(warning) ID:$ID artifact name not translated"
            else
                # replace the artifact
                sed -i 's/^drop-artifact:'"$ID"'$/drop-artifact:'"$NAME_B"'/' $FILENAME
            fi
        fi
    fi
done < $PATCHNAME