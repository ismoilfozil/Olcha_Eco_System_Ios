//
//  VerificationPage1.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 17/09/22.
//

import UIKit
import Combine
import OlchaUI

public protocol PassportsVerificationPageProtocol: AnyObject, UIViewController {
    var withStatus: Bool { get set }
    var coordinator: VerificationCoordinatorProtocol? { get set }
    var completion: (() -> Void)? { get set }
}
public class PassportsVerificationPage: BaseViewController<TitleNavigationBar>, PassportsVerificationPageProtocol {
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.alwaysBounceVertical = true
        scroll.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    private let scrollContainer = UIStackView()
    
    private let status: PercentageVerificationStatus = {
        let view = PercentageVerificationStatus()
        view.setup(statusStep: .identification)
        return view
    }()
    
    private let titleLabel = UILabel()
    
    private let passportBlock = VerificationPhotoView()
    
    private let selfiBlock = VerificationPhotoView()
    
    private let registrationBlock = VerificationPhotoView()
    
    private let continueButton = OlchaButton()
    
    private var passport: DownloadedPassportData?
    
    private var tooltips: [PassportsVerificationPageTooltip] {
        return [
            .passport(in: passportBlock),
            .selfie(in: selfiBlock),
            .registration(in: registrationBlock),
        ]
    }
    
    private let tooltipManager = TooltipManager()
    
    var passportImage: UIImage? {
        didSet {
            passportBlock.loading = true
            if let image = passportImage {
                passportBlock.imageView.image = image
                viewModel.uploadPassportImage(image: image, type: .passport)
            } else {
                if let url = passport?.passport?.absolutePath {
                    passportBlock.imageView.load(from: url, withIndicator: false, imageType: .ignoreResize) { [weak self] in
                        self?.passportBlock.loading = false
                    }
                } else {
                    passportBlock.imageView.image = .passport
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.passportBlock.loading = false
                    }
                }
            }
            checkButtonState()
        }
    }
    
    var selfiImage: UIImage? {
        didSet {
            selfiBlock.loading = true
            if let image = selfiImage {
                selfiBlock.imageView.image = image
                viewModel.uploadPassportImage(image: image, type: .selfi)
            } else {
                if let url = passport?.passport_in_user?.absolutePath {
                    selfiBlock.imageView.load(from: url, withIndicator: false, imageType: .ignoreResize) { [weak self] in
                        self?.selfiBlock.loading = false
                    }
                } else {
                    selfiBlock.imageView.image = .selfi
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.selfiBlock.loading = false
                    }
                }
            }
            checkButtonState()
        }
    }
    
    var registrationImage: UIImage? {
        didSet {
            registrationBlock.loading = true
            if let image = registrationImage {
                registrationBlock.imageView.image = image
                viewModel.uploadPassportImage(image: image, type: .registration)
            } else {
                if let url = passport?.registration?.absolutePath {
                    registrationBlock.imageView.load(from: url, withIndicator: false, imageType: .ignoreResize) { [weak self] in
                        self?.registrationBlock.loading = false
                    }
                } else {
                    registrationBlock.imageView.image = .passport
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.registrationBlock.loading = false
                    }
                }
            }
            checkButtonState()
        }
    }
    
    public weak var coordinator: VerificationCoordinatorProtocol?
    
    private let passportObserver = PassthroughSubject<UIImage?, Never>()
    private let selfiObserver = PassthroughSubject<UIImage?, Never>()
    private let registrationObserver = PassthroughSubject<UIImage?, Never>()
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
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tooltipManager.didViewAppear = true
        guard let topView else { return }
        tooltipManager.setup(tooltips: tooltips, darkView: topView, scrollView: scrollView)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tooltipManager.destroy()
    }
    
    public override func setupViews() {
        container.addSubview(scrollView)
        container.addSubview(continueButton)
        scrollView.addSubview(scrollContainer)
        
        scrollContainer.addArrangedSubview(status)
        scrollContainer.addArrangedSubview(titleLabel)
        scrollContainer.addArrangedSubview(passportBlock)
        scrollContainer.addArrangedSubview(selfiBlock)
        scrollContainer.addArrangedSubview(registrationBlock)
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
        
        continueButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-8)
        }
        
    }
    
    public override func configureViews() {
        

        navigationBar.setTitle("verify_profile".localized(.verification))
        
        scrollContainer.axis = .vertical
        scrollContainer.setCustomSpacing(24, after: status)
        scrollContainer.setCustomSpacing(16, after: titleLabel)
        scrollContainer.setCustomSpacing(16, after: passportBlock)
        scrollContainer.setCustomSpacing(16, after: selfiBlock)
        scrollContainer.setCustomSpacing(24, after: registrationBlock)
        
        
        titleLabel.style(.semibold, 20)
        titleLabel.textColor = .olchaTextBlack
        titleLabel.text = "identification".localized(.verification)
        
        
        passportBlock.titleLabel.text = "passport_front".localized(.verification)
        selfiBlock.titleLabel.text = "selfi_passport".localized(.verification)
        registrationBlock.titleLabel.text = "registration_verification".localized(.verification)
        
        registrationImage = nil
        passportImage = nil
        selfiImage = nil
        
        continueButton.setTitle("confirm".localized())
        checkButtonState()
    }
    
    public override func initialRequest() {
        viewModel.loadPassport()
        viewModel.loadStep()
    }
    
    
    public override func setupObservers() {

        
        passportBlock.galleryButton.settings.clicked { [weak self] in
            guard let self = self else { return }
            self.coordinator?.mediaPicker(type: .image,
                                          sourceType: .photoLibrary,
                                          imageObserver: self.passportObserver,
                                          saveLastPage: false)
            
        }
        
        passportBlock.cameraButton.settings.clicked { [weak self] in
            guard let self = self else { return }
            self.coordinator?.mediaPicker(type: .image,
                                          sourceType: .camera,
                                          imageObserver: self.passportObserver,
                                          saveLastPage: false)
        }
        
        selfiBlock.galleryButton.settings.clicked { [weak self] in
            guard let self = self else { return }
            self.coordinator?.mediaPicker(type: .image,
                                          sourceType: .photoLibrary,
                                          imageObserver: self.selfiObserver,
                                          saveLastPage: false)
        }
        
        selfiBlock.cameraButton.settings.clicked { [weak self] in
            guard let self = self else { return }
            self.coordinator?.mediaPicker(type: .image,
                                          sourceType: .camera,
                                          imageObserver: self.selfiObserver,
                                          saveLastPage: false)
        }
        
        registrationBlock.galleryButton.settings.clicked { [weak self] in
            guard let self = self else { return }
            self.coordinator?.mediaPicker(type: .image,
                                          sourceType: .photoLibrary,
                                          imageObserver: self.registrationObserver,
                                          saveLastPage: false)
        }
        
        registrationBlock.cameraButton.settings.clicked { [weak self] in
            guard let self = self else { return }
            self.coordinator?.mediaPicker(type: .image,
                                          sourceType: .camera,
                                          imageObserver: self.registrationObserver,
                                          saveLastPage: false)
        }
        
        passportObserver.sink { [weak self] image in
            guard let self = self else { return }
            self.passportImage = image
        }.store(in: &bag)
        
        selfiObserver.sink { [weak self] image in
            guard let self = self else { return }
            self.selfiImage = image
        }.store(in: &bag)
        
        registrationObserver.sink { [weak self] image in
            guard let self = self else { return }
            self.registrationImage = image
        }.store(in: &bag)
        
        handle(viewModel.$passportUpload) { [weak self] model in
            guard let self = self,
                  let model = model else { return }
            switch model.type {
            case .passport:
                self.passportBlock.loading = false
                break
            case .selfi:
                self.selfiBlock.loading = false
                break
            case .registration:
                self.registrationBlock.loading = false
                break
            }
            
        } failure: { [weak self] error in
            guard let self = self,
                  let type = error?.0 else { return }
            self.showError(text: error?.1)
            switch type {
            case .passport:
                self.passportImage = nil
                self.passportBlock.loading = false
                break
            case .selfi:
                self.selfiImage = nil
                self.selfiBlock.loading = false
                break
            case .registration:
                self.registrationImage = nil
                self.registrationBlock.loading = false
                break
            }
        }
        
        handle(viewModel.$passport, success: { [weak self] data in
            guard let self = self, let data = data else { return }
            self.passport = data
            if let url = data.passport?.absolutePath {
                self.passportBlock.imageView.load(from: url, withIndicator: false, imageType: .ignoreResize)
            }
            
            if let url = data.passport_in_user?.absolutePath {
                self.selfiBlock.imageView.load(from: url, withIndicator: false, imageType: .ignoreResize)
            }
            
            if let url = data.registration?.absolutePath {
                self.registrationBlock.imageView.load(from: url, withIndicator: false, imageType: .ignoreResize)
            }
            self.checkButtonState()
        })
        
        continueButton.settings.clicked { [weak self] in
            guard let self = self else { return }
            completion?()
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
    
    func checkButtonState() {
        let isEnabled = (passportImage != nil || passport?.passport != nil) &&
        (selfiImage != nil || passport?.passport_in_user != nil) &&
        (registrationImage != nil || passport?.registration != nil)
        isEnabled ? continueButton.enableButton() : continueButton.disableButton()
    }
}
