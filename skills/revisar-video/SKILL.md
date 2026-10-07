---
name: revisar-video
description: Checklist de revisão antes de entregar qualquer vídeo — pranchas de frames, frames exatos de transição, pico de áudio, texto cortado, rosto coberto, resto de texto original e verdade das afirmações. Use sempre antes de dizer que um vídeo está pronto.
---

# Revisar vídeo antes de entregar

Scripts em `scripts/`:
- `prancha.sh video.mp4 saida.jpg [fps] [colunas]` — o vídeo inteiro numa imagem (padrão: 2 quadros/s).
- `frames.sh video.mp4 saida.jpg 450 451 452` — frames exatos lado a lado (transições).
- `audio.sh video.mp4` — volume médio/pico e os frames mais altos.

## Checklist
1. **Prancha do vídeo final** (não só stills do código): procurar texto cortado nas bordas, rosto coberto,
   elemento vazando, restos do conteúdo original, cenas fora de ordem.
2. **Transições frame a frame** em cada troca de cena e onde há remendos/overlays.
3. **Áudio**: pico ≤ -1 dB. Se passar, achar o frame (`audio.sh`) e baixar o efeito daquele momento.
4. **Sincronia**: cortes na batida (skill `sincronizar-batida`), inserções na palavra falada.
5. **Texto**: tamanho calculado pela palavra mais longa (fontes largas estouram); quebrar em linhas se preciso.
6. **Verdade**: não afirmar o que não se sabe (ex.: "feito com Claude Code" sobre vídeo de terceiros que pode ter sido
   feito com outra ferramenta); créditos e licenças registrados; marcas reais só como demonstração.
7. **Entrega**: duração e resolução conferidas com `ffprobe`; versão com e sem música quando houver trilha.
8. Render travando em "headless browser" → `--timeout=120000`.

Sempre mostrar ao usuário o que foi conferido e o que ficou de fora — nunca dizer "pronto" sem ter olhado o arquivo final.
