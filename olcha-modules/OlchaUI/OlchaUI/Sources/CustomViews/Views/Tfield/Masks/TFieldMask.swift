//
//  TFieldValidation.swift
//  OlchaUI
//
//  Created by Elbek Khasanov on 20/02/23.
//

import UIKit
public protocol TFieldMask: AnyObject {
    func execute(textField: UITextField, range: NSRange, replacingText: String) -> Bool
}
