//
//  InvestOlchaButton.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 22/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import OlchaUI

public class InvestOlchaButton: OlchaButton {
    
    public var isEnabled: Bool = true {
        didSet {
            setButtonEnabled(isEnabled)
        }
    }
    
    public func setButtonEnabled(_ isEnabled: Bool) {
        guard !settings.requesting else { return }
        settings.backgroundColor = isEnabled ? .olchaPrimaryColor : .olchaLightNeutralGray
        settings.isEnabled = isEnabled
    }
    
}
