---
name: organizar-projeto-video
description: Cria ou organiza um projeto Remotion no fluxo INPUT → INSTRUCTIONS + REFERENCES → REMOTION → OUTPUT (pastas input/, instructions/, references/, output/). Use ao começar qualquer projeto de vídeo com Claude Code ou quando o usuário pedir para "organizar o projeto de vídeo".
---

# Organizar projeto de vídeo (Remotion)

A IA erra muito menos quando sabe onde está cada coisa. Todo projeto segue:

```
INPUT  →  INSTRUCTIONS + REFERENCES  →  REMOTION  →  OUTPUT
```

| Pasta | Papel | Exemplos |
|---|---|---|
| `input/` | matéria-prima | `video/`, `audio/`, `images/`, `subtitles/`, `data/` |
| `instructions/` | o que fazer | um `video-instructions-<nome>.md` por vídeo |
| `references/` | como deve parecer | prints, paletas, análises de anúncios — **nunca copiar literalmente** |
| `output/` | resultado | só MP4/PNG renderizados — **nunca código** |

## Passos
1. Se não houver projeto: criar Remotion (`remotion`, `@remotion/cli`, `react`, `react-dom`, `typescript`) com
   `src/index.ts` (registerRoot), `src/Root.tsx`, `src/compositions/<nome>/`.
2. `remotion.config.ts`: `Config.setPublicDir("./input")` — assim `staticFile("audio/x.mp3")` lê `input/audio/x.mp3`.
3. `src/workflow/input.ts` com helpers (`inputVideo`, `inputAudio`, `inputImage` = `staticFile` com o prefixo da subpasta).
4. Criar `input/{video,audio,images,subtitles,data}/.gitkeep`, `output/.gitkeep`, `references/README.md`,
   `instructions/README.md` e o template `instructions/video-instructions.md` (Objetivo, Formato, Roteiro, Direção de
   edição, Legendas, Animações, Transições, B-roll, Trilha e áudio, CTA, Observações).
5. `.gitignore`: `output/*` (exceto `.gitkeep`), mídia pesada em `input/` e `references/` (mp4, mov, mp3, wav…), mantendo
   `README.md` e `instructions/`.
6. `VIDEO_WORKFLOW.md` na raiz explicando o fluxo + `CLAUDE.md` apontando para ele (para futuros agentes).
7. Um script de render por vídeo no `package.json` (`remotion render <Id> output/<nome>.mp4`).

## Regras
- Nunca editar/mover/apagar arquivos de `input/`; copiar o bruto para lá antes de usar.
- Registrar cada pedido do usuário em `instructions/` (decisões, tempos, roteiro) antes ou logo depois de produzir.
- Instruções vazias ou ambíguas → perguntar antes de assumir.
