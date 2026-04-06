
//
//  AddCardVerifyViewController.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 21/02/23.
//

import UIKit
import OlchaUI
public class AddCardVerifyViewController: BaseViewController<BackNavigationBar> {

    private lazy var scrollView: IScrollView = {
        let scrollView = IScrollView()
        scrollView.container.spacing = 24
        scrollView.container.alignment = .leading
        return scrollView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.style(.regular, 14)
        label.textColor = .olchaTextBlack
        label.text = "code_sent_subtitle".localized()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var retryContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var retryButton: ConfiguredButton = {
        let button = ConfiguredButton()
        button.titleLabel.text = "retry_code".localized()
        button.titleLabel.textColor = .olchaAccentColor
        button.titleLabel.style(.regular, 14)
        return button
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .olchaAccentColor
        label.style(.regular, 14)
        return label
    }()
    
    private lazy var codeField: TField = {
        let field = TField()
        field.topHint = "code".localized()
        field.field_tag = (\VerifyCardOTPRequest.code).propertyName
        return field
    }()
    
    private lazy var nextButton: OlchaButton = {
        let button = OlchaButton()
        button.setTitle("next".localized())
        button.configure(type: .pay)
        return button
    }()
    
    weak var coordinator: AddCardCoordinatorProtocol?
    
    weak var cardModel: CardModel?
    
    let viewModel: CrudCardViewModel
    
    private var timer: Timer?
    
    private var timerSeconds = 0
    
    public override var validatedFields: [TField] {
        [codeField]
    }
    
    public init(viewModel: CrudCardViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setupViews() {
        container.addSubview(scrollView)
        scrollView.addArrangedSubview(titleLabel)
        scrollView.addArrangedSubview(retryContainer)
        retryContainer.addArrangedSubview(retryButton)
        retryContainer.addArrangedSubview(timeLabel)
        scrollView.addArrangedSubview(codeField)
        scrollView.addArrangedSubview(nextButton)
    }
    
    public override func autolayout() {
        scrollView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        retryContainer.snp.makeConstraints { make in
            make.left.equalToSuperview()
        }
        
        retryButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        codeField.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        navigationBar.setTitle("enter_code".localized())
        scrollView.container.setCustomSpacing(8, after: titleLabel)
        checkButtonState()
    }
    
    public override func initialRequest() {
        
        startTimer()
    }
    
    public override func setupObservers() {
        
        codeField.observeText { [weak self] in
            guard let self = self else { return }
            self.cardModel?.code = self.codeField.getText()
            self.checkButtonState()
        }
        
        nextButton.clicked { [weak self] in
            guard let self = self else { return }
            self.verifyOTP()
        }
        
        retryButton.settings.clicked { [weak self] in
            guard let self = self else { return }
            if self.timerSeconds == 0 {
                self.verifyCard()
            }
        }
        
        handle(viewModel.$verifyOTPData,
               success: { [weak self] data in
            guard let self = self else { return }
            self.coordinator?.completed?()
        }, loading: { [weak self] isLoading in
            guard let self = self else { return }
            self.nextButton.settings.requesting = isLoading
        })
        
    }
    
    public func verifyOTP() {
        guard let cardModel = cardModel else {
            return
        }
        
        viewModel.verifyOTP(card: cardModel)
    }

    private func checkButtonState() {
        let isEnabled = codeField.getText() != ""
        isEnabled ? nextButton.enableButton() : nextButton.disableButton()
    }
    
    private func verifyCard() {
        guard let cardModel = cardModel else { return }
        viewModel.getOTP(card: cardModel)
        startTimer()
    }
    
    private func startTimer() {

        timer?.invalidate()
        timer = nil
        
        retryButton.isHidden = true
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
        
        retryButton.isHidden = false
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
        
        timeLabel.text = "code_sent".localized() + " : " + String(format: "%02d:%02d", minutes, seconds)
    }
}
