//
//  PaymentDropDownView.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 20/02/23.
//
import IQKeyboardManagerSwift
import UIKit
import DropDown
import OlchaUI

public class PaymentDropDownView: BaseView, PaymentFieldProtocol {
   
    private var items: [PaymentDropDownModel] = []
    
    public var actionObserver: ((String?) -> Void)?

    public var valueUpdatedObserver: ((String?) -> Void)?
    
    public var isValidated: Bool {
        selectedItem != nil
    }
    
    private lazy var textField: TField = {
        let textField = TField()
        textField.type = .default
        return textField
    }()
    
    private lazy var button: IButton = {
        let button = IButton()
        return button
    }()
    
    private let dropDown = DropDown()
    
    private var selectedItem: PaymentDropDownModel?
    
    private var model: PaymentSelectModel?
    
    public override func setupViews() {
        
        addSubview(textField)
        addSubview(button)
        
    }
    
    public override func autolayout() {
        
        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        button.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(textField.settings.snp.top)
            make.bottom.equalTo(textField.settings.snp.bottom)
        }
    }
    
    public override func configureViews() {
        
        button.clicked { [weak self] in
            guard let self = self else { return }
            self.dropDown.show()
        }
        
        dropDown.selectionAction = { [weak self] (index, title) in
            guard let self = self else { return }
            selectValue(index: index)
            updateValue(index: index)
        }
    }
    
    public var field: TField {
        textField
    }
    
    public func getValue() -> String? {
        guard let selectedItem = selectedItem else {
            return nil
        }
        return selectedItem.alias
    }
    
    public func getKey() -> String? {
        model?.key
    }
    
    public func getParentKey() -> String? {
        model?.parentID
    }
    
    public func getServiceType() -> ServiceFieldType? {
        model?.getServiceType()
    }
    
    public func getType() -> String? {
        model?.serviceType
    }
    
    public func getId() -> String? {
        model?.id
    }
    
    public func configure(_ model: PaymentSelectModel) {
        self.model = model
        items = model.items?.compactMap {
            ExampleDropDownModel(alias: $0.id?.string, title: String.lang($0.title_ru, $0.title_uz, $0.title_uz))
        } ?? []
        
        dropDown.configure(button,
                           items.map { $0.title ?? "" })
        
        if let key = model.key {
            textField.field_tag = key
        }
        
        if let topHint = model.topHint {
            textField.topHint = topHint
        }
        if let value = model.value {
            selectValue(value: value)
        }
    }
    
    public func setValue(value: String?) {
        selectValue(value: value)
    }

}

fileprivate extension PaymentDropDownView {
    func selectValue(value: String?) {
        selectValue(index: items.firstIndex(where: { $0.alias == value }))
    }
    
    func selectValue(index: Int?) {
        guard let index, items.isGreater(index) else {
            selectedItem = nil
            dropDown.selectRows(at: nil)
            textField.text = nil
            return
        }
        selectedItem = items[index]
        dropDown.selectRows(at: Set([index]))
        textField.text = items[index].title
    }
    
    func updateValue(index: Int?) {
        guard let index, items.isGreater(index) else {
//            valueUpdatedObserver?(nil)
//            actionObserver?(nil)
            return
        }
        valueUpdatedObserver?(items[index].alias)
        actionObserver?(items[index].alias)
    }
}
