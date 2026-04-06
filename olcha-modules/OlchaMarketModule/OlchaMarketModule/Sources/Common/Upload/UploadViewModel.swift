//
//  UploadViewModel.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 02/08/22.
//

import Foundation
import UIKit
import Combine
import OlchaUI
import OlchaAuth
import OlchaCore
import OlchaUtils
public class UploadViewModel: OldBaseViewModel {
    
    static let shared = UploadViewModel()
    
    init() {
        super.init(manager: OlchaDIContainer.shared.resolve())
    }
    
    @Published var image: File?
    let uploadIndicator = CurrentValueSubject<Bool, Never>(false)
    let uploadProgress = PassthroughSubject<Double, Never>()
    
    func upload(image: UIImage?) {
        if Config.isDebug {
            self.image = File()
        }
        if let data = image?.jpegData(compressionQuality: 0.5) {
            let api: UploadAPI = .image(data: data)
            self.startUploading(api: api,
                                indicator: uploadIndicator) { [weak self] (data: ReviewFileData?) in
                guard let self = self else { return }
                self.image = data?.file
            }
        }
    }
}
