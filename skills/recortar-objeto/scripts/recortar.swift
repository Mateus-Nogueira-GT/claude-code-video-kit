// Recorta o objeto principal de uma foto (mesmo recurso de "separar do fundo" do app Fotos).
// Uso: swift scripts/recortar.swift entrada.jpg saida.png [x,y]
//   x,y opcional (0–1, origem no canto superior esquerdo): recorta só o objeto/pessoa nesse ponto.
import Foundation
import Vision
import CoreImage
import ImageIO
import UniformTypeIdentifiers

let args = CommandLine.arguments
guard args.count >= 3 else { print("uso: recortar.swift entrada saida.png [x,y]"); exit(1) }
let input = URL(fileURLWithPath: args[1])
let output = URL(fileURLWithPath: args[2])

guard let src = CGImageSourceCreateWithURL(input as CFURL, nil),
      let cg = CGImageSourceCreateImageAtIndex(src, 0, nil) else { print("não abriu \(input.path)"); exit(1) }

let request = VNGenerateForegroundInstanceMaskRequest()
let handler = VNImageRequestHandler(cgImage: cg)
try handler.perform([request])
guard let result = request.results?.first else { print("nenhum objeto encontrado"); exit(2) }

var instances = result.allInstances
if args.count >= 4 {
    let xy = args[3].split(separator: ",").compactMap { Double($0) }
    let mask = result.instanceMask
    CVPixelBufferLockBaseAddress(mask, .readOnly)
    let w = CVPixelBufferGetWidth(mask), h = CVPixelBufferGetHeight(mask)
    let row = CVPixelBufferGetBytesPerRow(mask)
    let base = CVPixelBufferGetBaseAddress(mask)!.assumingMemoryBound(to: UInt8.self)
    let px = min(w - 1, Int(xy[0] * Double(w))), py = min(h - 1, Int(xy[1] * Double(h)))
    let label = Int(base[py * row + px])
    CVPixelBufferUnlockBaseAddress(mask, .readOnly)
    if label == 0 { print("ponto \(args[3]) caiu no fundo; usando todas as instâncias") } else { instances = IndexSet(integer: label) }
}
let buffer = try result.generateMaskedImage(ofInstances: instances, from: handler, croppedToInstancesExtent: true)
let ci = CIImage(cvPixelBuffer: buffer)
let ctx = CIContext()
guard let outCG = ctx.createCGImage(ci, from: ci.extent),
      let dest = CGImageDestinationCreateWithURL(output as CFURL, UTType.png.identifier as CFString, 1, nil) else { exit(3) }
CGImageDestinationAddImage(dest, outCG, nil)
CGImageDestinationFinalize(dest)
print("ok \(output.lastPathComponent) \(outCG.width)x\(outCG.height) instâncias=\(result.allInstances.count) usadas=\(instances.count)")
