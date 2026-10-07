# 🎬 Claude Code Video Kit

**Transforme o Claude Code num editor de vídeo profissional — com Remotion.**

Este repositório reúne, num só lugar, as skills que eu uso para editar vídeos só conversando com o Claude Code:
Reels falados, comerciais de produto, vídeos traduzidos, showreels de motion design. Nada de Premiere ou After Effects —
o Claude escreve o código do vídeo ([Remotion](https://www.remotion.dev): React → MP4) e confere o resultado.

Um comando instala tudo:

```bash
git clone https://github.com/Mateus-Nogueira-GT/claude-code-video-kit.git
cd claude-code-video-kit
./install.sh
```

Depois abra uma **nova** sessão do Claude Code e peça o vídeo.

---

## Para que serve

| Você quer… | A skill que resolve |
|---|---|
| Começar um projeto de vídeo organizado | **organizar-projeto-video** |
| Editar o seu vídeo falando (headline, B-roll na palavra certa, sem cobrir o rosto) | **editar-reels-falado** |
| Cortes e efeitos caindo exatamente na batida da música | **sincronizar-batida** |
| Produto ou pessoa "flutuando" sem fundo | **recortar-objeto** (macOS) |
| Versão em português de um vídeo gringo | **traduzir-video** |
| Ter certeza de que está tudo certo antes de postar | **revisar-video** |
| Comerciais cinematográficos de produto (157 efeitos prontos) | **video-shotcraft** *(terceiros)* |
| Boas práticas oficiais do Remotion (legendas, render, Studio…) | **remotion-best-practices** e cia. *(oficial)* |

## O que o instalador faz

1. **Skill oficial do Remotion** — instala direto da fonte com `npx skills add remotion-dev/skills`
   (12 sub-skills: criar, markup, legendas, render, Studio, documentação…).
2. **[video-shotcraft](https://github.com/Vincentwei1021/video-shotcraft)** — clona do repositório original (Apache-2.0).
3. **As 6 skills deste kit** — copia `skills/*` para `~/.claude/skills` (ou `./.claude/skills` com `--projeto`).

As skills de terceiros **não são copiadas para cá**: são sempre baixadas da fonte oficial, respeitando as licenças dos
autores e chegando sempre na versão mais nova.

## As skills deste kit

### 📁 organizar-projeto-video
O segredo que quase ninguém usa: **4 pastas** — `input/` (matéria-prima), `instructions/` (o que fazer),
`references/` (como deve parecer) e `output/` (resultado). Fluxo: `INPUT → INSTRUCTIONS + REFERENCES → REMOTION → OUTPUT`.

### 🗣️ editar-reels-falado
Transcreve com tempo por palavra (Whisper local), coloca headline no **estilo nativo do Instagram** e insere vídeos,
prints ou um "take do GitHub" no frame exato em que você fala a palavra — na altura do peito, sem cobrir o rosto.

### 🥁 sincronizar-batida
Mede BPM, grade e drop da trilha, lista os ataques reais e testa se cada corte caiu na batida (erro ≤ 3 frames).
Inclui o truque para trilhas orquestrais, que não têm ataque em toda batida.
Scripts: `analisar_batida.py`, `ataques.py`, `testar_sincronia.py`.

### ✂️ recortar-objeto
Recorte de fundo com o Vision do macOS (o mesmo do app Fotos) — inclusive escolhendo **uma pessoa específica** numa
foto com várias. Script: `recortar.swift`.

### 🌎 traduzir-video
Versão em outro idioma de um vídeo de motion graphics: remove a narração, cobre os títulos originais com remendos da cor
do fundo, escreve os títulos traduzidos no mesmo estilo e troca a legenda — com os cuidados de transição frame a frame.

### ✅ revisar-video
Checklist antes de entregar: prancha com o vídeo inteiro, frames exatos das transições, pico de áudio (≤ -1 dB),
texto cortado, rosto coberto e veracidade das afirmações. Scripts: `prancha.sh`, `frames.sh`, `audio.sh`.

## Exemplos de pedidos

```text
Organize esta pasta como projeto de vídeo (organizar-projeto-video).

Edite input/video/meu-reels.mp4: headline "Quem edita vídeo com IA faz isso" nos primeiros 4 s e,
quando eu falar "repositório", mostre a página do GitHub do projeto.

Use a video-shotcraft para um comercial de 7 s em 9:16 do meu produto, com cortes na batida.

Transforma esse vídeo em PT-BR, mais curto, sem voz, só texto e música.
```

## Requisitos

| Ferramenta | Para quê | Obrigatório |
|---|---|---|
| [Claude Code](https://claude.com/claude-code) | o editor (plano pago ou API) | sim |
| Node.js + git | Remotion e instalação | sim |
| ffmpeg | revisar vídeo, medir áudio | recomendado |
| [uv](https://docs.astral.sh/uv) | scripts de batida (librosa) | recomendado |
| whisper.cpp (`whisper-cli`) + modelo ggml | transcrição local | recomendado |
| macOS 14+ | `recortar-objeto` | só para essa skill |

O Remotion é grátis para pessoas e times pequenos; empresas maiores podem precisar da
[licença da empresa](https://www.remotion.dev/license).

## Créditos

- [Remotion](https://www.remotion.dev) e as [Remotion Agent Skills](https://github.com/remotion-dev/skills) — equipe Remotion.
- [video-shotcraft](https://github.com/Vincentwei1021/video-shotcraft) — Vincent Wei ([@VincentWei93](https://x.com/VincentWei93)).
- Skills deste kit: Mateus Nogueira ([@mateus.nnogueira](https://instagram.com/mateus.nnogueira)) — licença MIT.

Use músicas e imagens com licença clara (Mixkit, Unsplash, Wikimedia Commons) e dê os créditos pedidos.
Marcas e pessoas reais só como demonstração, nunca como anúncio oficial.
