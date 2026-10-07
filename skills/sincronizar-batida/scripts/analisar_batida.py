# Análise de batida (método da skill video-shotcraft, music-beat-sync.md §1–2).
# Uso: uv run --with librosa --with scipy --python 3.11 scripts/analisar_batida.py arquivo.mp3 [duracao_janela_s]
import sys, json
import numpy as np, librosa
from scipy.signal import butter, sosfilt

path = sys.argv[1]
win = float(sys.argv[2]) if len(sys.argv) > 2 else 6.5
y, sr = librosa.load(path, sr=22050, mono=True)
_, perc = librosa.effects.hpss(y)
tempo, beats = librosa.beat.beat_track(y=perc, sr=sr, tightness=400, units="time")
i = np.arange(len(beats)); A = np.vstack([i, np.ones_like(i)]).T
(T, t0), *_ = np.linalg.lstsq(A, beats, rcond=None)
res = np.abs(beats - (t0 + i * T)).max() * 1000

def band_env(lo, hi):
    sos = butter(4, [lo, hi], btype="band", fs=sr, output="sos")
    env = librosa.onset.onset_strength(y=sosfilt(sos, perc), sr=sr)
    return env / (env.max() + 1e-9), librosa.times_like(env, sr=sr)

kick, times = band_env(40, 160)
snare, _ = band_env(1000, 3000)
rms = librosa.feature.rms(y=y)[0]; rt = librosa.times_like(rms, sr=sr)
dur = len(y) / sr
# energia por segundo
eps = [float(rms[(rt >= s) & (rt < s + 1)].mean()) for s in range(int(dur))]
emax = max(eps)
# candidatos: janelas que começam num tempo forte (múltiplo de 4 batidas) com energia alta e estável
cands = []
n = 0
while t0 + n * T + win < dur:
    s = t0 + n * T
    m = (rt >= s) & (rt < s + win)
    e = float(rms[m].mean()) / emax
    emin = float(np.percentile(rms[m], 10)) / emax
    k = float(kick[np.argmin(np.abs(times - s))])
    cands.append((round(s, 3), n, round(e, 3), round(emin, 3), round(k, 3)))
    n += 1
best = sorted([c for c in cands if c[1] % 4 == 0], key=lambda c: -(c[2] + 0.5 * c[3] + 0.3 * c[4]))[:6]
# drops: maiores saltos de energia de um segundo para o seguinte
jumps = sorted([(s + 1, round((eps[s + 1] - eps[s]) / emax, 3)) for s in range(len(eps) - 1)], key=lambda x: -x[1])[:5]
print(json.dumps({"arquivo": path, "bpm": round(60 / T, 2), "t0": round(t0, 4), "T": round(T, 5), "residuo_ms": round(res),
                  "energia_por_segundo": [round(e / emax, 2) for e in eps],
                  "melhores_janelas(t_inicio,batida,energia,energia_min,kick)": best, "drops(t,salto)": jumps}, ensure_ascii=False))
