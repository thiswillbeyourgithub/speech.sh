#!/usr/bin/zsh


SPEED="1.0"
VOICE="onyx"
API_KEY="NONE"
FILE="AUTO"
VERBOSE="F"

# echo and send a notification
log() {
    echo $1
    if [[ "$(command -v notify-send)" ]]
    then
        notify-send "Quick_speech.sh: $1"
    fi
}
log2() {
    if [[ "$VERBOSE" != "F" ]]
    then
        log $1
    fi
}

for arg in "$@"; do
    case "$arg" in
        -v | --voice)
            VOICE="$2"
            shift 2
            ;;
        -t | --text)
            TEXT="$2"
            shift 2
            ;;
        -s | --speed)
            SPEED="$2"
            shift 2
            ;;
        -o | --output)
            FILE="$2"
            shift 2
            ;;
        -a | --api_key)
            API_KEY="$2"
            shift 2
            ;;
         --verbose)
            VERBOSE="T"
            shift 2
            ;;
    esac
done

if [ -z "$TEXT" ]
then
    log "No text to voice"
    exit 0
fi

if [[ "$API_KEY" == "NONE" ]]
then
    if [[ ! -e "API_KEY" ]]
    then
        log "No API key given as argument and no file called API_KEY"
        exit 1
    fi
    API_KEY=$(cat "API_KEY")
fi

if [[ "$FILE" == "AUTO" ]]
then
    FILE="$(dirname $(mktemp))/OPENAI_SPEECH_$(echo -n "$TEXT $VOICE $SPEED" | md5sum - | cut -d" " -f1).mp3"
fi

if [[ ! -e "$FILE" ]]
then
    log "API call for \"$TEXT\""

    curl https://api.openai.com/v1/audio/speech \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $API_KEY" \
    -d "$(jq -n --arg model "tts-1" --arg input "$TEXT" --arg voice "$VOICE" --arg speed "$SPEED" '{model: $model, input: $input, voice: $voice, speed: $speed}')" \
    -o "$FILE"

    if [[ ! -e "$FILE" ]]
    then
        log "No file created, something went wrong."
        exit 1
    fi

    if [[ "$(file --brief $FILE)" == "JSON data" ]]
    then
        mess1="JSON data output, something went wrong"
        mess2="$(cat $FILE | jq '.error | .message')"
        log "$mess1\n$mess2"
        rm $FILE
        exit 1
    fi

else
    log "Skipping API call"

fi

log2 "Playing $FILE"
mplayer -quiet -really-quiet "$FILE"

