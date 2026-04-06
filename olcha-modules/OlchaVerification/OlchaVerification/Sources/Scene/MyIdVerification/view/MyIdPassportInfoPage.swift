//
//  MyIdPassportInfoPage.swift
//  OlchaVerification
//
//  Created by Ismoil Foziljonov on 19/09/25.
//

import UIKit
import Combine
import OlchaUI
import OlchaUtils
import SnapKit
import MyIdSDK


public protocol MyIdPassportInfoPageProtocol: AnyObject, UIViewController {
    var coordinator: VerificationCoordinatorProtocol? { get set }
    var completion: (() -> Void)? { get set }
}

extension MyIdPassportInfoPage: MyIdClientDelegate {
    public func onSuccess(result: MyIdSDK.MyIdResult) {
        viewModel.uploadCode(code: result.code)
    }
    
    public func onError(exception: MyIdSDK.MyIdException) {
        showToast(text: exception.message)
    }
    
    public func onUserExited() {
        
    }
   
}


public class MyIdPassportInfoPage: BaseViewController<TitleNavigationBar>, MyIdPassportInfoPageProtocol {
    
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.alwaysBounceVertical = true
        scroll.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    
    private let scrollContainer = UIStackView()
    
    private let titleLabel = UILabel()
    
    private let passportSeriesTitle = UILabel()
    private let passportSeriesTextField = TField()
    
    private let dobTitleLabel = UILabel()
    
    private let dobStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let dayTextField = TField()
    
    private let monthTextField = TField()
    private let monthButton = MenuButton()
    
    private let yearTextField = TField()
    
    private let continueButton = OlchaButton()
    

    public weak var coordinator: VerificationCoordinatorProtocol?
    private let viewModel: VerificationViewModel
   
    public var completion: (() -> Void)?
    
    public init(viewModel: VerificationViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkButtonState()
    }
    
    public override func setupViews() {
        container.addSubview(scrollView)
        container.addSubview(continueButton)
        scrollView.addSubview(scrollContainer)
        
        scrollContainer.addArrangedSubview(titleLabel)
        scrollContainer.addArrangedSubview(passportSeriesTitle)
        scrollContainer.addArrangedSubview(passportSeriesTextField)
        scrollContainer.addArrangedSubview(dobTitleLabel)
        scrollContainer.addArrangedSubview(dobStackView)
        
        dobStackView.addArrangedSubview(dayTextField)
        dobStackView.addArrangedSubview(monthTextField)
        dobStackView.addArrangedSubview(yearTextField)
        
        container.addSubview(monthButton)
    }
    
    public override func autolayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(8)
            make.width.equalTo(UIScreen.main.bounds.width - 32)
            make.bottom.lessThanOrEqualToSuperview().inset(16)
        }
        
        passportSeriesTextField.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        dobStackView.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        continueButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-8)
        }
        
        monthButton.snp.makeConstraints { make in
            make.top.right.left.equalTo(monthTextField)
        }
        
        container.layoutIfNeeded()
        monthButton.height = monthTextField.bounds.height
    }
    
    public override func configureViews() {
        scrollContainer.axis = .vertical
        scrollContainer.setCustomSpacing(16, after: titleLabel)
        scrollContainer.setCustomSpacing(4, after: passportSeriesTitle)
        scrollContainer.setCustomSpacing(16, after: passportSeriesTextField)
        scrollContainer.setCustomSpacing(4, after: dobTitleLabel)
        
        titleLabel.style(.semibold, 20)
        titleLabel.textColor = .olchaTextBlack
        titleLabel.text = "enter_your_passport_data".localized()
        
        passportSeriesTitle.style(.regular, 14)
        passportSeriesTitle.text = "passport_series_or_number".localized()
        
        dobTitleLabel.style(.regular, 14)
        dobTitleLabel.text = "birthday".localized()
        
        
        passportSeriesTextField.placeholder = "AA 1234567"
        
        
        dayTextField.placeholder = "day".localized()
        dayTextField.type = .number
        
        monthTextField.placeholder = "month".localized()
        monthTextField.rightImage = .down_anchor_black
        
        yearTextField.placeholder = "year".localized()
        yearTextField.type = .number
        
        
        continueButton.setTitle("confirm".localized())
        checkButtonState()
    
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: String.getAppLocaleIdentifier())
        monthButton.items = formatter.monthSymbols
    }
    
    
    public override func initialRequest() {
        
    }
    
    public override func setupObservers() {
        [passportSeriesTextField, dayTextField, monthTextField, yearTextField].forEach { field in
            NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: field.settings)
                .map { _ in }
                .sink { [weak self] _ in self?.checkButtonState() }
                .store(in: &bag)
        }
        
        dayTextField.settings.addTarget(self, action: #selector(limitDayLength(_:)), for: .editingChanged)
        yearTextField.settings.addTarget(self, action: #selector(limitYearLength(_:)), for: .editingChanged)
        
        continueButton.settings.clicked { [weak self] in
            guard let self = self else { return }
//            let passportSeries = self.passportSeriesTextField.getText()
//            viewModel.checkExist(passport: passportSeries)
            startMyIdFlow()
        }
        
        monthButton
            .settings
            .clicked { [weak self] in
                guard let self = self else { return }
                self.monthButton.openMenu = !self.monthButton.openMenu
            }

        monthButton.selectedIndex = { [weak self] index in
            guard let self = self else { return }
            let monthNumber = index + 1
            self.monthTextField.settings.text = String(format: "%02d", monthNumber)
            self.monthButton.openMenu = false
            self.checkButtonState()
            
        }
        
        handle(viewModel.$checkExist,
               success: { [weak self] data in
                   guard let self = self, let data = data else { return }
                  startMyIdFlow()
               },
               failure: { error in
                    
               },
               loading: { isLoading in
                   
               })
        
        handle(viewModel.$uploadCode,
               success: { [weak self] data in
                   guard let self = self, let data = data else { return }
                   completion?()
               },
               failure: { error in
                    
               },
               loading: { isLoading in
                   
               })

       
    }
    
    private func checkButtonState() {
        let isEnabled = !(passportSeriesTextField.getText().isEmpty ) &&
        !(dayTextField.getText().isEmpty ) &&
                        !(monthTextField.getText().isEmpty ) &&
                        !(yearTextField.getText().isEmpty)
        
        isEnabled ? continueButton.enableButton() : continueButton.disableButton()
    }
    
    private func startMyIdFlow() {
        let passportData = passportSeriesTextField.getText()
        let day = dayTextField.getText()
        let month = monthTextField.getText()
        let year = yearTextField.getText()
        let dateOfBirth = "\(day).\(month).\(year)"
        
        let config = MyIdConfig()
    
        config.clientId = MyIdKeys.prodClientId
        config.clientHash = MyIdKeys.prodClientHash
        config.clientHashId = MyIdKeys.prodClientHashId
        config.environment = .production
        config.passportData = passportData
        config.dateOfBirth = dateOfBirth
        config.entryType = .identification
        config.locale = mapAppLanguageToMyIdLocale()
        config.cameraShape = .circle
        config.presentationStyle = .sheet
        
        MyIdClient.start(withConfig: config, withDelegate: self)
    }
    
    private func mapAppLanguageToMyIdLocale() -> MyIdLocale {
        switch String.getAppLanguage() {
        case "oz":
            return .uzbek
        case "ru":
            return .russian
        default:
            return .uzbek
        }
    }
    
   
    
    @objc private func limitDayLength(_ textField: UITextField) {
        let digits = textField.text?.filter { $0.isNumber } ?? ""
        let limited = String(digits.prefix(2))
        if textField.text != limited { textField.text = limited }
        checkButtonState()
    }
    
    @objc private func limitYearLength(_ textField: UITextField) {
        let digits = textField.text?.filter { $0.isNumber } ?? ""
        let limited = String(digits.prefix(4))
        if textField.text != limited { textField.text = limited }
        checkButtonState()
    }
}
