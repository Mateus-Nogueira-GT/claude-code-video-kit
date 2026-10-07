#!/bin/bash
# Extrai frames específicos (por número) de um vídeo lado a lado — ideal para checar transições frame a frame.
# Uso: frames.sh video.mp4 saida.jpg 450 451 452 ...
set -euo pipefail
IN=$1; OUT=$2; shift 2
SEL=$(printf "eq(n\\\\,%s)+" "$@"); SEL=${SEL%+}
ffmpeg -v error -y -i "$IN" -vf "select='$SEL',scale=180:-1,tile=$#x1" -frames:v 1 "$OUT"
echo "frames $* → $OUT"
