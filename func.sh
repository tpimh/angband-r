VERBOSITY=7

TRANSLATE_MONSTERS=true
TRANSLATE_OBJECTS=true

ENGDIR=gamedata-orig
RUSDIR=gamedata-rus
DICTDIR=dict

message() {
    if [ $VERBOSITY -ge $1 ]; then
        echo $2 1>&2
    fi
}

get_name_by_id() {
    FILENAME=$DICTDIR/$1.tsv
    ID=$(echo "$2" | sed -e "s/'/\`/g" -e "s/\"/\`\`/g")
    case `grep -Pe "^$ID\t" $FILENAME | wc -l` in
      0)
        message 1 "error: dictionary doesn't have '$ID'"
        ;;
      1)
        message 9 "success: dictionary has '$ID'"
        ;;
      *)
        message 4 "warning: dictionary has multiple '$ID'"
        ;;
    esac
    grep -Pe "^$ID\t" $FILENAME | head -n1 | awk -F'\t' '{print $2}' | \
        transform_name
}

get_trans_by_id() {
    FILENAME=$DICTDIR/$1.tsv
    ID=$(echo "$2" | sed -e "s/'/\`/g" -e "s/\"/\`\`/g")
    case `grep -Pe "^$ID\t" $FILENAME | wc -l` in
      0)
        message 1 "error: dictionary doesn't have '$ID'"
        ;;
      1)
        message 9 "success: dictionary has '$ID'"
        ;;
      *)
        message 4 "warning: dictionary has multiple '$ID'"
        ;;
    esac
    grep -Pe "^$ID\t" $FILENAME | head -n1 | awk -F'\t' '{print $3}' | \
        transform_name
}

get_trans_by_name() {
    FILENAME=$DICTDIR/$1.tsv
    NAME=$(echo "$2" | sed -e "s/'/\`/g" -e "s/\"/\`\`/g")
    case `grep -Pe "\t$NAME\t" $FILENAME | wc -l` in
      0)
        message 1 "error: dictionary doesn't have '$NAME'"
        ;;
      1)
        message 9 "success: dictionary has '$NAME'"
        ;;
      *)
        message 4 "warning: dictionary has multiple '$NAME'"
        ;;
    esac
    grep -Pe "\t$NAME\t" $FILENAME | head -n1 | awk -F'\t' '{print $3}' | \
        transform_name
}

get_trans_by_id_and_name() {
    FILENAME=$DICTDIR/$1.tsv
    ID=$(echo "$2" | sed -e "s/'/\`/g" -e "s/\"/\`\`/g")
    NAME=$(echo "$3" | sed -e "s/'/\`/g" -e "s/\"/\`\`/g")
    case `grep -Pe "^$ID\t$NAME\t" $FILENAME | wc -l` in
      0)
        message 1 "error: dictionary doesn't have '$ID' '$NAME'"
        ;;
      1)
        message 9 "success: dictionary has '$ID' '$NAME'"
        ;;
      *)
        message 4 "warning: dictionary has multiple '$ID' '$NAME'"
        ;;
    esac
    grep -Pe "\t$NAME\t" $FILENAME | head -n1 | awk -F'\t' '{print $3}' | \
        transform_name
}

check_name() {
    if [ "$1" != "$2" ]; then
        message 4 "warning: '$1' != '$2'"
    else
        message 9 "success: '$1' found in dictionary"
    fi
}

check_trans() {
    if [ "$1" != "$2" ]; then
        message 8 "success: '$1' => '$2'"
    else
        message 4 "warning: '$1' not translated"
    fi
}

transform_name() {
    sed -e "s/\`/'/g" -e "s/''/\"/g"
}
