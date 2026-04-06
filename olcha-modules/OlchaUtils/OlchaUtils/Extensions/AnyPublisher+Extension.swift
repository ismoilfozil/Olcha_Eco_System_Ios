//
//  AnyPublisher+Extension.swift
//  OlchaUtils
//
//  Created by Elbek Khasanov on 08/07/23.
//

import Foundation
import Combine
public extension AnyPublisher {
    static func empty() -> AnyPublisher<Output, Never> {
        Empty<Output, Never>().eraseToAnyPublisher()
    }
}
