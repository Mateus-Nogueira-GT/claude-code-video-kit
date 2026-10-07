# Confere se os cortes do vídeo caem em ataques reais da música (critério: erro ≤ 3 frames).
# Uso:
#   uv run --with librosa --with scipy --python 3.11 testar_sincronia.py musica.mp3 FRAME_INICIO DURACAO_FRAMES "[c1,c2,...]" [--banda grave|todas]
#   FRAME_INICIO = frame da trilha que toca no frame 0 do vídeo (ex.: trimBefore). Dê ~20 frames de margem
#   antes do primeiro corte (o detector não enxerga ataques colados no início do trecho).
#   Cortes em frames do vídeo (30 fps).
import sys, json
import numpy as np, librosa
from scipy.signal import butter, sosfilt

args = [a for a in sys.argv[1:] if not a.startswith("--")]
banda = "todas" if "--banda" in sys.argv and sys.argv[sys.argv.index("--banda") + 1] == "todas" else "grave"
path, start_f, dur_f, cuts = args[0], int(args[1]), int(args[2]), json.loads(args[3])
lo, hi = (40, 8000) if banda == "todas" else (40, 160)

y, sr = librosa.load(path, sr=22050, mono=True, offset=start_f / 30, duration=dur_f / 30)
sos = butter(4, [lo, hi], btype="band", fs=sr, output="sos")
env = librosa.onset.onset_strength(y=sosfilt(sos, y), sr=sr, hop_length=128)
tt = librosa.times_like(env, sr=sr, hop_length=128)
pk = librosa.util.peak_pick(env, pre_max=6, post_max=6, pre_avg=12, post_avg=12, delta=float(0.15 * env.max()), wait=8)
kf = tt[pk] * 30
erros = []
for c in cuts:
    d = kf - c
    i = int(np.argmin(np.abs(d)))
    erros.append(float(d[i]))
    print(f"corte {c:5d}f → ataque mais próximo {d[i]:+.1f}f")
m = max(abs(e) for e in erros)
print(f"erro máximo {m:.1f}f  {'✓ OK' if m <= 3 else '✗ ajuste os cortes (ou teste com --banda todas)'}")
