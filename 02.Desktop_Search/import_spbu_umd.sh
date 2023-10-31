#!/bin/bash
POSITIONAL_ARGS=()

TEMP=$(getopt -o vdm: --long verbose,debug,memory:,debugfile:,minheap:,maxheap: -n 'javawrap' -- "$@")

if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi

SOURCE=""
DESTINATION=""
PROBE=false

while [[ $# -gt 0 ]]; do
case $1 in
-s|--source)
    SOURCE="$2"
    shift # past argument
    shift # past value
    ;;
-d|--destination)
    DESTINATION="$2"
    shift # past argument
    shift # past value
    ;;
-p|--probe)
    PROBE=true
    shift # past argument
    shift # past value
    ;;
--default)
    SOURCE="https://spbu.ru/sveden/education"
    shift # past argument
    ;;
--)
    shift
    break
    ;;
*)
    exit 1
    ;;
esac
done

mkdir -p "$DESTINATION"

set -- "${POSITIONAL_ARGS[@]}" # restore positional parameters

echo "FILE EXTENSION  = ${SOURCE}"
echo "SEARCH PATH     = ${DESTINATION}"
echo "DEFAULT         = ${DEFAULT}"


dl_spbu_s_e () {
    curl "https://spbu.ru/sveden/education" -s --compressed -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:109.0) Gecko/20100101 Firefox/118.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8' -H 'Accept-Language: ru-RU,ru;q=0.8,en-US;q=0.5,en;q=0.3' -H 'Accept-Encoding: gzip, deflate, br' -H 'DNT: 1' -H 'Connection: keep-alive'
}

dl_spbu_oop() {
    local result

    result=$(dl_spbu_s_e | grep -o -E "'https://nc\.spbu\.ru/.+?'" | sed "s/'//g" | sort | uniq)
    if [ "$PROBE" = true ]; then
        echo "$result" | sort -R | head -n 10
    else
        echo "$result"
    fi
}
function download {
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

extract_and_cleanup() {
    local file_path="$1"
    local dest_dir="$2"

    unzip -o "$file_path" -d "$dest_dir"
    local status=$?
    if [ $status -ne 0 ]; then
        >&2 echo "Failed to extract $file_path"
        return $status
    fi

    if ! rm -f "$file_path"; then
        >&2 echo "Failed to remove the zip file $file_path"
        return 1
    fi
}

for u in $(dl_spbu_oop); do
    file_url="${u}"

    # Download the file and receive the unique filepath back
    local_file=$(download "$file_url")
    download_status=$?
    if [ $download_status -ne 0 ]; then
        continue
    fi

    extract_and_cleanup "$local_file" "$DESTINATION"
    echo $?
done
