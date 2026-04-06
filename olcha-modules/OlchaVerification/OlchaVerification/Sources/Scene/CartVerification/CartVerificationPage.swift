//
//  CartVerificationPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 11/10/22.
//

import UIKit
import Combine
import OlchaUI
import OlchaBankCards
import OlchaAuth
public protocol CartVerificationPageProtocol: UIViewController {
    var coordinator: VerificationCoordinatorProtocol? { get set }
    var verificationFinished: (() -> Void)? { get set }
}
public class CartVerificationPage: BaseModalViewController, CartVerificationPageProtocol {
    
    private let scrollView = UIScrollView()
    private let scrollContainer = UIStackView()
    
    
    private let titleLabel = UILabel()
    
    private let passportBlock = VerificationPhotoView()
    
    private let selfiBlock = VerificationPhotoView()
    
    private let registrationBlock = VerificationPhotoView()
    
    private var passport: DownloadedPassportData?
    
    var passportImage: UIImage? {
        didSet {
            if let image = passportImage {
                passportBlock.imageView.image = image
                passportBlock.loading = true
                verificationViewModel.uploadPassportImage(image: image, type: .passport)
            } else {
                if let url = passport?.passport?.absolutePath {
                    passportBlock.imageView.load(from: url, imageType: .ignoreResize)
                } else {
                    passportBlock.imageView.image = .passport
                }
            }
            checkButtonState(isObserving: false)
        }
    }
    
    var selfiImage: UIImage? {
        didSet {
            if let image = selfiImage {
                selfiBlock.imageView.image = image
                selfiBlock.loading = true
                verificationViewModel.uploadPassportImage(image: image, type: .selfi)
            } else {
                if let url = passport?.passport_in_user?.absolutePath {
                    selfiBlock.imageView.load(from: url, imageType: .ignoreResize)
                } else {
                    selfiBlock.imageView.image = .selfi
                }
            }
            checkButtonState(isObserving: false)
        }
    }
    
    var registrationImage: UIImage? {
        didSet {
            if let image = registrationImage {
                registrationBlock.imageView.image = image
                registrationBlock.loading = true
                verificationViewModel.uploadPassportImage(image: image, type: .registration)
            } else {
                if let url = passport?.registration?.absolutePath {
                    registrationBlock.imageView.load(from: url, imageType: .ignoreResize)
                } else {
                    registrationBlock.imageView.image = .passport
                }
            }
            checkButtonState(isObserving: false)
        }
    }

    
    weak public var coordinator: VerificationCoordinatorProtocol?
    
    private let passportObserver = PassthroughSubject<UIImage?, Never>()
    private let selfiObserver = PassthroughSubject<UIImage?, Never>()
    private let registrationObserver = PassthroughSubject<UIImage?, Never>()
    private let bankCardViewModel: BankCardViewModel
    private let verificationViewModel: VerificationViewModel
    /*
    -----------NUMBERS
    */
    private let phonesContainer = VerificationPhonesView()
     /*
     -----------CARDS
     */
    var isLoaded = false
    private let cardFill = CardFillView()
    let cardsTable = BaseTableView()
    
    
    var openedMenuID: Int?
    
    let observers = CardFillObservers()
    let loadCards = PassthroughSubject<Bool, Never>()
    
    var cards: [BankCard] = [] {
        didSet {
            if cards.isEmpty {
                cardFill.isHidden = false
                cardsTable.isHidden = true
                
            } else {
                cardFill.discard()
                cardFill.isHidden = true
                cardsTable.isHidden = false
                
            }
            cardsTable.reloadData()
            checkButtonState(isObserving: false)
        }
    }
    
    public var verificationFinished: (() -> Void)?
    
    public init(bankCardViewModel: BankCardViewModel,
                 verificationViewModel: VerificationViewModel) {
        self.verificationViewModel = verificationViewModel
        self.bankCardViewModel = bankCardViewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setupViews() {
        
        container.addSubview(scrollView)
        scrollView.addSubview(scrollContainer)
        
        
        scrollContainer.addArrangedSubview(titleLabel)
        scrollContainer.addArrangedSubview(passportBlock)
        scrollContainer.addArrangedSubview(selfiBlock)
        scrollContainer.addArrangedSubview(registrationBlock)
        scrollContainer.addArrangedSubview(phonesContainer)
        
        scrollContainer.addArrangedSubview(cardFill)
        scrollContainer.addArrangedSubview(cardsTable)
        
    }
    
    public override func autolayout() {
        
        scrollView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        scrollContainer.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.right.left.equalToSuperview().inset(16)
            make.width.equalTo(UIScreen.width - 32)
            make.height.equalTo(container.snp.height).priority(.low)
            make.bottom.equalToSuperview()
        }
        
        
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        passportBlock.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        selfiBlock.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        registrationBlock.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        phonesContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        cardFill.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        cardsTable.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
    }
    
    public override func configureViews() {
        dismissConfiguration()
        setHeader(title: "checkout_installment".localized(.verification))
        
        scrollContainer.axis = .vertical
        scrollContainer.setCustomSpacing(16, after: titleLabel)
        scrollContainer.setCustomSpacing(16, after: passportBlock)
        scrollContainer.setCustomSpacing(24, after: selfiBlock)
        scrollContainer.spacing = 16
        
        
        titleLabel.style(.semibold, 24)
        titleLabel.textColor = .olchaTextBlack
        titleLabel.text = "identification".localized(.verification)
        
        
        passportBlock.titleLabel.text = "passport_front".localized(.verification)
        selfiBlock.titleLabel.text = "selfi_passport".localized(.verification)
        registrationBlock.titleLabel.text = "registration_verification".localized(.verification)
        
        passportImage = nil
        selfiImage = nil
        registrationImage = nil
        
        checkButtonState(isObserving: true)
        
        cardsTable.delegate = self
        cardsTable.dataSource = self
        cardsTable.configure()
        cardsTable.registerClass(forCell: BankCardRoom.self)
        cardsTable.registerClass(forCell: CardFillRoom.self)
        cardsTable.isScrollEnabled = false
        
        scrollView.delegate = self
        
        cardFill.observers = observers
        phonesContainer.isHidden = false
        
        cardFill.isHidden = true
        cardsTable.isHidden = true
        
    }
    
    public override func initialRequest() {
        verificationViewModel.loadPassport()
        verificationViewModel.loadPhones()
        loadCards.send(true)
    }
    
    
    public override func setupObservers() {
        
        passportBlock.galleryButton.settings.clicked { [weak self] in
            guard let self = self else { return }
            self.coordinator?.mediaPicker(type: .image,
                                          sourceType: .photoLibrary,
                                          imageObserver: self.passportObserver,
                                          saveLastPage: true)
        }
        
        passportBlock.cameraButton.settings.clicked { [weak self] in
            guard let self = self else { return }
            self.coordinator?.mediaPicker(type: .image,
                                          sourceType: .camera,
                                          imageObserver: self.passportObserver,
                                          saveLastPage: true)
        }
        
        selfiBlock.galleryButton.settings.clicked { [weak self] in
            guard let self = self else { return }
            self.coordinator?.mediaPicker(type: .image,
                                          sourceType: .photoLibrary,
                                          imageObserver: self.selfiObserver,
                                          saveLastPage: true)
        }
        
        selfiBlock.cameraButton.settings.clicked { [weak self] in
            guard let self = self else { return }
            self.coordinator?.mediaPicker(type: .image,
                                          sourceType: .camera,
                                          imageObserver: self.selfiObserver,
                                          saveLastPage: true)
        }
        
        registrationBlock.galleryButton.settings.clicked { [weak self] in
            guard let self = self else { return }
            self.coordinator?.mediaPicker(type: .image,
                                          sourceType: .photoLibrary,
                                          imageObserver: self.registrationObserver,
                                          saveLastPage: true)
        }
        
        registrationBlock.cameraButton.settings.clicked { [weak self] in
            guard let self = self else { return }
            self.coordinator?.mediaPicker(type: .image,
                                          sourceType: .camera,
                                          imageObserver: self.registrationObserver,
                                          saveLastPage: true)
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
        
        handle(verificationViewModel.$phonesModel,
               showLoader: true,
               success: { [weak self] data in
            guard let self = self else { return }
            self.phonesContainer.fillPhones(data: data ?? [])
            self.phonesContainer.buttonState()
        })
        
        handle(verificationViewModel.$uploadPhones, showLoader: true, success: { [weak self] data in
            guard let self = self, data != nil else { return }
            self.checkButtonState(isObserving: false)
        })
        
        phonesContainer.phonesFillObserver = { [weak self] isEnabled in
            guard let self = self, isEnabled else { return }
            
            self.verificationViewModel.uploadPhones(phones: [
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
        
        handle(verificationViewModel.$passportUpload) { [weak self] model in
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
        
        handle(verificationViewModel.$passport, success: { [weak self] data in
            guard let self = self, let data = data else { return }
            self.passport = data
            if let url = data.passport?.absolutePath {
                self.passportBlock.imageView.load(from: url, imageType: .ignoreResize)
            }
            
            if let url = data.passport_in_user?.absolutePath {
                self.selfiBlock.imageView.load(from: url, imageType: .ignoreResize)
            }
            
            if let url = data.registration?.absolutePath {
                self.registrationBlock.imageView.load(from: url, imageType: .ignoreResize)
            }
            self.checkButtonState(isObserving: false)
        })
        
        loadCards.sink { [weak self] canLoad in
            guard let self = self else { return }
            self.bankCardViewModel.loadBankCards()
        }.store(in: &bag)
        
        
        handle(bankCardViewModel.$cardUploaded, showLoader: true) { [weak self] data in
            guard let self = self, data != nil else { return }
            self.loadCards.send(true)
        } failure: { [weak self] error in
            guard let self = self else { return }
            self.observers.requestFinished.send(true)
        }
        
        handle(bankCardViewModel.$bankCard) { [weak self] data in
            guard let self = self,
                  let card = data else { return }
            self.observers.requestFinished.send(true)
            self.cards = [card]
        } failure: { [weak self] error in
            guard let self = self else { return }
            self.observers.requestFinished.send(true)
        }
        
        bankCardViewModel
            .$codeSent
            .sink { [weak self] isSent in
                guard let self = self, isSent else { return }
                self.observers.requestFinished.send(true)
                self.observers.codeSentObserver.send(true)
            }.store(in: &bag)
        
        observers.sendCodeObserver
            .sink { [weak self] model in
                guard let self = self else { return }
                self.bankCardViewModel.verifyBankCardPhone(model: model)
            }.store(in: &bag)
        
        observers.sendCardObserver
            .sink { [weak self] model in
                guard let self = self else { return }
                self.bankCardViewModel.uploadBankCard(model: model)
            }.store(in: &bag)
        
        handle(bankCardViewModel.$cards, showLoader: true, success: { [weak self] data in
            guard let self = self else { return }
            self.isLoaded = true
            self.cards = data ?? []
        })
        
        handle(bankCardViewModel.$removeCard,
               withError: true,
               loading: { [weak self] isLoading in
            guard let self else { return }
            isLoading ? showPostProgress() : hidePostProgress()
        })
        
        bankCardViewModel.creditVerificationObserver = {
            OlchaVerificationDIContainer.shared.authCreditViewModel().verifyCredit()
        }
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        self.view.addGestureRecognizer(tap)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = cardsTable.calculateTableViewHeight()
        
        cardsTable.snp.remakeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(height)
        }
    }
    
    @objc private func tapped(_ tapGesture: UITapGestureRecognizer) {
        self.openedMenuID = nil
        self.cardsTable.reloadData()
    }
    
    func checkButtonState(isObserving: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8 ) { [weak self] in
            guard let self else { return }
            let imagesIsEnabled = (passportImage != nil || passport?.passport != nil) &&
            (selfiImage != nil || passport?.passport_in_user != nil) &&
            (registrationImage != nil || passport?.registration != nil)
            
            let isEnabled = imagesIsEnabled && !cards.isEmpty && phonesContainer.buttonState(isObserving: isObserving)
            
            
            if isEnabled {
                dismiss(animated: true) {
                    self.verificationFinished?()
                    self.verificationFinished = nil
                }
            }
        }
    }
    
    func makeDefault(card: BankCard?) {
        bankCardViewModel.makeDefault(id: card?.id)
    }
    
    func delete(card: BankCard?, completion: (() -> Void)?) {
        bankCardViewModel.remove(id: card?.id, completion: completion)
    }
    
    func sendCode(model: VerificationUploadCode) {
        bankCardViewModel.verifyBankCardPhone(model: model)
    }
}
