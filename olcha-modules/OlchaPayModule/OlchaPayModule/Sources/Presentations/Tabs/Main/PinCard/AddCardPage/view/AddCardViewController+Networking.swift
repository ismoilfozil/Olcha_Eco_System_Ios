//
//  AddCardViewController+Networking.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 18/03/23.
//

import UIKit
public extension AddCardViewController {
    func verifyCard() {
        viewModel.getOTP(card: self.cardModel)
    }
}
