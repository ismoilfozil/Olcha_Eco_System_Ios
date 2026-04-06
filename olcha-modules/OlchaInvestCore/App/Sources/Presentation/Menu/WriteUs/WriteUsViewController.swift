//
//  WriteUsViewController.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 05/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI
import OlchaCommon
import OlchaUtils

public class WriteUsViewController: BaseViewController<TitleNavigationBar> {
    
    private let messageTextView: InvestTextView = {
        let textView = InvestTextView()
        textView.border(with: .olchaLightNeutralDarkGray, width: 2)
        textView.round()
        textView.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        textView.font = .style(.regular, 14)
        return textView
    }()
    
    private let sendButton: InvestOlchaButton = {
        let button = InvestOlchaButton()
        button.setButtonEnabled(false)
        button.settings.setTitleColor(.olchaBlackNeutral, for: .disabled)
        button.settings.setTitleColor(.lightGrayBackground, for: .normal)
        button.settings.titleLabel?.font = .style(.semibold, 16)
        button.round(10)
        return button
    }()
    
    private lazy var keyboardManager = KeyboardManager()
    
    public let viewModel: CommonViewModel
    
    public init(viewModel: CommonViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        keyboardManager.startObservingKeyboard()
        keyboardManager.keyboardWillShowObserver = keyboardWillShowObserver
        keyboardManager.keyboardWillHideObserver = keyboardWillHideObserver
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        keyboardManager.stopObservingKeyboard()
    }
    
    private func keyboardWillShowObserver(height: CGFloat, timeInterval: TimeInterval) {
        sendButton.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalTo(self.view.snp.bottom).inset(height + 12)
        }
        UIView.animate(withDuration: timeInterval) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func keyboardWillHideObserver() {
        sendButton.snp.remakeConstraints { make in
            make.bottom.equalToSuperview().inset(12)
            make.left.right.equalToSuperview().inset(16)
        }
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }
    
    public override func setupViews() {
        container.addSubview(messageTextView)
        container.addSubview(sendButton)
    }
    
    public override func autolayout() {
        messageTextView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(120)
        }
        sendButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(12)
            make.left.right.equalToSuperview().inset(16)
        }
    }
    
    public override func configureViews() {
        languageUpdated()
    }
    
    public override func languageUpdated() {
        navigationBar.setTitle("write_us_heading".localized(.olchaInvestCore))
        sendButton.setTitle("write_us_button".localized(.olchaInvestCore))
        messageTextView.placeholder = "write_us_message_placeholder".localized(.olchaInvestCore)
    }
    
    public override func setupObservers() {
        messageTextView.$isInsertedText
            .sink { [weak self] isInserted in
                guard let self else { return }
                sendButton.setButtonEnabled(isInserted)
            }.store(in: &bag)
        sendButton.clicked { [weak self] in
            guard let self else { return }
            viewModel.storeFeedback(model: FeedbackModel(question: messageTextView.text))
        }
        handle(viewModel.$feedback, showLoader: true, success: { [weak self] data in
            guard let self = self, data != nil else { return }
            navigationController?.popViewController(animated: true)
        })
    }
    
}
