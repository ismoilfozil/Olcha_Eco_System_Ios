//
//  ReturnOrderReasonViewController+IO.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 18/10/23.
//

import UIKit
import Combine
import OlchaUI
extension ReturnOrderReasonViewController {
    
    struct Input {
        var reason: ReturnOrderReason = .return
        let reasons: [ReturnOrderReason] = [
            .return,
            .change,
            .other
        ]
        var order: Order?
        var product: ProductModel?
        
        var images: [File] = []
    }
    
    struct Output {
        let presentAddMedia = PassthroughSubject<MediaPicker.MediaType, Never>()
        let selectedImageObserver = PassthroughSubject<UIImage?, Never>()
        let removeMediaObserver = PassthroughSubject<Int, Never>()
    }
    
}
