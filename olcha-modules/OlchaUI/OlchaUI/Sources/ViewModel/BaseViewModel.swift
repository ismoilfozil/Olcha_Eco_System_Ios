//
//  BaseViewModel.swift
//  OlchaUI
//
//  Created by Elbek Khasanov on 26/01/23.
//

import Foundation
import Combine
open class BaseViewModel: NSObject {
    /// Cancellables for `Combine`
    public var bag: Set<AnyCancellable>

    override public init() {
        bag = Set<AnyCancellable>()
    }
}

