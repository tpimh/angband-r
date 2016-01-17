#!/bin/bash

cp class.txt.orig class.txt

# class names
FILENAME=class.txt
PATCHNAME=class.tsv
while read in; do
    ID=`echo "$in" | awk -F'\t' '{print $1}'`
    if [ "$ID" != "ID" ]; then
        NAME_A=`echo "$in" | awk -F'\t' '{print $2}' | sed -e 's/\\x60/\\x27/g' -e 's/\\x27\\x27/\\x22/g'`
        NAME_B=`echo "$in" | awk -F'\t' '{print $3}' | sed -e 's/\\x60/\\x27/g' -e 's/\\x27\\x27/\\x22/g'`

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
            fi
        fi
    fi
done < $PATCHNAME

# class title
FILENAME=class.txt
PATCHNAME=title.tsv
while read in; do
    ID=`echo "$in" | awk -F'\t' '{print $1}' | sed -e 's/\\x60/\\x27/g' -e 's/\\x27\\x27/\\x22/g'`
    if [ "$ID" != "Name" ]; then
        NAME_B=`echo "$in" | awk -F'\t' '{print $2}' | sed -e 's/\\x60/\\x27/g' -e 's/\\x27\\x27/\\x22/g'`

        NAME_ORIG=`sed -n 's/^title:'"$ID"'$/'"$ID"'/p' $FILENAME`

        if [ "$NAME_ORIG" = "" ]; then
            # be silent if monster was not found
            echo -n
        else
            if [ "$ID" = "$NAME_B" ]; then
                echo "(warning) ID:$ID title not translated"
            else
                # replace the artifact
                sed -i 's/^title:'"$ID"'$/title:'"$NAME_B"'/' $FILENAME
            fi
        fi
    fi
done < $PATCHNAME

# spells
FILENAME=class.txt
PATCHNAME=spell.tsv
while read in; do
    ID=`echo "$in" | awk -F'\t' '{print $2}' | sed -e 's/\\x60/\\x27/g' -e 's/\\x27\\x27/\\x22/g' -e 's@/@\\\/@g'`
    if [ "$ID" != "Name" ]; then
        NAME_B=`echo "$in" | awk -F'\t' '{print $3}' | sed -e 's/\\x60/\\x27/g' -e 's/\\x27\\x27/\\x22/g' -e 's@/@\\\/@g'`

        NAME_ORIG=`sed -n 's/^spell:'"$ID"':.*/'"$ID"'/p' $FILENAME`

        if [ "$NAME_ORIG" = "" ]; then
            # be silent if monster was not found
            echo -n
        else
            if [ "$ID" = "$NAME_B" ]; then
                echo "(warning) '$ID' spell name not translated"
            else
                # replace the artifact
                sed -i 's/^spell:'"$ID"':/spell:'"$NAME_B"':/' $FILENAME
            fi
        fi
    fi
done < $PATCHNAME

# class book and equip parts
FILENAME=class.txt
PATCHNAME=object.tsv
while read in; do
    ID=`echo "$in" | awk -F'\t' '{print $2}' | sed -e 's/\\x60/\\x27/g' -e 's/\\x27\\x27/\\x22/g' -e 's/~//g' -e 's/& //g' -e 's@/@\\\/@g' -e 's/\[/\\\[/g' -e 's/\]/\\\]/g'`
    if [ "$ID" != "Name" ]; then
        NAME_B=`echo "$in" | awk -F'\t' '{print $3}' | sed -e 's/\\x60/\\x27/g' -e 's/\\x27\\x27/\\x22/g'  -e 's@/@\\\/@g' -e 's/\[/\\\[/g' -e 's/\]/\\\]/g'`

        NAME_ORIG=`sed -n 's/^\(book\|equip\):.*:'"$ID"':.*$/'"$ID"'/p' $FILENAME | head -n1 | sed 's@/@\\\/@g'`

        if [ "$NAME_ORIG" = "" ]; then
            # be silent if monster was not found
            echo -n
        else
            if [ "$ID" = "$NAME_B" ]; then
                echo "(warning) '$ID' object name not translated"
            else
                # replace the artifact
                sed -i 's/^\(book\|equip\):\(.*\):'"$ID"':\(.*\)$/\1:\2:'"$NAME_B"':\3/' $FILENAME
            fi
        fi
    fi
done < $PATCHNAME

echo "Translation status of $FILENAME:"

LINESTOTAL=`grep -e '^name:' $FILENAME | wc -l`
NOTRANS=`comm -12 <(grep -e '^name:' $FILENAME | sort) <(grep -e '^name:' $FILENAME.orig | sort) | wc -l`
TRANS=`expr $LINESTOTAL - $NOTRANS`

echo "name: $TRANS/$LINESTOTAL (`expr ${TRANS}00 / $LINESTOTAL`%)"

LINESTOTAL=`grep -e '^title:' $FILENAME | wc -l`
NOTRANS=`comm -12 <(grep -e '^title:' $FILENAME | sort) <(grep -e '^title:' $FILENAME.orig | sort) | wc -l`
TRANS=`expr $LINESTOTAL - $NOTRANS`

echo "title: $TRANS/$LINESTOTAL (`expr ${TRANS}00 / $LINESTOTAL`%)"

LINESTOTAL=`grep -e '^spell:' $FILENAME | wc -l`
NOTRANS=`comm -12 <(grep -e '^spell:' $FILENAME | sort) <(grep -e '^spell:' $FILENAME.orig | sort) | wc -l`
TRANS=`expr $LINESTOTAL - $NOTRANS`

echo "spell: $TRANS/$LINESTOTAL (`expr ${TRANS}00 / $LINESTOTAL`%)"

LINESTOTAL=`grep -e '^equip:' $FILENAME | wc -l`
NOTRANS=`comm -12 <(grep -e '^equip:' $FILENAME | sort) <(grep -e '^equip:' $FILENAME.orig | sort) | wc -l`
TRANS=`expr $LINESTOTAL - $NOTRANS`

echo "equip: $TRANS/$LINESTOTAL (`expr ${TRANS}00 / $LINESTOTAL`%)"

LINESTOTAL=`grep -e '^book:' $FILENAME | wc -l`
NOTRANS=`comm -12 <(grep -e '^book:' $FILENAME | sort) <(grep -e '^book:' $FILENAME.orig | sort) | wc -l`
TRANS=`expr $LINESTOTAL - $NOTRANS`

echo "book: $TRANS/$LINESTOTAL (`expr ${TRANS}00 / $LINESTOTAL`%)"

echo "desc: 0%"
