#!/bin/bash

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

# monster drop and mimic parts
FILENAME=monster.txt
PATCHNAME=object.tsv
while read in; do
    ID=`echo "$in" | awk -F'\t' '{print $2}' | sed -e 's/\\x60/\\x27/g' -e 's/\\x27\\x27/\\x22/g' -e 's/~//g' -e 's/& //g' -e 's@/@\\\/@g' -e 's/\[/\\\[/g' -e 's/\]/\\\]/g'`
    if [ "$ID" != "Name" ]; then
        NAME_B=`echo "$in" | awk -F'\t' '{print $3}' | sed -e 's/\\x60/\\x27/g' -e 's/\\x27\\x27/\\x22/g'  -e 's@/@\\\/@g' -e 's/\[/\\\[/g' -e 's/\]/\\\]/g'`

        NAME_ORIG=`sed -n 's/^\(drop\|mimic\):.*:'"$ID"':*.*$/'"$ID"'/p' $FILENAME | head -n1 | sed 's@/@\\\/@g'`

        if [ "$NAME_ORIG" = "" ]; then
            # be silent if monster was not found
            echo -n
        else
            if [ "$ID" = "$NAME_B" ]; then
                echo "(warning) '$ID' object name not translated"
            else
                # replace the artifact
                sed -i 's/^\(drop\|mimic\):\(.*\):'"$ID"'\(:*\)\(.*\)$/\1:\2:'"$NAME_B"'\3\4/' $FILENAME
            fi
        fi
    fi
done < $PATCHNAME

# remove plurals
sed -i '/^plural:/ d' $FILENAME


echo "Translation status of $FILENAME:"

LINESTOTAL=`grep -e '^name:' $FILENAME | wc -l`
NOTRANS=`comm -12 <(grep -e '^name:' $FILENAME | sort) <(grep -e '^name:' $FILENAME.orig | sort) | wc -l`
TRANS=`expr $LINESTOTAL - $NOTRANS`

echo "name: $TRANS/$LINESTOTAL (`expr ${TRANS}00 / $LINESTOTAL`%)"

LINESTOTAL=`grep -e '^friends:' $FILENAME | wc -l`
NOTRANS=`comm -12 <(grep -e '^friends:' $FILENAME | sort) <(grep -e '^friends:' $FILENAME.orig | sort) | wc -l`
TRANS=`expr $LINESTOTAL - $NOTRANS`

echo "friends: $TRANS/$LINESTOTAL (`expr ${TRANS}00 / $LINESTOTAL`%)"

LINESTOTAL=`grep -e '^drop-artifact:' $FILENAME | wc -l`
NOTRANS=`comm -12 <(grep -e '^drop-artifact:' $FILENAME | sort) <(grep -e '^drop-artifact:' $FILENAME.orig | sort) | wc -l`
TRANS=`expr $LINESTOTAL - $NOTRANS`

echo "drop-artifact: $TRANS/$LINESTOTAL (`expr ${TRANS}00 / $LINESTOTAL`%)"

LINESTOTAL=`grep -e '^drop:' $FILENAME | wc -l`
NOTRANS=`comm -12 <(grep -e '^drop:' $FILENAME | sort) <(grep -e '^drop:' $FILENAME.orig | sort) | wc -l`
TRANS=`expr $LINESTOTAL - $NOTRANS`

echo "drop: $TRANS/$LINESTOTAL (`expr ${TRANS}00 / $LINESTOTAL`%)"

LINESTOTAL=`grep -e '^mimic:' $FILENAME | wc -l`
NOTRANS=`comm -12 <(grep -e '^mimic:' $FILENAME | sort) <(grep -e '^mimic:' $FILENAME.orig | sort) | wc -l`
TRANS=`expr $LINESTOTAL - $NOTRANS`

echo "mimic: $TRANS/$LINESTOTAL (`expr ${TRANS}00 / $LINESTOTAL`%)"

echo "desc: 0%"
