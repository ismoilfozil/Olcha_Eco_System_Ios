//
//  OtpView.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 25/09/22.
//


import UIKit
class OtpView: UIView {
    
    private let container = UIStackView()
    
    var count = 5
    
    private let size: CGFloat = 40.0
    
    private var items: [OtpItem] = []
    
    let textField = UITextField()
    
    private var code: String = "" {
        didSet {
            fillItems()
        }
    }
    
    var codeCompleted: ((String) -> Void)?
    
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
        updateUI()
    }
    
    private func setupViews() {
        addSubview(container)
        addSubview(textField)
    }
    
    private func autolayout() {
        container.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        textField.snp.makeConstraints { make in
            make.edges.equalTo(container)
        }
    }
    
    private func configureViews() {
        container.axis = .horizontal
        container.spacing = 13
        
        textField.addTarget(self, action: #selector(codeUpdated(_:)), for: .allEvents)
        textField.keyboardType = .numberPad
        textField.tintColor = .clear
        textField.textColor = .clear
        textField.textContentType = .oneTimeCode
    }
    
    private func updateUI() {
        items.removeAll()
        container.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for _ in 0..<count {
            let item = OtpItem()
            item.state = .none
            item.snp.makeConstraints { make in
                make.width.height.equalTo(size)
            }
            container.addArrangedSubview(item)
            items.append(item)
        }
    }
    
    @objc private func codeUpdated(_ textField: UITextField) {
        guard (textField.text?.count ?? 0) <= count else {
            textField.text?.removeLast()
            return
        }
        
        code = textField.text ?? ""
        fillItems()
        
        codeCompleted?(code)
        
    }
    
    private func fillItems() {
        let codeCount = code.count
        for i in 0..<items.count {
            if i < items.count {
                if i < codeCount {
                    items[i].state = .deactive(code[i])
                } else if i == codeCount {
                    items[i].state = .active
                } else {
                    items[i].state = .none
                }
            }
        }
    }
    
    func getCode() -> String {
        textField.text ?? ""
    }
}
