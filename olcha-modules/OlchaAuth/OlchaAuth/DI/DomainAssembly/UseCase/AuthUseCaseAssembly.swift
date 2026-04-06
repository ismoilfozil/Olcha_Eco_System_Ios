//
//  UseCaseAssembly.swift
//  OlchaAuth
//
//  Created by Elbek Khasanov on 26/05/23.
//

import Foundation
import Swinject
final class AuthUseCaseAssembly: Assembly {
    func assemble(container: Container) {
        container.register(GetUserTokenProtocol.self) { r in
            let repository = r.resolve(AuthRepositoryProtocol.self)!
            return AuthUseCase.GetUserToken(repository: repository)
        }
        
        container.register(GetGuestTokenProtocol.self) { r in
            let repository = r.resolve(AuthRepositoryProtocol.self)!
            return AuthUseCase.GetGuestToken(repository: repository)
        }
        
        container.register(GetRefreshTokenProtocol.self) { r in
            let repository = r.resolve(AuthRepositoryProtocol.self)!
            return AuthUseCase.GetRefreshToken(repository: repository)
        }
    }
}
