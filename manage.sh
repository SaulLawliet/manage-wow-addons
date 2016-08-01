#!/bin/bash

cd $(dirname $(readlink -f $0))


WOW_DIR="/data/World of Warcraft"
CONF_FILE="conf"
CONF_FILE_TMP="${CONF_FILE}_tmp"
CONF_FILE_OLD="${CONF_FILE}_old"

REPLACE_NAME="_NAME_"
REPLACE_ID="_ID_"

URL_HOME="https://mods.curse.com/addons/wow/${REPLACE_NAME}"
URL_DOWN="https://mods.curse.com/addons/wow/${REPLACE_NAME}/${REPLACE_ID}"

GREP_HOME="<tr class=\"even\"><td><a href=\"/addons/wow/${REPLACE_NAME}/"
GREP_DOWN="click here"

RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
DEFAULT="\033[0m"

err() {
    echo -e "${RED}$@${DEFAULT}"
}

info_v1() {
    echo -e "${YELLOW}$@$DEFAULT"
}

info_v2() {
    echo -e "  ${GREEN}-> $@$DEFAULT"
}

if [[ $# -ge 1 ]]; then
    WOW_DIR=$1
fi

# check wow's dir
if [[ ! -d "$WOW_DIR" ]]; then
    err "WOW directory error, plz check! -> [$WOW_DIR]."
    exit 1
fi

# check addons's dir
dir=$WOW_DIR"/Interface/AddOns"
if [[ ! -d "$dir" ]]; then
    err "WOW AddOns directory error, plz check! -> [$dir]."
    exit 1
fi

# check file
if [[ ! -f "$CONF_FILE" ]]; then
    err "local config file error, plz check! -> [$CONF_FILE]."
    exit 1
fi
if [[ ! -s "$CONF_FILE" ]]; then
    err "local config file no data, plz check! -> [$CONF_FILE]."
    exit 1
fi


while read line; do
    arr=($line)
    name=${arr[0]}
    version=${arr[1]}
    info_v1 "$name($version)"

    # 1.
    info_v2 "check version..."

    url=${URL_HOME//$REPLACE_NAME/$name}
    grep=${GREP_HOME//$REPLACE_NAME/$name}
    arr=($(curl -s $url |grep "$grep" |head -n1 |awk -F'<|>|"|/' '{print $(NF-5), $(NF-3)}'))
    id=${arr[0]}
    new_version=${arr[1]}

    info_v2 "new $new_version"
    if [[ $version = $new_version ]]; then
	info_v2 "SKIP"
	echo "$name $version" >> $CONF_FILE_TMP
	continue;
    fi


    # 2.
    info_v2 "download..."

    url=${URL_DOWN//$REPLACE_NAME/$name}
    url=${url//$REPLACE_ID/$id}
    grep=$GREP_DOWN

    file_url=`curl -s $url |grep "$grep" |awk -F'"' '{print $(NF-5)}'`
    wget -q $file_url


    # 3.
    info_v2 "extract..."

    file_name=`echo $file_url |awk -F'/' '{print $NF}'`
    unzip -oqd "$dir" $file_name && rm $file_name


    info_v2 "DONE"
    echo "$name $new_version" >> $CONF_FILE_TMP
done < $CONF_FILE

mv $CONF_FILE $CONF_FILE_OLD && mv $CONF_FILE_TMP $CONF_FILE
