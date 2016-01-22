#!/bin/bash

LINE=$1
FILENAME=$2.txt

ENGDIR=gamedata-orig
RUSDIR=gamedata-rus

if [ "$LINE" != "friends" ]; then
    LINESTOTAL=`grep -e "^$LINE:" $RUSDIR/$FILENAME | wc -l`
    NOTRANS=`comm -12 <(grep -e "^$LINE:" $RUSDIR/$FILENAME | sort) <(grep -e "^$LINE:" $ENGDIR/$FILENAME | sort) | wc -l`
else
    LINESTOTAL=`grep -e "^$LINE:" $RUSDIR/$FILENAME | grep -ve ":Same$" | wc -l`
    NOTRANS=`comm -12 <(grep -e "^$LINE:" $RUSDIR/$FILENAME | grep -ve ":Same$" | sort) <(grep -e "^$LINE:" $ENGDIR/$FILENAME | grep -ve ":Same$" | sort) | wc -l`
fi
TRANS=`expr $LINESTOTAL - $NOTRANS`

echo "$2 $LINE: $TRANS/$LINESTOTAL (`expr ${TRANS}00 / $LINESTOTAL`%)"
