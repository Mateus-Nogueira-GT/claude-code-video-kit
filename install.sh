#!/usr/bin/env bash
# Instala o Claude Code Video Kit.
#   ./install.sh            → instala para o seu usuário (~/.claude/skills), vale em qualquer projeto
#   ./install.sh --projeto  → instala só no projeto atual (./.claude/skills)
set -euo pipefail

KIT_DIR="$(cd "$(dirname "$0")" && pwd)"
if [[ "${1:-}" == "--projeto" ]]; then
  DEST="$PWD/.claude/skills"; SCOPE_FLAG=""
else
  DEST="$HOME/.claude/skills"; SCOPE_FLAG="-g"
fi
mkdir -p "$DEST"
echo "→ Destino das skills: $DEST"

aviso() { command -v "$1" >/dev/null 2>&1 && echo "  ✓ $1" || echo "  ⚠ $1 não encontrado — $2"; }
echo "→ Conferindo ferramentas"
command -v node >/dev/null || { echo "  ✗ Node.js é obrigatório (https://nodejs.org)"; exit 1; }
command -v git  >/dev/null || { echo "  ✗ git é obrigatório"; exit 1; }
echo "  ✓ node $(node -v)"; echo "  ✓ git"
aviso ffmpeg "necessário para revisar vídeos e medir áudio (brew install ffmpeg)"
aviso uv "necessário para os scripts de batida (https://docs.astral.sh/uv)"
aviso whisper-cli "necessário para transcrever (brew install whisper-cpp + um modelo ggml)"

echo "→ Skill oficial do Remotion (remotion-dev/skills, direto da fonte)"
npx -y skills add remotion-dev/skills -a claude-code -s '*' -y $SCOPE_FLAG  # vazio = projeto (compatível com o bash 3.2 do macOS)

echo "→ video-shotcraft (Vincentwei1021/video-shotcraft, Apache-2.0)"
if [[ -d "$DEST/video-shotcraft/.git" ]]; then
  git -C "$DEST/video-shotcraft" pull --ff-only -q && echo "  atualizada"
else
  git clone -q --depth 1 https://github.com/Vincentwei1021/video-shotcraft.git "$DEST/video-shotcraft" && echo "  instalada"
fi

echo "→ Skills do kit"
for s in "$KIT_DIR"/skills/*/; do
  name="$(basename "$s")"
  rm -rf "$DEST/$name"; cp -R "$s" "$DEST/$name"; echo "  ✓ $name"
done

echo
echo "Pronto! Abra uma NOVA sessão do Claude Code para as skills aparecerem."
