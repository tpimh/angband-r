#!/bin/sh

. ./func.sh

for F in $ENGDIR/*.txt; do
    FNAME=`basename "$F"`
    echo -n > $RUSDIR/$FNAME
    while IFS='' read -r IN; do
        OUT=`bash ${FNAME%.txt}.sh $IN`
        printf "%s\n" "$OUT" >> $RUSDIR/$FNAME
    done < $ENGDIR/$FNAME
done

bash count.sh name monster

bash count.sh msg activation
bash count.sh desc activation

bash count.sh name artifact
# desc
bash count.sh base-object artifact
bash count.sh msg artifact

bash count.sh name class
bash count.sh title class
bash count.sh spell class
# desc
bash count.sh equip class
bash count.sh book class

bash count.sh name ego_item
bash count.sh item ego_item

bash count.sh flavor flavor
bash count.sh fixed flavor

# hints

bash count.sh phrase history

bash count.sh name monster
# desc
bash count.sh friends monster
bash count.sh drop-artifact monster
bash count.sh drop monster
bash count.sh mimic monster

bash count.sh desc monster_base

# monster_spell

# names

bash count.sh name object
# desc
bash count.sh msg object

# object_base

bash count.sh message pain

bash count.sh mon-ban pit

bash count.sh name p_race

bash count.sh race quest

bash count.sh store store
bash count.sh owner store
bash count.sh normal store
bash count.sh always store

bash count.sh name terrain
# desc

# trap
