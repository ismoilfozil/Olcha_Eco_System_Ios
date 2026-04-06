//
//  AuthViewModel.swift
//  OlchaAuth
//
//  Created by Elbek Khasanov on 12/04/23.
//

import UIKit
import OlchaUI
import OlchaCore
import OlchaUtils
protocol AuthViewModelProtocol: AnyObject {
    func getToken()
    func checkPhone(_ phone: String)
    func login(phone: String, password: String)
    func confirmCode(phone: String)
    func registerPhoneCode(phone: String, code: String)
    func resetPhoneCode(phone: String, code: String)
    func renewPassword(phone: String, password: String, password2: String, code: String)
    func register(name: String, lastname: String)
    func editPassword(phone: String?, password: String, password2: String)
}

public class AuthViewModel: BaseViewModel, AuthViewModelProtocol {

    nonisolated(unsafe) public static let shared: AuthViewModel = AuthDIContainer.shared.resolve(name: .shared)

    @Published public var isPhoneExists: LoadingState<WelcomeData, BaseErrorType> = .standart
    @Published public var sendConfirmCodePublisher: LoadingState<EmptyData, BaseErrorType> = .standart
    @Published public var registerPhoneCodePublisher: LoadingState<UserAuthModel, BaseErrorType> = .standart
    @Published public var loginPublisher: LoadingState<EmptyData, BaseErrorType> = .standart
    @Published public var resetPhonePublisher: LoadingState<EmptyData, BaseErrorType> = .standart
    @Published public var renewPasswordPublisher: LoadingState<EmptyData, BaseErrorType> = .standart
    @Published public var editPasswordPublisher: LoadingState<EmptyData, BaseErrorType> = .standart
    @Published public var device: LoadingState<EmptyData, BaseErrorType> = .standart

    private let checkPhoneUseCase: CheckPhoneProtocol
    private let loginUseCase: LoginProtocol
    private let confirmCodeUseCase: ConfirmCodeProtocol
    private let registerPhoneCodeUseCase: RegisterPhoneCodeProtocol
    private let getGuestTokenUseCase: GetGuestTokenProtocol
    private let getUserTokenUseCase: GetUserTokenProtocol
    private let getRefreshTokenUseCase: GetRefreshTokenProtocol
    private let resetPhoneCodeUseCase: ResetPhoneCodeProtocol
    private let renewPasswordUseCase: RenewPasswordProtocol
    private let editPasswordUseCase: EditPasswordProtocol
    private let storeUserDeviceUseCase: StoreUserDeviceProtocol
    private let deleteUserDeviceUseCase: DeleteUserDeviceProtocol
    
    public init(
        checkPhoneUseCase: CheckPhoneProtocol,
        loginUseCase: LoginProtocol,
        confirmCodeUseCase: ConfirmCodeProtocol,
        registerPhoneCodeUseCase: RegisterPhoneCodeProtocol,
        getGuestTokenUseCase: GetGuestTokenProtocol,
        getUserTokenUseCase: GetUserTokenProtocol,
        getRefreshTokenUseCase: GetRefreshTokenProtocol,
        resetPhoneCodeUseCase: ResetPhoneCodeProtocol,
        renewPasswordUseCase: RenewPasswordProtocol,
        editPasswordUseCase: EditPasswordProtocol,
        storeUserDeviceUseCase: StoreUserDeviceProtocol,
        deleteUserDeviceUseCase: DeleteUserDeviceProtocol
    ) {
        self.checkPhoneUseCase = checkPhoneUseCase
        self.loginUseCase = loginUseCase
        self.confirmCodeUseCase = confirmCodeUseCase
        self.registerPhoneCodeUseCase = registerPhoneCodeUseCase
        self.getGuestTokenUseCase = getGuestTokenUseCase
        self.getUserTokenUseCase = getUserTokenUseCase
        self.getRefreshTokenUseCase = getRefreshTokenUseCase
        self.resetPhoneCodeUseCase = resetPhoneCodeUseCase
        self.renewPasswordUseCase = renewPasswordUseCase
        self.editPasswordUseCase = editPasswordUseCase
        self.storeUserDeviceUseCase = storeUserDeviceUseCase
        self.deleteUserDeviceUseCase = deleteUserDeviceUseCase
    }
    
    public func checkPhone(_ phone: String) {
        isPhoneExists = .loading
        
        checkPhoneUseCase.execute(phone: phone.phoneNumber)
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                
                switch baseResponse.status {
                case .success:
                    self.isPhoneExists = .success(baseResponse.response)
                default:
                    self.isPhoneExists = .failure(baseResponse.validationErrors)
                }
                isPhoneExists = .standart
                
            }.store(in: &bag)
    }
    
    public func login(phone: String, password: String) {
        loginPublisher = .loading
        loginUseCase.execute(model: .init(username: phone,
                                          password: password,
                                          client_id: AuthTexts.client_ID,
                                          client_secret: AuthTexts.client_secret,
                                          grant_type: AuthTexts.password
                                         )
        )
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                
                let data = baseResponse.response
                switch baseResponse.status {
                case .success:
                    if let code = data?.status_code, code == "401" {
                        if let message = data?.message {
                            self.loginPublisher = .failure(.init(message: message))
                        } else if let message = baseResponse.error {
                            self.loginPublisher = .failure(.init(message: message))
                        }
                        return
                    }
                    AuthGlobalDefaults.user.phone = phone

                    AuthGlobalDefaults.access_token = data?.access_token

                    AuthGlobalDefaults.refresh_token = data?.refresh_token
                    AuthGlobalDefaults.changeCredentials(userType: .user)
                    self.loginPublisher = .success(.init())
                    break
                default:
                    if let message = data?.message {
                        self.loginPublisher = .failure(.init(message: message))
                    } else if let message = baseResponse.error {
                        self.loginPublisher = .failure(.init(message: message))
                    }
                    break
                }
            }.store(in: &bag)
    }
    
    public func confirmCode(phone: String) {
        
        sendConfirmCodePublisher = .loading
        confirmCodeUseCase.execute(model: .init(phone: phone.phoneNumber))
            .sink { [weak self] baseResposne in
                guard let self = self else { return }
                switch baseResposne.status {
                case .success:
                    self.sendConfirmCodePublisher = .success(.init())
                    break
                default:
                    self.sendConfirmCodePublisher = .failure(.init(message: baseResposne.error))
                    break
                }
                sendConfirmCodePublisher = .standart
            }.store(in: &bag)
    }
    
    public func getToken() {
        AuthGlobalDefaults.isUser() ? getUserToken() : getGuestToken()
    }
    
    public func registerPhoneCode(phone: String, code: String) {
        registerPhoneCodePublisher = .loading
        let model: PhoneCodeProtocol
        
        if let referal = AuthGlobalDefaults.referral_id {
            model = PhoneCodeReferalRequest(
                phone: phone,
                code: code,
                referral_id: referal)
        } else {
            model = PhoneCodeRequest(
                phone: phone,
                code: code)
        }
        
        registerPhoneCodeUseCase.execute(model: model)
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    AuthGlobalDefaults.user.phone = phone
                    let data = baseResponse.response
                    AuthGlobalDefaults.referral_id = nil
                    AuthGlobalDefaults.access_token = data?.token?.access_token
                    AuthGlobalDefaults.refresh_token = data?.token?.refresh_token
                    AuthGlobalDefaults.changeCredentials(userType: .user)
                    
                    self.registerPhoneCodePublisher = .success(baseResponse.response)
                    break
                default:
                    self.registerPhoneCodePublisher = .failure(.init(message: baseResponse.error))
                    break
                }
                registerPhoneCodePublisher = .standart
            }.store(in: &bag)
    }
    
    private func getGuestToken() {
        getGuestTokenUseCase.execute()
            .sink { baseResponse in
                switch baseResponse.status {
                case .success:
                    AuthGlobalDefaults.access_token = baseResponse.response?.access_token
                    AuthGlobalDefaults.refresh_token = baseResponse.response?.refresh_token
                    break
                default:
                    break
                }
                
            }.store(in: &bag)
        
    }
    
    private func getUserToken() {
        getUserTokenUseCase.execute()
            .sink { baseResponse in
                switch baseResponse.status {
                case .success:
                    AuthGlobalDefaults.access_token = baseResponse.response?.access_token
                    AuthGlobalDefaults.refresh_token = baseResponse.response?.refresh_token
                default:
                    break
                }
                
            }.store(in: &bag)
    }
    
    public func getRefreshToken() {
        getRefreshTokenUseCase.execute()
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    break
                default:
                    break
                }
            }.store(in: &bag)
    }
    
    public func resetPhoneCode(phone: String, code: String) {
        resetPhonePublisher = .loading
        resetPhoneCodeUseCase.execute(
            model: .init(phone: phone,
                         code: code)
        ).sink { [weak self] baseResponse in
            guard let self = self else { return }
            switch baseResponse.status {
            case .success:
                self.resetPhonePublisher = .success(.init())
            default:
                self.resetPhonePublisher = .failure(.init(message: baseResponse.error))
            }
            resetPhonePublisher = .standart
        }.store(in: &bag)
    }
    
    public func renewPassword(phone: String, password: String, password2: String, code: String) {
        renewPasswordPublisher = .loading
        guard password == password2 else {
            renewPasswordPublisher = .failure(createIncorrectPassword())
            return
        }
        
        renewPasswordUseCase.execute(
            model: .init(password: password,
                         password_confirmation: password2,
                         phone: phone,
                         code: code)
        ).sink { [weak self] baseResponse in
            guard let self = self else { return }
            switch baseResponse.status {
            case .success:
                self.renewPasswordPublisher = .success(.init())
                self.login(phone: phone, password: password)
                break
            default:
                self.renewPasswordPublisher = .failure(.init(baseResponse.validationErrors))
                break
            }
            renewPasswordPublisher = .standart
        }.store(in: &bag)
    }
    
    func register(name: String, lastname: String) {
        //
    }
    
    public func editPassword(phone: String? = nil, password: String, password2: String) {
        guard password == password2 else {
            editPasswordPublisher = .failure(
                .init(
                    message: "incorrect_confirm_password".localized(),
                    errors: [(\PasswordEditRequest.password_confirmation).propertyName : ["incorrect_confirm_password".localized()]]
                )
                    
            )
            return
        }
        editPasswordPublisher = .loading
        editPasswordUseCase.execute(model: .init(password: password,
                                                 password_confirmation: password2)
        ).sink { [weak self] baseResponse in
            guard let self = self else { return }
            switch baseResponse.status {
            case .success:
                self.editPasswordPublisher = .success(.init())
                
                guard let phone = phone else { return }
                
                self.login(phone: phone, password: password)
                break
            default:
                self.editPasswordPublisher = .failure(baseResponse.validationErrors)
                break
            }
            editPasswordPublisher = .standart
        }.store(in: &bag)
    }
    
    private func createIncorrectPassword() -> BaseErrorType {
        .init(errors: [ (\PasswordEditRequest.password_confirmation).propertyName : ["incorrect_confirm_password".localized()]])
    }
}

public extension AuthViewModel {
    func storeUserDevice() {
        guard AuthGlobalDefaults.isUser(), device != .loading else { return }
        device = .loading
        
        let token = AuthGlobalDefaults.notification.fcm_token ?? ""
        let lang = String.getAppLanguage()
        let version = Bundle.main.appVersionLong
        let userDevice = MainActor.assumeIsolated { UserDevice(token: token, user_lang: lang, app_version: version) }
        storeUserDeviceUseCase.execute(model: userDevice)
            .sink { [weak self] data in
                guard let self else { return }
                switch data.status {
                case .success:
                    device = .success(nil)
                default:
                    device = .failure(BaseErrorType(message: data.error))
                }
            }.store(in: &bag)
    }
    
    func deleteUserDevice(completion: @escaping () -> Void) {
        guard AuthGlobalDefaults.isUser(), device != .loading else { return }
        device = .loading
        
        let token = AuthGlobalDefaults.notification.fcm_token ?? ""
        deleteUserDeviceUseCase.execute(token: token)
            .sink { [weak self] data in
                guard let self else { return }
                switch data.status {
                case .success:
                    device = .success(nil)
                default:
                    device = .failure(BaseErrorType(message: data.error))
                }
                completion()
            }.store(in: &bag)
    }
}
