//
//  SubmitAlertView.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 13/10/22.
//

import Combine
import UIKit
public class SubmitAlertView: UIView {
    
    private let container = UIView()
    
    private let contentStack = UIStackView()
    
    private let titleLabel = UILabel()
    
    private let contentLabel = UILabel()
    
    private let buttonsStack = UIStackView()
    
    private let noButton = IButton()
    
    private let yesButton = OlchaButton()
    
    weak var delegate: BaseAlertDelegate?
    
    var observer: (() -> Void)?
    
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
        container.addSubview(contentStack)
        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(contentLabel)
        container.addSubview(buttonsStack)
        buttonsStack.addArrangedSubview(noButton)
        buttonsStack.addArrangedSubview(yesButton)
    }
    
    private func autolayout() {
        
        container.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        contentStack.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.left.right.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
        }
          
        contentLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
        }
        
        buttonsStack.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(contentStack.snp.bottom).inset(-24)
            make.bottom.equalToSuperview().inset(8)
        }
        
        noButton.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        yesButton.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
    }
    
    private func configureViews() {
        
        container.backgroundColor = .white
        container.round()
        
        contentStack.axis = .vertical
        contentStack.spacing = 8
        
        titleLabel.style(.semibold, 24)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .olchaTextBlack
        titleLabel.text = "error".localized()
        
        contentLabel.style(.medium, 16)
        contentLabel.numberOfLines = 0
        contentLabel.textColor = .olchaDarkGray
        
        buttonsStack.spacing = 8
        buttonsStack.axis = .vertical
        buttonsStack.distribution = .fillEqually
        
        noButton.setTitle("no".localized(), for: .normal)
        noButton.titleLabel?.style(.medium, 14)
        noButton.setTitleColor(.olchaTextBlack, for: .normal)
        noButton.clicked { [weak self] in
            guard let self = self else { return }
            self.delegate?.dismiss()
        }
        
        yesButton.setTitle("yes".localized())
        yesButton.settings.clicked { [weak self] in
            guard let self = self else { return }
            self.delegate?.okClicked(dismiss: true)
            self.observer?()
        }
    }
    
    func set(text: String?) {
        titleLabel.text = text
    }
    
    func configure(title: String? = nil,
                   content: String? = nil,
                   yesButtonText: String? = nil,
                   axis: NSLayoutConstraint.Axis = .vertical,
                   noButtonState: Bool = true
    ) {
        contentLabel.isHidden = true
        titleLabel.text = title
        
        if let content = content {
            contentLabel.isHidden = false
            contentLabel.text = content
        }
        
        if let yesButtonText = yesButtonText {
            yesButton.setTitle(yesButtonText)
        }
        
        noButton.isHidden = !noButtonState
        
        buttonsStack.axis = axis
        
    }
}
