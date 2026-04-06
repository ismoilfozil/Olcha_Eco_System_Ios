//
//  AdultAlertView.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 18/11/22.
//

import UIKit
import SnapKit


public class AdultAlertView: UIView {
    
    
    private let container = UIView()
    
    private let titleLabel = UILabel()
    
    private let contentLabel = UILabel()
    
    private let buttonsStack = UIStackView()
    
    private let cancelButton = IButton()
    
    private let doneButton = OlchaButton()
    
    weak var delegate: BaseAlertDelegate?
    
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
        addSubview(container)
        container.addSubview(titleLabel)
        container.addSubview(contentLabel)
        container.addSubview(buttonsStack)
        buttonsStack.addArrangedSubview(cancelButton)
        buttonsStack.addArrangedSubview(doneButton)
    }
    
    private func autolayout() {
        
        container.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview().inset(16)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-24)
            make.left.right.equalToSuperview().inset(16)
        }
        
        buttonsStack.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview().inset(16)
            make.top.equalTo(contentLabel.snp.bottom).inset(-32)
        }
    }
    
    private func configureViews() {
        buttonsStack.axis = .horizontal
        buttonsStack.spacing = 8
        buttonsStack.distribution = .fillEqually
        container.backgroundColor = .white
        container.round()
        
        titleLabel.style(.semibold, 24)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .olchaTextBlack
        titleLabel.text = "agree_age".localized()
        
        contentLabel.style(.medium, 14)
        contentLabel.textColor = .olchaTextBlack
        contentLabel.numberOfLines = 0
        contentLabel.text = "agree_age_content".localized()
        
        doneButton.setTitle("yes".localized())
        doneButton.settings.titleLabel?.style(.semibold, 18)
        doneButton.settings.clicked { [weak self] in
            guard let self = self else { return }
            self.delegate?.okClicked(dismiss: true)
        }
        
        cancelButton.setTitle("no".localized(), for: .normal)
        cancelButton.titleLabel?.style(.medium, 18)
        cancelButton.setTitleColor(.olchaTextBlack, for: .normal)
        cancelButton.clicked { [weak self] in
            guard let self = self else { return }
            self.delegate?.dismiss()
        }
        
    }
    
    func set(text: String) {
        contentLabel.text = text
    }
    
}

