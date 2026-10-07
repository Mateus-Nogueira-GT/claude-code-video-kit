# Lista os ataques (onsets) reais de um trecho da música, em segundos e em "batidas" de uma grade.
# Uso:
#   uv run --with librosa --with scipy --python 3.11 ataques.py musica.mp3 INICIO FIM [t0 T] [--banda grave|todas]
#   INICIO/FIM em segundos. t0/T (opcionais) vêm do analisar_batida.py: mostram em qual batida cai cada ataque.
#   --banda grave (40–160 Hz, bumbo) é o padrão; use "todas" para trilhas orquestrais/épicas.
import sys
import numpy as np, librosa
from scipy.signal import butter, sosfilt

args = [a for a in sys.argv[1:] if not a.startswith("--")]
banda = "todas" if "--banda" in sys.argv and sys.argv[sys.argv.index("--banda") + 1] == "todas" else "grave"
path, a, b = args[0], float(args[1]), float(args[2])
t0, T = (float(args[3]), float(args[4])) if len(args) >= 5 else (None, None)
lo, hi = (40, 8000) if banda == "todas" else (40, 160)

y, sr = librosa.load(path, sr=22050, mono=True, offset=a, duration=b - a)
sos = butter(4, [lo, hi], btype="band", fs=sr, output="sos")
env = librosa.onset.onset_strength(y=sosfilt(sos, y), sr=sr, hop_length=128)
tt = librosa.times_like(env, sr=sr, hop_length=128) + a
pk = librosa.util.peak_pick(env, pre_max=8, post_max=8, pre_avg=20, post_avg=20, delta=float(0.25 * env.max()), wait=20)
rms = librosa.feature.rms(y=y, hop_length=512)[0]
rt = librosa.times_like(rms, sr=sr, hop_length=512) + a
for p in pk:
    t = tt[p]
    e = rms[np.argmin(np.abs(rt - t - 0.15))] / rms.max()
    beat = f"  batida≈{(t - t0) / T:6.2f}" if t0 is not None else ""
    print(f"ataque {t:7.3f}s{beat}  força={env[p] / env.max():.2f}  energia_depois={e:.2f}")
