//
//  PassportScanPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 14/09/22.
//

import UIKit
//import MLKit
//import AVFoundation
//class PassportScanPage: BaseViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
//
//    private let captureSession = AVCaptureSession()
//    private let videoOutput = AVCaptureVideoDataOutput()
//
//    private lazy var previewLayer: AVCaptureVideoPreviewLayer = {
//        let preview = AVCaptureVideoPreviewLayer(session: self.captureSession)
//        preview.videoGravity = .resizeAspect
//        return preview
//    }()
//    
//    private var rate = 0
//    private let maxRate = 5
//    
//    override func setupViews() {
//        self.view.layer.addSublayer(self.previewLayer)
//    }
//    
//    override func initialRequest() {
//        self.addVideoOutput()
//        self.captureSession.startRunning()
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        previewLayer.frame = view.bounds
//    }
//    
//    override func configureViews() {
//        super.configureViews()
//        addCameraInput()
//    }
//    
//    private func addCameraInput() {
//        
//        guard let device = AVCaptureDevice.default(for: .video) else { return }
//        do {
//            let cameraInput = try AVCaptureDeviceInput(device: device)
//            self.captureSession.addInput(cameraInput)
//        } catch {
//            
//        }
//    }
//    
//    private func addVideoOutput() {
//        self.videoOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(value: kCVPixelFormatType_32BGRA)] as [String : Any]
//        self.videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "my.image.handling.queue"))
//        self.captureSession.addOutput(self.videoOutput)
//    }
//    
//    func captureOutput(_ output: AVCaptureOutput,
//                       didOutput sampleBuffer: CMSampleBuffer,
//                       from connection: AVCaptureConnection) {
//        
//        guard rate == maxRate else { rate += 1; return }
//        rate = 0
//        
//        
//        guard let frame = CMSampleBufferGetImageBuffer(sampleBuffer) else {
//            
//            return
//        }
//        guard let attachments = CMCopyDictionaryOfAttachments(allocator: kCFAllocatorDefault, target: sampleBuffer, attachmentMode: kCMAttachmentMode_ShouldPropagate) as? [CIImageOption : Any] else { return }
//        let ciImage = CIImage(cvImageBuffer: frame, options: attachments)
//        guard let cgImage = convertCIImageToCGImage(inputImage: ciImage) else { return }
//        let image = UIImage(cgImage: cgImage)
//        PassportScanManager.shared.runTextRecognition(with: image)
//        // process image here
//    }
//    
//    func convertCIImageToCGImage(inputImage: CIImage) -> CGImage? {
//        let context = CIContext(options: nil)
//        if let cgImage = context.createCGImage(inputImage, from: inputImage.extent) {
//            return cgImage
//        }
//        return nil
//    }
//    
//}
