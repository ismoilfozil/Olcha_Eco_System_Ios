//
//  PassportScanManager.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 14/09/22.
//

//import Foundation
//import MLKit
//import UIKit
//class PassportScanManager {
//
//    static let shared = PassportScanManager()
//    
//    private lazy var textRecognizer = TextRecognizer.textRecognizer(options: TextRecognizerOptions())
//
//    func runTextRecognition(with image: UIImage?) {
//        
//        guard var image = image else { return }
//        
//        
//        let visionImage = VisionImage(image: image)
//        
//        textRecognizer.process(visionImage) { [weak self] features, error in
//            guard let self = self else { return }
//            self.processResult(from: features, error: error)
//        }
//    }
//    
//    func processResult(from text: Text?, error: Error?) {
//        
//        guard error == nil, let text = text else {
//          let errorString = error?.localizedDescription
//          print("Text recognizer failed with error: \(errorString)")
//          return
//        }
//
//        // Blocks.
//        for block in text.blocks {
//            let blockText = block.text
//
//          // Lines.
//          for line in block.lines {
//              let lineText = line.text
//              
//              if lineText.count == 44 {
//                  let letters = lineText[0..<2]
//                  let serial = lineText[2..<9]
//                  if serial.matches("[0-9]") && letters.matches("[A-Z]") {
//                      print("password = ", letters, serial)
//                  }
//              }
//
//            // Elements.
//            for element in line.elements {
//            }
//          }
//        }
//      }
//    
//    func convertCIImageToCGImage(inputImage: CIImage) -> CGImage? {
//        let context = CIContext(options: nil)
//        if let cgImage = context.createCGImage(inputImage, from: inputImage.extent) {
//            return cgImage
//        }
//        return nil
//    }
//}
