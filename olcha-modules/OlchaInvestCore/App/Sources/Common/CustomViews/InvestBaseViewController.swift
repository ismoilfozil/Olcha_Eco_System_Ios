//
//  InvestBaseViewController.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 04/07/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

public class InvestBaseViewController<NavigationBar: UIView>: BaseViewController<NavigationBar> {
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        hideLoader()
    }
    
}
