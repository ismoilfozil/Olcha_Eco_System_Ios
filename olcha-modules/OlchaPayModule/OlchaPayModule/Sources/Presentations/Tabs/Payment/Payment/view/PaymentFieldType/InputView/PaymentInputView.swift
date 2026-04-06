//
//  AmountFieldType.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 20/02/23.
//

import UIKit
import OlchaUI
import OlchaCore
public class PaymentInputView: BaseView, PaymentFieldProtocol {
    
    public lazy var textField: TField = {
        let field = TField()
        return field
    }()
    
    public var actionObserver: ((String?) -> Void)?

    public var valueUpdatedObserver: ((String?) -> Void)?
    
    private var model: PaymentFieldModel?
    
    public var field: TField {
        textField
    }
    
    public var isValidated: Bool {
        textField.isValidated()
    }
    
    public override func setupViews() {
        addSubview(textField)
    }
    
    public override func autolayout() {
        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        textField.observeText { [weak self] in
            guard let self = self else { return }
            self.actionObserver?(self.getValue())
        }
    }
    
    public func getValue() -> String? {
        textField.getValue()
    }
    
    public func getKey() -> String? {
        model?.key
    }
    
    public func getParentKey() -> String? {
        nil
    }
    
    public func getId() -> String? {
        nil
    }
    
    public func getServiceType() -> ServiceFieldType? {
        model?.getServiceType()
    }
    
    public func getType() -> String? {
        model?.serviceType
    }
    
    public func configure( _ model: PaymentFieldModel) {
        self.model = model
        textField.type = model.type
        
        if let key = model.key {
            textField.field_tag = key
        }
        
        if let topHint = model.topHint {
            textField.topHint = topHint
        }
        
        if let placeholder = model.placeholder {
            textField.placeholder = placeholder
        }
        
        if let savedValue = model.value {
            textField.setValue(string: savedValue)
        }
    }
    
    public func setValue(value: String?) {
        textField.setValue(string: value)
    }
}
