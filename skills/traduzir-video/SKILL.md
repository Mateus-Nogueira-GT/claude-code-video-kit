---
name: traduzir-video
description: Cria a versão em outro idioma (ex. PT-BR) de um vídeo curto explicativo — remove a narração, cobre os títulos originais com remendos da cor do fundo e escreve os títulos traduzidos no mesmo estilo, troca a legenda e opcionalmente encurta acelerando. Use quando pedirem "transforma esse vídeo em português".
---

# Traduzir vídeo de motion graphics

1. **Entender**: `whisper-cli -l auto` (idioma + texto com tempos) e prancha a cada 2 s.
   Avisar sobre direitos (vídeo de outra pessoa → permissão + crédito) e sobre promessas do CTA original.
2. **Roteiro traduzido e mais curto** mantendo todas as etapas da lógica. Perguntar: voz (gravar / sem voz + música /
   só legenda) e visual (recriar / usar o original).
3. **Encurtar sem perder lógica**: sem narração, acelerar 1,3–1,4x (`OffthreadVideo playbackRate`) em vez de cortar.
   Converter tempos: `frame = seg * fps / velocidade`.
4. **Mapear cada texto em inglês**: pranchas recortadas na faixa do título a cada 0,5 s (e 0,2 s nas bordas)
   para achar início/fim e posição; **confirmar os limites extraindo frames exatos** — leituras de prancha erram ±1 s.
5. **Cor do fundo**: medir a média de uma faixa vazia ao lado do título (ex.: #EDEBE5); cenas escuras/gradientes à parte.
6. **Remendo**: retângulo da cor do fundo com **margem extra** (+16 px em cima, +20 embaixo) e **borda suave de tamanho
   fixo** (14 px). Borda proporcional deixa remendos grandes "vazarem".
7. **Título traduzido** no mesmo estilo (ex.: serifa condensada → Instrument Serif; itálico na palavra de destaque),
   legenda substituída palavra a palavra.
8. **Transições**: quando a cena seguinte entra de baixo para cima, terminar cada camada no frame em que a nova cena chega
   nela (legenda antes, título depois) — conferir frame a frame.
9. Textinhos de interface que se movem dentro de cartões podem ficar no original; a legenda explica.
10. Trocar o CTA se pedido (cobrir a área toda e montar uma tela própria, ex.: salva/comenta/compartilha).
