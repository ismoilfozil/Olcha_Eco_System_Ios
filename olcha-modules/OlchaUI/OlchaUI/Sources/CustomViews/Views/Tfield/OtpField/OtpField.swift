//
//  OtpField.swift
//  OlchaUI
//
//  Created by Elbek Khasanov on 05/07/23.
//

import UIKit
public class OtpField: TField {
    
    private var timer: Timer?
    private var timerSeconds = 0
    
    private var sendCodeObserver: (() -> Void)?
    
    public let timeLabel: UILabel = {
        let label = UILabel()
        label.style(.regular, 12)
        label.textColor = .olchaTextBlack
        label.textAlignment = .right
        return label
    }()
    
    public let sendButton: IButton = {
        let button = IButton()
        button.setTitleColor(.olchaAccentColor, for: .normal)
        button.titleLabel?.style(.regular, 13)
        button.setTitle("resend_code".localized(), for: .normal)
        return button
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        baseSetup()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func baseSetup() {
        setupViews()
        autolayout()
        configureViews()
    }
    
    private func setupViews() {
        addSubview(timeLabel)
        addSubview(sendButton)
    }
    
    private func autolayout() {
        container.snp.remakeConstraints { make in
            make.left.top.right.equalToSuperview()
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(container.snp.bottom).inset(-4)
            make.left.equalTo(container.snp.left)
            make.bottom.equalToSuperview()
        }
        
        sendButton.snp.makeConstraints { make in
            make.top.equalTo(container.snp.bottom)
            make.right.equalTo(container.snp.right)
            make.bottom.equalToSuperview()
        }
    }
    
    private func configureViews() {
        sendButton.clicked { [weak self] in
            guard let self = self else { return }
            if self.timerSeconds == 0 {
                self.sendCodeObserver?()
            }
        }
    }
    
    public func sendPhoneCode(_ observer: (() -> Void)?) {
        self.sendCodeObserver = observer
    }
    
    @objc public func countdown() {
        timerSeconds -= 1
        
        if timerSeconds == 0 {
            buttonResend()
        }
        
        let minutes = (timerSeconds % 3600) / 60
        let seconds = (timerSeconds % 3600) % 60
        
        timeLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }
    
    public func buttonResend() {
        stopTimer()
    }
    
    public func stopTimer() {
        sendButton.isHidden = false
        timeLabel.isHidden = true
        timer?.invalidate()
        timer = nil
    }
    
    public func startTimer() {
        codeOpened()
        timer?.invalidate()
        timer = nil
        
        sendButton.isHidden = true
        timeLabel.isHidden = false
        timerSeconds = 60
        countdown()
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(countdown),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    deinit {
        MainActor.assumeIsolated {
            timer?.invalidate()
            timer = nil
        }
    }
    
    public func finishTiming() {
        stopTimer()
        codeClosed()
    }
    
    private func codeOpened() {
        isHidden = false
    }
    
    private func codeClosed() {
        isHidden = true
    }
}
