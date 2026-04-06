//
//  VerificationPhonesView.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 10/01/23.
//

import UIKit
import OlchaUI
import OlchaCore

public class VerificationPhonesView: UIView {
    public let firstNumberField = TField()
    private let firstSeparator = Divide()
    
    public let secondNumberField = TField()
    private let secondSeparator = Divide()
    
    public let thirdNumberField = TField()
    
    var phonesFillObserver: ((Bool) -> Void)?
    
    public lazy var fields = [firstNumberField, secondNumberField, thirdNumberField]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        baseSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        baseSetup()
    }
    
    private func baseSetup() {
        setupViews()
        autolayout()
        configureViews()
    }
    
    private func setupViews() {
        addSubview(firstNumberField)
        addSubview(firstSeparator)
        
        
        addSubview(secondNumberField)
        addSubview(secondSeparator)
        
        addSubview(thirdNumberField)
    }
    
    private func autolayout() {
        firstNumberField.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        firstSeparator.snp.makeConstraints { make in
            make.top.equalTo(firstNumberField.snp.bottom).inset(-16)
            make.left.right.equalToSuperview()
        }
        
        secondNumberField.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(firstSeparator.snp.bottom).inset(-16)
        }
        
        secondSeparator.snp.makeConstraints { make in
            make.top.equalTo(secondNumberField.snp.bottom).inset(-16)
            make.left.right.equalToSuperview()
        }
        
        thirdNumberField.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(secondSeparator.snp.bottom).inset(-16)
            make.bottom.equalToSuperview()
        }
        
    }
    
    private func configureViews() {
        
        [firstNumberField, secondNumberField, thirdNumberField].forEach {
            $0.topHint = "phone_number".localized()
            $0.type = .shortPhone
        }
        
        firstNumberField.isRequired = true
        secondNumberField.isRequired = true
        thirdNumberField.isRequired = true
        
        firstNumberField.observeText { [weak self] in
            guard let self = self else { return }
            self.buttonState()
        }
        
        secondNumberField.observeText { [weak self] in
            guard let self = self else { return }
            self.buttonState()
        }
        
        thirdNumberField.observeText { [weak self] in
            guard let self = self else { return }
            self.buttonState()
        }
        
        thirdNumberField.field_tag = VerificationViewModel.phone_tag
        
    }
    
    @discardableResult
    func buttonState(isObserving: Bool = true) -> Bool {
        
        var phonesSet: Set<String> = Set()
        
        phonesSet.insert(firstNumberField.getValue())
        phonesSet.insert(secondNumberField.getValue())
        phonesSet.insert(thirdNumberField.getValue())
        
        let isEnabled = firstNumberField.isValidated() && secondNumberField.isValidated() && thirdNumberField.isValidated() && (phonesSet.count == 3)
        
        if isEnabled {
            firstNumberField.defaultStyle()
            secondNumberField.defaultStyle()
            thirdNumberField.defaultStyle()
        } else {
            firstNumberField.errorStyle()
            secondNumberField.errorStyle()
            thirdNumberField.errorStyle( (phonesSet.count == 3) ? "" : "phones_unique_error".localized() )
        }
        
        if isObserving {
            self.phonesFillObserver?(isEnabled)
        }
        return isEnabled
    }
    
    func fillPhones(data: [PhoneModel]) {
        
        for i in 0..<data.count {
            if i == 0 {
                firstNumberField.setPhone(number: data[0].phone)
            }
            
            if i == 1 {
                secondNumberField.setPhone(number: data[1].phone)
            }
            
            if i == 2 {
                thirdNumberField.setPhone(number: data[2].phone)
            }
        }
    }
    
}
