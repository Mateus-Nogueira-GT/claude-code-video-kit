#!/bin/bash
# Mede volume médio/pico do vídeo e mostra os 6 frames mais altos (para achar qual efeito está estourando).
# Critério: pico ≤ -1 dB. Uso: audio.sh video.mp4 [fps=30]
set -euo pipefail
IN=$1; FPS=${2:-30}
ffmpeg -hide_banner -i "$IN" -af volumedetect -f null /dev/null 2>&1 | grep -oE "(mean|max)_volume.*"
ffmpeg -v error -i "$IN" -vn -ac 1 -ar 22050 -f s16le - | python3 -c "
import sys,array,math
x=array.array('h',sys.stdin.buffer.read()); w=22050//$FPS
pk=[(max(abs(v) for v in x[i*w:(i+1)*w]) or 1) for i in range(len(x)//w)]
top=sorted(range(len(pk)),key=lambda i:-pk[i])[:6]
print('frames mais altos:',', '.join(f'{f} ({20*math.log10(pk[f]/32768):.1f} dB)' for f in sorted(top)))"
