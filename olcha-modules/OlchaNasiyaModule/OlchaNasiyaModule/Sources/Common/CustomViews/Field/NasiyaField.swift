//
//  NasiyaField.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 22/05/23.
//

import UIKit
import OlchaUI
public class NasiyaField: TField {
    
    @discardableResult
    public override func becomeFirstResponder() -> Bool {
        settings.becomeFirstResponder()
        return settings.canBecomeFirstResponder
    }

    @discardableResult
    public override func resignFirstResponder() -> Bool {
        settings.resignFirstResponder()
        return settings.canResignFirstResponder
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        baseSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func baseSetup() {
        autolayout()
        configureViews()
    }
    
    private func autolayout() {
        topHintLabel.snp.updateConstraints { make in
            make.left.equalToSuperview().inset(5)
        }
        
    }
    
    public func configureViews() {
        textFieldContainer.round(8)
        textFieldContainer.border(with: .olchaLightNeutralDarkGray)
        topHintLabel.style(.regular, 16)
        phoneSeparator.backgroundColor = .olchaLightNeutralDarkGray
        disableEditing()
    }
    
    public override func defaultStyle() {
        super.defaultStyle()
        fieldState = .def
        textFieldContainer.border(with: .olchaLightNeutralDarkGray)
    }
    
    public func disableEditing(withBackground: Bool = false) {
        isUserInteractionEnabled = false
        textFieldContainer.backgroundColor = withBackground ? .olchaLightNeutralGray : .olchaWhite
    }
    
    public func enableEditing() {
        isUserInteractionEnabled = true
        textFieldContainer.backgroundColor = .olchaWhite
    }

}

