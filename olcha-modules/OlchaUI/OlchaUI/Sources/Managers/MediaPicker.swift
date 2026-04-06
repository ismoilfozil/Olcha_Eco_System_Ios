//
//  MediaPickerPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 03/08/22.
//

import UIKit
import PhotosUI
import Photos
import Combine
import AVFoundation
import OlchaUtils
public class MediaPicker: NSObject {
    
    public enum MediaMimeType: String {
        case image = "image/jpeg"
        case video = "video/mp4"
    }
    
    public enum MediaType {
        case image
        case video
    }
    
    private weak var controller: UIImagePickerController?
    public weak var selectedImageObserver: PassthroughSubject<UIImage?, Never>?
    public weak var selectedVideoObserver: PassthroughSubject<Video?, Never>?
    public weak var presentLastPage: PassthroughSubject<Bool, Never>?
    public var mediaType: MediaType = .image
    
    public func present(navigationController: UINavigationController, sourceType: UIImagePickerController.SourceType) {
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .authorized {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = sourceType
            if mediaType == .video {
                controller.mediaTypes = ["public.movie"]
            }
            self.controller = controller
            
            navigationController.present(controller, animated: true, completion: nil)
            
        } else {
            checkPermission(navigationController: navigationController,
                            sourceType: sourceType)
        }
    }
}

extension MediaPicker: UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    private func checkPermission(navigationController: UINavigationController, sourceType: UIImagePickerController.SourceType) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { [weak self] status in
                if status == .authorized {
                    Task { @MainActor in
                        guard let self = self else { return }
                        self.present(navigationController: navigationController, sourceType: sourceType)
                    }
                }
            }
        case .authorized:
            present(navigationController: navigationController, sourceType: sourceType)
            
        default:
            CameraManager.presentDeniedError()
            break
        }
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if (info[.mediaType] as? String) == "public.movie" {
            if let mediaURL = info[.mediaURL] as? URL,
               let videoData = NSData(contentsOf: mediaURL) as Data?
            {
                let video = Video(data: videoData, url: mediaURL)
                selectedVideoObserver?.send(video)
            }
        } else {
            let selectedImage = info[.originalImage] as? UIImage
               selectedImageObserver?.send(selectedImage)
        }
         
        
        picker.dismiss(animated: true, completion: { [weak self] in
            guard let self = self else { return }
            self.presentLastPage?.send(true)
        })
    }
    
}
