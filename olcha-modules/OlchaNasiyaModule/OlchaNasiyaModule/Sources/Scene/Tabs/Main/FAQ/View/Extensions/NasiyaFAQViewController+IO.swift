//
//  NasiyaNotificationsViewController+IO.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 12/05/23.
//

import Foundation
import OlchaCommon
import OlchaUtils
public extension NasiyaFAQViewController {
    struct Input {
        var faqs = PagingData<CommonFAQModel>()

        public init() {}
    }
    
    struct Output {
        public init() {}
    }
}
