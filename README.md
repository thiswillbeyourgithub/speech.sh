# speech.sh
Simple curl script to play aloud what you type, useful if your voice is suddenly broken.

## Features
* Hacked in 30 minutes
* Caching: if asking speech for something that's been spoken before, will play the previous file

## Dependencies
* curl
* openai cli, and an API key setup
* jq
* mplayer
* optional: notify-send

# Usage
* `chmod +x speech.sh`
* Optional: Put your OpenaiAPI key in a file called API_KEY in the same dir as this one or supply it as an argument.
* `./speech.sh --voice "alloy" --text "This is a test" --speed 1.1 --api_key ****...***`

# Why ?
[Ospeak](https://github.com/simonw/ospeak) was too slow because of the python overhead


# Related project
* [quick_whisper_type.py](https://github.com/thiswillbeyourgithub/Quick-Whisper-Typer): *Minimalist python script to turn your voice into typed text (works anywhere)*
