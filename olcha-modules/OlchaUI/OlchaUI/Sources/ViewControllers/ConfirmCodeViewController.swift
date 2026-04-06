//
//  ConfirmCodeViewController.swift
//  OlchaUI
//
//  Created by Elbek Khasanov on 24/02/23.
//

import Foundation

import UIKit
import Combine
import IQKeyboardManagerSwift
import OlchaUtils


public class ConfirmCodeHelper {
    public init() {}
    
    public let codeConfirmObserver = PassthroughSubject<String, Never>()
    public let sendCodeObserver = PassthroughSubject<Bool, Never>()
    public let dismissObserver = PassthroughSubject<Bool, Never>()
    public let errorObserver = PassthroughSubject<String, Never>()
    public let requestingObserver = PassthroughSubject<Bool, Never>()
}

public protocol ConfirmCodeViewControllerProtocol: BaseModalViewController {
    var authHelper: ConfirmCodeHelper? { get set }
    var acceptButtonTitle: String { get set }
    var resendButtonTitle: NSAttributedString { get set }
    var subtitle: String { get set }
    var phone: String? { get set }
}

public class ConfirmCodeViewController: BaseModalViewController, ConfirmCodeViewControllerProtocol {

    private let otpView = OtpView()
    
    private let phoneTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "+998 (**) *** ** **"
        label.style(.bold, 24)
        label.textColor = .olchaTextBlack
        label.textAlignment = .center
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .olchaTextBlack
        label.style(.medium, 14)
        label.textColor = .olchaDarkNeutralGray
        label.textAlignment = .center

        return label
    }()
    
    private let buttonContainer: UIStackView = {
        let button = UIStackView()
        button.axis = .vertical
        return button
    }()
    
    private let resendButton: IButton = {
        let button = IButton()
        button.titleLabel?.font = .style(.medium, 14)
        
        button.setTitleColor(.olchaBlue, for: .normal)
        
        
        return button
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        
        label.style(.medium, 14)
        label.textColor = .olchaTextBlack
        label.textAlignment = .center
        
        return label
    }()
    
    private let acceptButton: OlchaButton = {
        let button = OlchaButton()
        return button
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 12)
        label.textColor = .olchaAccentColor
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private var timer: Timer?
    
    private var timerSeconds = 0
    
    public weak var authHelper: ConfirmCodeHelper? {
        didSet {
            setupOptionalObservers()
        }
    }
    
    public var acceptButtonTitle: String = "accept".localized() {
        didSet {
            acceptButton.setTitle(acceptButtonTitle)
        }
    }
    
    public var resendButtonTitle: NSAttributedString =  NSAttributedString(string: "resend_code".localized()){
        didSet {
            resendButton.setAttributedTitle(resendButtonTitle,
                                            for: .normal)
        }
    }
    
    public var subtitle: String = "code_subtitle".localized() {
        didSet {
            subtitleLabel.text = subtitle
        }
    }
    
    public var phone: String? = "" {
        didSet {
            if let phone = phone {
                phoneTitleLabel.text = phone.formatFullPhoneNumber
            }
        }
    }
    
    public var timeTitle: String = "code_sent".localized()
    
    public override func setupViews() {
        container.addSubview(phoneTitleLabel)
        container.addSubview(subtitleLabel)
        container.addSubview(otpView)
        container.addSubview(errorLabel)
        container.addSubview(buttonContainer)
        
        buttonContainer.addArrangedSubview(timeLabel)
        buttonContainer.addArrangedSubview(resendButton)
        buttonContainer.addArrangedSubview(acceptButton)
    }
    
    public override func autolayout() {
        phoneTitleLabel.snp.makeConstraints { make in
            make.top.lessThanOrEqualToSuperview().inset(110)
            make.left.right.equalToSuperview().inset(16)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneTitleLabel.snp.bottom).inset(-8)
            make.left.right.equalToSuperview().inset(80)
        }
        
        otpView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(subtitleLabel.snp.bottom).inset(-40)
        }
        
        errorLabel.snp.makeConstraints { make in
            make.left.equalTo(otpView.snp.left)
            make.right.equalTo(otpView.snp.right)
            make.top.equalTo(otpView.snp.bottom).inset(-16)
        }
        
        buttonContainer.snp.remakeConstraints { make in
            make.top.greaterThanOrEqualTo(errorLabel.snp.bottom).inset(-16)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
        }
           
        acceptButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
        }
        
        setContainerHeight()
    }
    
    public override func configureViews() {
        
        buttonContainer.setCustomSpacing(8, after: timeLabel)
        buttonContainer.setCustomSpacing(16, after: resendButton)
        acceptButton.disableButton()
        
        subtitleLabel.text = subtitle
        acceptButton.setTitle(acceptButtonTitle)
        resendButton.setAttributedTitle(resendButtonTitle, for: .normal)
        
    }
    
    
    public override func setupObservers() {
        
        otpView.codeCompleted = { [weak self] code in
            guard let self = self else { return }
            errorState(isHidden: true)
            self.acceptButton.settings.requesting = false
            (code.count == 5) ? self.acceptButton.enableButton() : self.acceptButton.disableButton()
        }
        
        resendButton.clicked { [weak self] in
            guard let self = self else { return }
            if self.timerSeconds == 0 {
                self.sendPhoneCode()
            }
        }
//
        acceptButton.settings.clicked { [weak self] in
            guard let self = self else { return }
            IQKeyboardManager.shared.resignFirstResponder()
            self.authHelper?.codeConfirmObserver.send(self.otpView.getCode())
        }
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        tabBarController?.tabBar.isHidden = true
    
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        tabBarController?.tabBar.isHidden = false
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let height = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else { return }
        
        animateButton(inset: height + 16)
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        animateButton(inset: 16)
    }
    
    private func animateButton(inset: CGFloat) {
        buttonContainer.snp.remakeConstraints { make in
            make.top.greaterThanOrEqualTo(otpView.snp.bottom).inset(-16)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(inset)
        }
            
        UIView.animate(withDuration: 0.4) { [weak self] in
            guard let self else { return }
            view.layoutIfNeeded()
        }
                
    }
    //MARK: - Send phone code
    private func sendPhoneCode() {
        startTimer()
        authHelper?.sendCodeObserver.send(true)
    }
    
    public override func setupOptionalObservers() {
        authHelper?.dismissObserver.sink{ [weak self] canDismiss in
            guard let self = self, canDismiss else { return }
            IQKeyboardManager.shared.resignFirstResponder()
            self.dismiss(animated: true, completion: nil)
        }.store(in: &bag)

        authHelper?.errorObserver.sink{ [weak self] message in
            guard let self = self else { return }
            errorState(isHidden: false, message: message)
            otpView.errorUI()
        }.store(in: &bag)

        authHelper?.requestingObserver.sink { [weak self] isLoading in
            guard let self = self else { return }
            self.acceptButton.settings.requesting = isLoading
        }.store(in: &bag)

        sendPhoneCode()
    }
    
    func errorState(isHidden: Bool, message: String = "") {
        errorLabel.isHidden = isHidden
        errorLabel.text = message
    }
}

//MARK: - Timer
extension ConfirmCodeViewController {
    
    private func startTimer() {
        timer?.invalidate()
        timer = nil
        
        resendButton.isHidden = true
        timeLabel.isHidden = false
        timerSeconds = 60
        countdown()
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(countdown),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    private func stopTimer() {
        resendButton.isHidden = false
        timeLabel.isHidden = true
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func countdown() {
        timerSeconds -= 1
        
        if timerSeconds == 0 {
            stopTimer()
        }
        
        let minutes = (timerSeconds % 3600) / 60
        let seconds = (timerSeconds % 3600) % 60
        
        timeLabel.text = timeTitle + " : " + String(format: "%02d:%02d", minutes, seconds)//"code_sent" = "SMS-код отправлен";
    }
}
