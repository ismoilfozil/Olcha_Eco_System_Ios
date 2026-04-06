//
//  NasiyaButton.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 11/05/23.
//

import UIKit
import OlchaUI
public class NasiyaButton: OlchaButton {
    public override func configureViews() {
        super.configureViews()
        settings.backgroundColor = .olchaPrimaryColor
    }
}
