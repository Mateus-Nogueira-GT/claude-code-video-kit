---
name: recortar-objeto
description: Recorta o fundo de fotos de produto ou de pessoas (PNG transparente) usando o Vision do macOS — o mesmo recurso do app Fotos. Use quando precisar de produto/pessoa flutuando sobre um fundo novo num vídeo (macOS 14+).
---

# Recortar objeto/pessoa (macOS)

```bash
swift scripts/recortar.swift entrada.jpg saida.png          # todos os objetos em primeiro plano
swift scripts/recortar.swift entrada.jpg saida.png 0.38,0.4 # só a pessoa/objeto nesse ponto (x,y de 0 a 1)
```

- Funciona muito bem até em casos difíceis (tênis vermelho em fundo vermelho, verde em fundo verde).
- Fotos com várias pessoas: passe o ponto da pessoa desejada (ver a prancha da foto antes).
- O PNG sai recortado justo no objeto; guarde em `input/images/<tema>/recortes/`.
- Recortes de fotos pequenas ficam suaves quando ampliados — prefira originais ≥ 1500 px.
- Respeite a licença da foto (Unsplash livre; Wikimedia CC BY/BY-SA exigem crédito).
