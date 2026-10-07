---
name: sincronizar-batida
description: Mede BPM, grade e drops de uma trilha e coloca cortes/efeitos exatamente nos ataques da música, com teste final (erro ≤ 3 frames). Use em qualquer vídeo com música onde cortes, carimbos de texto ou impactos devem cair na batida.
---

# Sincronizar com a batida

Scripts em `scripts/` (rodar com `uv run --with librosa --with scipy --python 3.11 <script>`).

1. **Grade e trecho**: `analisar_batida.py musica.mp3 [duracao_s]` → BPM, t0, resíduo da grade (≤ ~20 ms = confiável),
   energia por segundo, melhores janelas e "drops" (saltos de energia).
2. **Drop exato**: `ataques.py musica.mp3 INICIO FIM t0 T` → ataques reais perto do drop.
   Atenção: o padrão do bumbo pode mudar no drop (a grade antes do drop fica meia batida fora) — reancore no ataque real.
3. **Montar a linha do tempo**:
   - Gancho de redes: o vídeo começa NO drop (`trimBefore = round(drop*30)`), ou o impacto visual cai no drop
     (`trimBefore = round(drop*30) - frameDoImpacto`).
   - Cortes a cada 4 batidas (house/pop) ou 2–3 (lento). Palavras "carimbadas" 1 por batida/2 batidas.
   - **Trilha orquestral/épica não tem ataque em toda batida**: liste os ataques com `--banda todas` e ancore cada corte
     num ataque real; o mais forte vai no momento principal (logo/CTA).
4. **Testar**: `testar_sincronia.py musica.mp3 FRAME_INICIO DURACAO "[cortes]" [--banda todas]` → erro ≤ 3 f.
   Se "falhar" num hip-hop/épico, teste também `--banda todas` (caixa em vez de bumbo) antes de mexer nos cortes.
   Dê ~20 frames de margem antes do primeiro corte (o detector não vê ataques colados no início).
5. **Mixagem**: trilha ~0,3–0,5; SFX com o PICO do arquivo no frame do evento (`from = hit - peak`); conferir pico
   final ≤ -1 dB (skill `revisar-video`). Gerar versão com e sem música via prop `bgm`.

Licença: use trilhas com licença clara (ex.: Mixkit Free License) e registre autor + URL.
