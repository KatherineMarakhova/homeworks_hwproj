#!/bin/bash

show_help(){
    echo "Usage: $0 -s [url] -d [path] [-p|]"
    echo "  -s URL to download from."
    echo "  -d Directory path to save the downloaded files."
    echo "  -p Optional: Download 10 random files if specified."
}

SOURCE=""
DESTINATION=""
PROBE=false

if [ -z "$1" ];then
    show_help
    exit 1
fi

while getopts s:d:p flag
do
    case "${flag}" in
        s) 
            SOURCE=${OPTARG}
            ;;
        d) 
            DESTINATION=${OPTARG}
            ;;
        p)  
            PROBE=true
            ;;
        *)
            show_help
            exit 1
            ;;
    esac
done

if [ -n "$DESTINATION" ]; then
    mkdir -p "$DESTINATION"
fi

echo "FILE EXTENSION  = $SOURCE"
echo "SEARCH PATH     = $DESTINATION"

dl_spbu_s_e() {
  curl 'https://spbu.ru/sveden/education' -s --compressed -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:109.0) Gecko/20100101 Firefox/1>
}

dl_spbu_oop() {
    local result
    result=$(dl_spbu_s_e | grep -o -E "'https://nc\.spbu\.ru/.+?'" | sed "s/'//g" | sort | uniq )
    if [ "$PROBE" = true ]; then
        echo "$result"  | sort -R | head -n 3
    else
        echo "$result"
    fi
}

download() {
    local url="$1"
    # Generate a unique name from the URL by replacing '/' and ':' characters
    local filename="${url//[^a-zA-Z0-9]/_}"
    local filepath="$DESTINATION/$filename.zip"

    if ! wget -O "$filepath" "${url}/download"; then
        >&2 echo "Cannot download $url"
        return 15
    fi

    echo "$filepath"
}

unarchive() {
    for file in "$1"/*; do
        if [ -f "$file" ]; then
            unar -q -f "$file" -o "$1" 
        fi
    done
}

update_recoll_index() {
    echo "Updating Recoll index..."
    recollindex -r "$DESTINATION"
    local status=$?
    if [ $status -ne 0 ]; then
        >&2 echo "Failed to update Recoll index."
        return $status
    else
        echo "Recoll index updated successfully."
    fi
}


for u in $(dl_spbu_oop); do
    file_url="${u}"

    # Download the file and receive the unique filepath back
    download "$file_url"
    download_status=$?
    if [ $download_status -ne 0 ]; then
        continue
    fi
done

unarchive "$DESTINATION"
update_recoll_index "$DESTINATION"