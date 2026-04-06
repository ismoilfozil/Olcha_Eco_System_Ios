//
//  VerificationPage2.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 14/09/22.
//

import UIKit
import Combine
import OlchaUI
public protocol PhonesVerificationPageProtocol: AnyObject, UIViewController {
    var withStatus: Bool { get set }
    var coordinator: VerificationCoordinatorProtocol? { get set }
    var completion: (() -> Void)? { get set }
}
public class PhonesVerificationPage: BaseViewController<TitleNavigationBar>, PhonesVerificationPageProtocol {

    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.alwaysBounceVertical = true
        return scroll
    }()
    private let scrollContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private let status: PercentageVerificationStatus = {
        let view = PercentageVerificationStatus()
        view.setup(statusStep: .phones)
        return view
    }()
    private let titleLabel = UILabel()
    
    private let phonesContainer = VerificationPhonesView()
    
    private let continueButton = OlchaButton()
    public weak var coordinator: VerificationCoordinatorProtocol?
    
    private let viewModel: VerificationViewModel
    
    public var completion: (() -> Void)?
    
    public var withStatus: Bool = true {
        didSet {
            status.isHidden = !withStatus
        }
    }
    
    public init(viewModel: VerificationViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setupViews() {
        
        container.addSubview(scrollView)
        scrollView.addSubview(scrollContainer)
        scrollContainer.addArrangedSubview(status)
        scrollContainer.addArrangedSubview(titleLabel)
        scrollContainer.addArrangedSubview(phonesContainer)
        scrollContainer.addArrangedSubview(continueButton)
        
    }
    
    public override func autolayout() {
        
        scrollView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
        
        scrollContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(8)
            make.width.equalTo(UIScreen.main.bounds.width - 32)
            make.bottom.lessThanOrEqualToSuperview().inset(16)
        }

        status.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        phonesContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        continueButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
    }
    
    public override func configureViews() {
        
        navigationBar.setTitle("verify_profile".localized(.verification))
        
        titleLabel.style(.semibold, 20)
        titleLabel.textColor = .olchaTextBlack
        titleLabel.text = "phone_numbers".localized(.verification)
        
        
        scrollView.delegate = self
        
        continueButton.setTitle("confirm".localized())
    }
    
    public override func initialRequest() {
        phonesContainer.buttonState()
        viewModel.loadPhones()
        viewModel.loadStep()
    }
    
    public override func setupObservers() {
        
        continueButton.settings.clicked { [weak self] in
            guard let self = self else { return }
            
            self.viewModel.uploadPhones(phones: [
                .init(phone: self.phonesContainer.firstNumberField.getPhone(),
                      main: nil,
                      type: nil),
                
                .init(phone: self.phonesContainer.secondNumberField.getPhone(),
                      main: nil,
                      type: nil),
                
                .init(phone: self.phonesContainer.thirdNumberField.getPhone(),
                      main: nil,
                      type: nil)
                
            ].filter { $0.phone?.count == 12 })
        }
        
        
        handle(viewModel.$uploadPhones, withError: false, success: { [weak self] data in
            guard let self = self, data != nil else { return }
            completion?()
        }, failure: { [weak self] error in
            guard let self = self else { return }
            validateGroupedFields(fields: phonesContainer.fields, error: error)
        }, loading: { [weak self] isLoading in
            guard let self = self else { return }
            self.continueButton.settings.requesting = isLoading
        })
        
        phonesContainer.phonesFillObserver = { [weak self] isEnabled in
            guard let self = self else { return }
            isEnabled ? self.continueButton.enableButton() : self.continueButton.disableButton()
        }
        
        handle(viewModel.$phonesModel, showLoader: true) { [weak self] data in
            guard let self = self else { return }
            self.phonesContainer.fillPhones(data: data ?? [])
            self.phonesContainer.buttonState()
        }
        
        
        handle(viewModel.$step, withError: false) { [weak self] data in
            guard let self = self, let data else { return }
            status.setProgress(data.percentage ?? 0)
        }
        
//        status.stepObserver = { [weak self] step in
//            guard let self = self else { return }
//            self.coordinator?.pushVerification(step: step)
//        }
    }
}
