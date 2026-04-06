//
//  LoginUseCase.swift
//  OlchaAuth
//
//  Created by Elbek Khasanov on 09/08/23.
//

import Foundation
import OlchaCore
import Combine

public protocol CheckPhoneProtocol {
    func execute(phone: String) -> AnyPublisher<BaseResponse<WelcomeData, ValidationErrors>, Never>
}
public protocol LoginProtocol {
    func execute(model: LoginAuthModel) -> AnyPublisher<BaseResponse<LoginModel, LoginModel>, Never>
}
public protocol ConfirmCodeProtocol {
    func execute(model: PhoneRequest) -> AnyPublisher<BaseResponse<WelcomeData, EmptyData>, Never>
}
public protocol RegisterPhoneCodeProtocol {
    func execute(model: PhoneCodeProtocol) -> AnyPublisher<BaseResponse<UserAuthModel, EmptyData>, Never>
}
public protocol RenewPasswordProtocol {
    func execute(model: PasswordRenewRequest) -> AnyPublisher<BaseResponse<WelcomeData, ValidationErrors>, Never>
}
public protocol EditPasswordProtocol {
    func execute(model: PasswordEditRequest) -> AnyPublisher<BaseResponse<WelcomeData, ValidationErrors>, Never>
}
public protocol ResetPhoneCodeProtocol {
    func execute(model: PhoneCodeRequest) -> AnyPublisher<BaseResponse<WelcomeData, EmptyData>, Never>
}

public enum LoginUseCase {
    public class CheckPhone: CheckPhoneProtocol {
        private let repository: LoginRepositoryProtocol
        public init(repository: LoginRepositoryProtocol) {
            self.repository = repository
        }
        public func execute(phone: String) -> AnyPublisher<BaseResponse<WelcomeData, ValidationErrors>, Never> {
            repository.checkPhone(phone: phone)
        }
    }
    public class Login: LoginProtocol {
        private let repository: LoginRepositoryProtocol
        public init(repository: LoginRepositoryProtocol) {
            self.repository = repository
        }
        public func execute(model: LoginAuthModel) -> AnyPublisher<BaseResponse<LoginModel, LoginModel>, Never> {
            repository.login(model: model)
        }
    }
    public class ConfirmCode: ConfirmCodeProtocol {
        private let repository: LoginRepositoryProtocol
        public init(repository: LoginRepositoryProtocol) {
            self.repository = repository
        }
        public func execute(model: PhoneRequest) -> AnyPublisher<BaseResponse<WelcomeData, EmptyData>, Never> {
            repository.confirmCode(model: model)
        }
    }
    public class RegisterPhoneCode: RegisterPhoneCodeProtocol {
        private let repository: LoginRepositoryProtocol
        public init(repository: LoginRepositoryProtocol) {
            self.repository = repository
        }
        public func execute(model: PhoneCodeProtocol) -> AnyPublisher<BaseResponse<UserAuthModel, EmptyData>, Never> {
            repository.registerPhoneCode(model: model)
        }
    }
    public class RenewPassword: RenewPasswordProtocol {
        private let repository: LoginRepositoryProtocol
        public init(repository: LoginRepositoryProtocol) {
            self.repository = repository
        }
        public func execute(model: PasswordRenewRequest) -> AnyPublisher<BaseResponse<WelcomeData, ValidationErrors>, Never> {
            repository.renewPassword(model: model)
        }
    }
    public class EditPassword: EditPasswordProtocol {
        private let repository: LoginRepositoryProtocol
        public init(repository: LoginRepositoryProtocol) {
            self.repository = repository
        }
        public func execute(model: PasswordEditRequest) -> AnyPublisher<BaseResponse<WelcomeData, ValidationErrors>, Never> {
            repository.editPassword(model: model)
        }
    }
    public class ResetPhoneCode: ResetPhoneCodeProtocol {
        private let repository: LoginRepositoryProtocol
        public init(repository: LoginRepositoryProtocol) {
            self.repository = repository
        }
        public func execute(model: PhoneCodeRequest) -> AnyPublisher<BaseResponse<WelcomeData, EmptyData>, Never> {
            repository.resetPhoneCode(model: model)
        }
    }
}
