#!/bin/bash

LINE=$1
FILENAME=$2.txt

ENGDIR=gamedata-orig
RUSDIR=gamedata-rus

LINESTOTAL=`grep -e "^$LINE:" $RUSDIR/$FILENAME | wc -l`
NOTRANS=`comm -12 <(grep -e "^$LINE:" $RUSDIR/$FILENAME | sort) <(grep -e "^$LINE:" $ENGDIR/$FILENAME | sort) | wc -l`
TRANS=`expr $LINESTOTAL - $NOTRANS`

echo "$2 $LINE: $TRANS/$LINESTOTAL (`expr ${TRANS}00 / $LINESTOTAL`%)"
