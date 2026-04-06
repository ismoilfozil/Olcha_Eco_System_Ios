//
//  PaymentViewController+UI.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 10/04/23.
//

import UIKit
import OlchaUI
import OlchaUtils
public extension PaymentViewController {
    func createFields() {
        isFieldsGenerated = false
        scrollView.container.arrangedSubviews.forEach { $0.removeFromSuperview() }
        fields.removeAll()
        scrollView.container.addArrangedSubview(cardSelectView)
        
        for type in fieldTypes {
            let fieldTypeView: (BaseView & PaymentFieldProtocol)
            switch type {
            case .input(let model):
                let fieldView = PaymentInputView()
                fieldView.configure(model)
                
                fieldTypeView = fieldView
                break
            case .select(let model):
                let selectView = PaymentDropDownView()
                selectView.configure(model)
                
                fieldTypeView = selectView
                break
            }
            
            scrollView.addArrangedSubview(fieldTypeView)
            fields.append(fieldTypeView)
        }
        isFieldsGenerated = true
        fieldObservers()
        checkButtonState()
    }
    
    func getArrayList() -> [PaymentType] {
        let serviceFields = paymentHelper.service?.services_field ?? []
        var newFields: [PaymentType] = []
        for serviceField in serviceFields {
            newFields.append(createPaymentType(serviceField: serviceField))
        }
        return newFields
    }
    
    func createPaymentType(serviceField: ServiceFieldModel) -> PaymentType {
        let savedValue = paymentHelper.getFilledValue(key: serviceField.name)
        
        switch serviceField.getType() {
        case .money:
            return .input(.init(key: serviceField.name,
                                type: .amountRanged(range: (min: paymentHelper.service?.min_amount,
                                                            max: paymentHelper.service?.max_amount)),
                                topHint: serviceField.getTitle(),
                                placeholder: "5 000",
                                serviceType: serviceField.type,
                                value: savedValue)
            )
        case .phone:
            return .input(.init(key: serviceField.name,
                                type: .shortPhone,
                                topHint: serviceField.getTitle(),
                                placeholder: .phonePlaceholder,
                                serviceType: serviceField.type,
                                value: savedValue)
            )
        case .number:
            return .input(.init(key: serviceField.name,
                                type: .number,
                                topHint: serviceField.getTitle(),
                                placeholder: serviceField.getPlaceholder(),
                                serviceType: serviceField.type,
                                value: savedValue)
            )
        case .regexbox:
            return .input(.init(key: serviceField.name,
                                type: .regex(pattern: serviceField.field_control),
                                topHint: serviceField.getTitle(),
                                placeholder: serviceField.getPlaceholder(),
                                serviceType: serviceField.type,
                                value: savedValue)
            )
        case .combobox:
            let menuItems = getMenuItems(model: serviceField,
                                         selectedValue: savedValue)
            return .select(.init(key: serviceField.name,
                                 type: .default,
                                 topHint: serviceField.getTitle(),
                                 items: menuItems,
                                 parentID: serviceField.parent_field?.string,
                                 serviceType: serviceField.type,
                                 id: serviceField.id?.string,
                                 value: savedValue))
        default: 
            return .input(.init(key: serviceField.name,
                                type: .required,
                                topHint: serviceField.getTitle(),
                                placeholder: serviceField.getPlaceholder(),
                                serviceType: serviceField.type,
                                value: savedValue)
            )
        }
    }
    
    func checkButtonState() {
        guard isFieldsGenerated else { return }
        let isEnabled = fields.allSatisfy { $0.isValidated == true } && (paymentHelper.selectedCard != nil)
        isEnabled ? acceptButton.enableButton() : acceptButton.disableButton()
    }
    
    func checkValues() {
        
        for i in 0..<min(fields.count, fieldTypes.count) {
            let field = fields[i]
            let fieldType = fieldTypes[i]
            
            switch fieldType {
            case .select(let model):
                (field as? PaymentDropDownView)?.configure(model)
            case .input(let model):
                (field as? PaymentInputView)?.configure(model)
            }
            
        }
        
    }
    
    func viewObservers() {
        acceptButton.clicked { [weak self] in
            guard let self = self else { return }
            self.makeTransaction()
        }
        
        cardSelectView.button.clicked { [weak self] in
            guard let self = self else { return }
            self.coordinator?.presentMyBankCards(makePaymentHelper: self.paymentHelper)
        }
    }
    
    func fieldObservers() {
        for i in 0..<min(fields.count, fieldTypes.count) {
            let field = fields[i]
            
            field.actionObserver = { [weak self] text in
                guard let self = self else { return }
                self.checkButtonState()
            }
            
            field.valueUpdatedObserver = { [weak self] value in
                guard let self else { return }
                paymentHelper.filledFields.first(where: { $0.key == field.getKey() })?.value = value
                clear(field.getId())
                checkValues()
            }
        }
    }
    
    func clear(_ id: String?) {
        let children = fields.filter({ $0.getParentKey() == id })
        for child in children {
            clear(child.getId())
            var childField = paymentHelper.filledFields.first(where: { $0.key == child.getKey() })
            childField?.value = nil
            child.setValue(value: nil)
        }
        
    }
    
    func setupAmountRules() {
        guard let amountField = fields.first(where: { $0.getServiceType() == .money })?.field else { return }
        
        amountField.type = .amountRanged(range: (min: paymentHelper.service?.min_amount,
                                                 max: paymentHelper.service?.max_amount))
        
        amountField.append(rule: TextFieldRules.shared.maxCashRule(max: paymentHelper.getSelectedCardAmount()))
    }
}

fileprivate extension PaymentViewController {
    func getMenuItems(model: ServiceFieldModel, selectedValue: String?) -> [ServiceFieldValue] {
        let parentSelectedValue = getParentSelectedValue(model: model)
        return paymentHelper.service?.getValue(id: model.id,
                                               parentID: model.parent_field,
                                               selectedID: selectedValue,
                                               parentSelectedValue: parentSelectedValue) ?? []
    }
    
    func getParentSelectedValue(model: ServiceFieldModel) -> String? {
        guard let parentID = model.parent_field else { return nil }
        guard let parentKey = paymentHelper.service?.services_field?.first(where: { $0.id == parentID })?.name else { return nil }
        return fields.first { $0.getKey() == parentKey }?.getValue()
    }
}

//func callParent(parentId)
// combobox = dist[parent_id]
//for(combobox){
//    combobox.clear
//    callParent(combobox.id)
//}
//
//<combobox data-parent-id=parent_key data-id=id>
//
//callParent(1)
