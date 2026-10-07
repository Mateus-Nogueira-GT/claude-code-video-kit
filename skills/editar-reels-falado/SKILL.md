---
name: editar-reels-falado
description: Edita um vídeo falado (Reels/TikTok/YouTube) com Remotion — transcreve com tempo por palavra, coloca headline no estilo nativo do Instagram, insere B-roll/cartões exatamente na palavra falada sem cobrir o rosto e confere o resultado. Use quando o usuário mandar uma gravação dele falando e pedir textos, imagens ou vídeos "quando eu falar X".
---

# Editar vídeo falado

## 1. Entender o bruto
- Copiar para `input/video/`. `ffprobe` para resolução, fps, duração (iPhone costuma ser HEVC 1080x1920 — o Remotion lê).
- **Transcrever com tempo por palavra** (local, grátis):
  `ffmpeg -i in.mp4 -ac 1 -ar 16000 a.wav && whisper-cli -m ggml-small.bin -l pt -ml 1 -sow -f a.wav`
- Os tempos que o usuário "chuta" costumam estar errados: **sincronize pela fala real** e avise
  ("você disse 6 s, mas a frase começa em 4,6 s").
- Prancha de frames (fps=1/2) para ver onde fica o rosto (normalmente 20–55% da altura).

## 2. Headline
- Estilo **texto nativo do Instagram**: fonte do sistema (`system-ui, -apple-system`), peso 500, ~66–76 px,
  texto preto em caixa cinza-clara `rgba(232,232,232,0.92)` por linha, cantos 16 px, linhas encostadas, **sem animação**.
  Topo em ~260–300 px (abaixo da área da interface). Performa melhor que letreiro "elaborado".

## 3. Inserções (B-roll, prints, vídeos, take do GitHub)
- Entram no **frame da palavra** (`Math.round(seg * fps)`), saem quando a frase acaba.
- Cartão 16:9 (~1000×562) **na altura do peito** (centro ~1300 px) para não cobrir o rosto; borda branca 6 px,
  cantos 26 px, sombra. Montagem rápida: ~13 frames por vídeo, cortes secos, só o primeiro com "pop".
- Crédito do criador (`@handle`) no **canto de cima** do cartão (a legenda do Instagram cobre a parte de baixo).
- "Take do GitHub": capturar a página com Chrome headless 2x
  (`chrome-headless-shell --headless --force-device-scale-factor=2 --window-size=1280,2200 --screenshot=...`),
  janela de navegador com barra de endereço, câmera começando legível (zoom ~1.7) e zoom rápido na parte citada.
  Cuidado com contradição entre fala e imagem (ex.: não destacar "10k estrelas" se a fala diz "quase ninguém usa").

## 4. Conferir e entregar
- Usar a skill `revisar-video`. Render com `--timeout=120000` se o navegador demorar para subir.
- Áudio original intacto; não adicionar SFX sem pedido.
