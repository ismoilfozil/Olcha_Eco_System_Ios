//
//  ProfileViewModel.swift
//  OlchaAuth
//
//  Created by Elbek Khasanov on 12/04/23.
//

import UIKit
import OlchaUI
import OlchaCore

public class ProfileViewModel: BaseViewModel {

    @Published public var user: LoadingState<User, BaseErrorType> = .standart
    @Published public var editUser: LoadingState<EmptyData, BaseErrorType> = .standart
    @Published public var deleteUser: LoadingState<EmptyData, BaseErrorType> = .standart
    
    public var userData: User?
    
    private let loadUserDataUseCase: LoadUserDataProtocol
    private let editUserDataUseCase: EditUserDataProtocol
    private let deleteUserUseCase: DeleteUserProtocol
    
    public init(
        loadUserDataUseCase: LoadUserDataProtocol,
        editUserDataUseCase: EditUserDataProtocol,
        deleteUserUseCase: DeleteUserProtocol
    ) {
        self.loadUserDataUseCase = loadUserDataUseCase
        self.editUserDataUseCase = editUserDataUseCase
        self.deleteUserUseCase = deleteUserUseCase
    }
    
    public func loadUserData() {
        guard AuthGlobalDefaults.isUser(), user != .loading else { return }
        user = .loading
        loadUserDataUseCase.execute()
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    let userData = baseResponse.response?.user
                    self.user = .success(userData)
                    self.userData = userData
                    AuthGlobalDefaults.user.id = userData?.id
                    AuthGlobalDefaults.user.name = userData?.name
                    AuthGlobalDefaults.user.phone = userData?.phone?.phoneNumber
                    AuthGlobalDefaults.user.created_at = userData?.created_at
                default:
                    self.user = .failure(nil)
                    break
//                    self.user = .failure(.init(message: baseResponse.error))
                }
                user = .standart
            }.store(in: &bag)
    }
 
    public func edit(user: User?) {
        guard let user = user else {
            return
        }
        editUser = .loading
        editUserDataUseCase.execute(model: user)
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    editUser = .success(baseResponse.response)
                default:
                    editUser = .failure(baseResponse.validationErrors)
                }
                editUser = .standart
                
            }.store(in: &bag)
    }
    
    public func delete() {
        guard deleteUser != .loading else { return }
        deleteUser = .loading
        deleteUserUseCase.execute()
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    deleteUser = .success(baseResponse.response)
                default:
                    deleteUser = .failure(.init(message: baseResponse.error))
                }
                deleteUser = .standart
            }.store(in: &bag)
    }
}
