//
//  LanguageObserver.swift
//  OlchaUI
//
//  Created by Elbek Khasanov on 28/04/23.
//

import Foundation
import Combine
public class LanguageObserver {
    nonisolated(unsafe) public static let shared = LanguageObserver()
    public init() {}
    public let observer = PassthroughSubject<Void, Never>()
}
