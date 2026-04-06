//
//  LightField.swift
//  OlchaUI
//
//  Created by Elbek Khasanov on 06/02/24.
//

import Foundation
public class LightField: TField {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        textFieldContainer.backgroundColor = .olchaLightGray
        phoneSeparator.isHidden = true
        fieldHeight = 44
        defaultStyle()
    }
    
    public override func defaultStyle() {
        super.defaultStyle()
        textFieldContainer.border(width: 0)
    }
    
    public override func errorStyle(_ bottomHint: String? = nil) {
        super.errorStyle(bottomHint)
        textFieldContainer.border(with: .olchaAccentColor, width: 1)
    }
    
    public override func successStyle() {
        super.successStyle()
        textFieldContainer.border(with: .olchaGreen, width: 1)
    }
    
    public override func openPhoneContainer() {
        phoneContainer.snp.remakeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.right.equalTo(phoneSeparator.snp.left)
            make.left.equalToSuperview().inset(16)
        }
    }
}
