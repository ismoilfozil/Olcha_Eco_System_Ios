

import UIKit
import OlchaUI
import OlchaCore
import OlchaAuth
import Combine
import OlchaUtils

public class VerificationViewModel: BaseViewModel {
    public static let phone_tag = "phone"
   
    @Published public var passportUpload: LoadingState<PassportModel, (PassportType, String?)> = .standart
    @Published public var passport: LoadingState<DownloadedPassportData, BaseErrorType> = .standart
    @Published public var uploadPhones: LoadingState<EmptyData, BaseErrorType> = .standart
    @Published public var phonesModel: LoadingState<[PhoneModel], BaseErrorType> = .standart
    @Published public var step: LoadingState<VerificationData, BaseErrorType> = .standart
    @Published public var checkExist: LoadingState<MyIdExistModel, BaseErrorType> = .standart
    @Published public var uploadCode: LoadingState<EmptyData, BaseErrorType> = .standart
    
    public var creditVerificationObserver: (() -> Void)?
    
    
    private let loadStepUseCase: LoadStepProtocol
    private let uploadPassportImageUseCase: UploadPassportImageProtocol
    private let loadPassportUseCase: LoadPassportProtocol
    private let uploadPhonesUseCase: UploadPhonesProtocol
    private let loadPhonesUseCase: LoadPhonesProtocol
    private let checkExistUseCase:CheckExistProtocol
    private let uploadCodeUseCase:UploadCodeProtocol
    
    public init(loadStepUseCase: LoadStepProtocol,
                uploadPassportImageUseCase: UploadPassportImageProtocol,
                loadPassportUseCase: LoadPassportProtocol,
                uploadPhonesUseCase: UploadPhonesProtocol,
                loadPhonesUseCase: LoadPhonesProtocol,
                checkExistUseCase:CheckExistProtocol,
                uploadCodeUseCase:UploadCodeProtocol
    ) {
        self.loadStepUseCase = loadStepUseCase
        self.uploadPassportImageUseCase = uploadPassportImageUseCase
        self.loadPassportUseCase = loadPassportUseCase
        self.uploadPhonesUseCase = uploadPhonesUseCase
        self.loadPhonesUseCase = loadPhonesUseCase
        self.checkExistUseCase = checkExistUseCase
        self.uploadCodeUseCase = uploadCodeUseCase
    }
    
    public func loadStep() {
        guard AuthGlobalDefaults.isUser() else { return }
        guard step != .loading else { return }
        step = .loading
        
        loadStepUseCase.execute().sink { [weak self] baseResponse in
            guard let self = self else { return }
            switch baseResponse.status {
            case .success:
                let response = baseResponse.response
                VerificationGlobalDefaults.settings.requested_time = response?.last_requested
                if Config.isDebug {
                    self.step = .success(response)
//                    self.step = .success(VerificationData.mock())
                } else {
                    self.step = .success(response)
                }
            default:
                self.step = .failure(.init(message: baseResponse.error))
            }
        }.store(in: &bag)
        
    }
    
    public func uploadPassportImage(image: UIImage?, type: PassportType) {
        let model = PassportModel(type: type, image: image)
        passportUpload = .loading
        uploadPassportImageUseCase.execute(model: model) { [weak self] baseResponse in
            guard let self = self else { return }
            switch baseResponse.status {
            case .success:
                passportUpload = .success(model)
                OlchaVerificationDIContainer.shared.authCreditViewModel().verifyCredit()
            default:
                passportUpload = .failure((type, baseResponse.error))
            }
        }
    }
    
    
    
    public func loadPassport() {
        passport = .loading
        loadPassportUseCase.execute().sink { [weak self] baseResponse in
            guard let self = self else { return }
            switch baseResponse.status {
            case .success:
                self.passport = .success(baseResponse.response)
            default:
                self.passport = .failure(.init(message: baseResponse.error))
            }
        }.store(in: &bag)
    }
    
    public func uploadPhones(phones: [PhoneModel]) {
        guard !phones.isEmpty else { return }

        var phonesDict : [[String: String]] = []
        
        for phone in phones {
            if let number = phone.phone {
                phonesDict.append(
                    [ VerificationViewModel.phone_tag : number]
                )
            }
        }
        
        uploadPhones = .loading
        uploadPhonesUseCase.execute(model: .init(phones: phonesDict))
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    uploadPhones = .success(.init())
                    //            creditVerificationObserver?()
                    OlchaVerificationDIContainer.shared.authCreditViewModel().verifyCredit()
                default:
                    uploadPhones = .failure(baseResponse.validationErrors)
                }
            }.store(in: &bag)
        
    }
    
    public func loadPhones() {
        phonesModel = .loading
        #warning("CHECK NETWORK")
        loadPhonesUseCase.execute().sink { [weak self] baseResponse in
            guard let self = self else { return }
            switch baseResponse.status {
            case .success:
                if let values = baseResponse.response?.data?.values {
                    self.phonesModel = .success(Array(values.compactMap { $0 }))
                }
            default:
                self.phonesModel = .failure(.init(message: baseResponse.error))
            }
        }.store(in: &bag)
    }
    
    
    public func checkExist(passport:String){
        checkExist = .loading
        let model = MyIdPassportModel(passport: passport)
        
        checkExistUseCase.execute(model: model).sink { [weak self] baseResponse in
            guard let self = self else { return }
            switch baseResponse.status {
            case .success:
                self.checkExist = .success(baseResponse.response)
            default:
                self.checkExist = .failure(.init(message: baseResponse.error))
            }
        }.store(in: &bag)
    }
    
    
    public func uploadCode(code:String){
        uploadCode = .loading
        let model = MyIdCodeModel(code: code)
        uploadCodeUseCase.execute(model: model).sink { [weak self] baseResponse in
            guard let self = self else { return }
            switch baseResponse.status {
            case .success:
                self.uploadCode = .success(baseResponse.response)
            default:
                self.uploadCode = .failure(.init(message: baseResponse.error))
            }
        }.store(in: &bag)
    }
    

}
