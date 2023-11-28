#!/bin/bash

show_help(){
    echo "Usage: $0 -s|--source [url] -d|--destination [path] [-p|--probe]"
    echo "  -s | --source       URL to download from."
    echo "  -d | --destination  Directory path to save the downloaded files."
    echo "  -p | --probe        Optional: Download 10 random files if specified."
}

SOURCE=""
DESTINATION=""
PROBE=false

if [ -z "$1" ];then
    show_help
    exit 1
fi

while getopts *:s:d:p flag
do
    case "${flag}" in
        s | -source) 
            SOURCE=${OPTARG}
            ;;
        d | -destination) 
            DESTINATION=${OPTARG}
            ;;
        p | -probe)  
            PROBE=true
            ;;
    esac
done

if [ ! -z $DESTINATION ]; then
    mkdir -p "$DESTINATION"
fi

echo "FILE EXTENSION  = $SOURCE"
echo "SEARCH PATH     = $DESTINATION"

dl_spbu_s_e() {
  curl 'https://spbu.ru/sveden/education' -s --compressed -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:109.0) Gecko/20100101 Firefox/118.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8' -H 'Accept-Language: ru-RU,ru;q=0.8,en-US;q=0.5,en;q=0.3' -H 'Accept-Encoding: gzip, deflate, br' -H 'DNT: 1' -H 'Connection: keep-alive'
}

dl_spbu_oop() {
    local result=$(dl_spbu_s_e | grep -o -E "'https://nc\.spbu\.ru/.+?'" | sed "s/'//g" | sort | uniq )
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
            unar -f "$file" -o "$1"
        fi
    done
}

for u in $(dl_spbu_oop); do
    file_url="${u}"

    # Download the file and receive the unique filepath back
    local_file=$(download "$file_url")
    download_status=$?
    if [ $download_status -ne 0 ]; then
        continue
    fi
done

unarchive "$DESTINATION"
