#!/bin/bash
# Gera uma "prancha" (contact sheet) de um vídeo renderizado para revisar tudo de uma vez.
# Uso: prancha.sh video.mp4 saida.jpg [quadros_por_segundo=2] [colunas=12] [largura_miniatura=108]
set -euo pipefail
IN=$1; OUT=$2; FPS=${3:-2}; COLS=${4:-12}; W=${5:-108}
DUR=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$IN")
N=$(python3 -c "import math;print(math.ceil($DUR*$FPS))")
ROWS=$(( (N + COLS - 1) / COLS ))
ffmpeg -v error -y -i "$IN" -vf "fps=$FPS,scale=$W:-1,tile=${COLS}x${ROWS}" -frames:v 1 "$OUT"
echo "prancha: $OUT ($N quadros, ${COLS}x${ROWS})"
