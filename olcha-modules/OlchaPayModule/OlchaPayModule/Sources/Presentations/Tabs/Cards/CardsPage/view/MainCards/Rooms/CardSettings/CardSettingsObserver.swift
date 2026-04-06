//
//  CardSettingsObserver.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 07/02/23.
//

import Foundation
import Combine
public class CardSettingsObserver {
    public let cardUpdated = PassthroughSubject<UserBankCardModel?, Never>()
}
