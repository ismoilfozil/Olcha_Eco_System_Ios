//
//  CodeTextField.swift
//  NewOlcha
//
//  Created by Muhammadjon on 2/23/21.
//
import UIKit

@MainActor public protocol CodeTextFieldDelegate: AnyObject {
    func deleteBackward(sender: CodeTextField, prevValue: String?)
}

open class CodeTextField: UITextField {
    
    weak open var deleteDelegate: CodeTextFieldDelegate?

    override open func deleteBackward() {
        let prevValue = text
        super.deleteBackward()
        deleteDelegate?.deleteBackward(sender: self, prevValue: prevValue)
    }
}
