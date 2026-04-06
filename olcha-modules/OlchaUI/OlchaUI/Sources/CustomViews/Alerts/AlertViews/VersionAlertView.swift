//
//  VersionAlertView.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 22/12/22.
//

import UIKit
import OlchaUtils
public class VersionAlertView: UIView {
    
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
        buttonsStack.axis = .vertical
        buttonsStack.spacing = 8
        buttonsStack.distribution = .fillEqually
        container.backgroundColor = .white
        container.round()
        
        titleLabel.style(.semibold, 24)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .olchaTextBlack
        titleLabel.text = "new_update".localized()
        
        contentLabel.style(.medium, 14)
        contentLabel.textColor = .olchaTextBlack
        contentLabel.numberOfLines = 0
        contentLabel.text = "new_update_content".localized()
        
        doneButton.setTitle("update".localized())
        doneButton.settings.titleLabel?.style(.semibold, 18)
        doneButton.settings.clicked { [weak self] in
            guard let self = self else { return }
            self.delegate?.okClicked(dismiss: false)
        }
        
        cancelButton.setTitle("cancel".localized(), for: .normal)
        cancelButton.titleLabel?.style(.medium, 18)
        cancelButton.setTitleColor(.olchaTextBlack, for: .normal)
        cancelButton.clicked { [weak self] in
            guard let self = self else { return }
            self.delegate?.dismiss()
        }
        
    }
    
    public func set(state: VersionState) {
        switch state {
        case .forced:
            cancelButton.isHidden = true
        case .optional:
            cancelButton.isHidden = false
        default: break
            
        }
    }

}
