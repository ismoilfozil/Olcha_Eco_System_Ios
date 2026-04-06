//
//  NasiyaProfileViewModel.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 24/06/23.
//

import Combine
import OlchaUI
import OlchaUtils
import OlchaCore
import OlchaAuth

public class NasiyaProfileViewModel: BaseViewModel {
    
    private let loadProfileUseCase: LoadProfileProtocol
    private let editProfileUseCase: EditProfileProtocol
    
    @Published public var user: LoadingState<NasiyaUser, BaseErrorType> = .standart
    @Published public var editUser: LoadingState<EmptyData, BaseErrorType> = .standart
    
    public init(loadProfileUseCase: LoadProfileProtocol, editProfileUseCase: EditProfileProtocol) {
        self.loadProfileUseCase = loadProfileUseCase
        self.editProfileUseCase = editProfileUseCase
    }
    
    public func editUser(_ user: NasiyaUser?) {
        guard let user = user else { return }
        editUser = .loading
        editProfileUseCase.execute(user: user).sink { [weak self] baseResponse in
            guard let self = self else { return }
            switch baseResponse.status {
            case .success:
                editUser = .success(baseResponse.response)
                break
            default:
                editUser = .failure(.init(message: baseResponse.error))
                break
            }
        }.store(in: &bag)
    }
    
    public func loadUser() {
        user = .loading
        loadProfileUseCase.execute().sink { [weak self] baseResponse in
            guard let self = self else { return }
            switch baseResponse.status {
            case .success:
                user = .success(baseResponse.response?.profile)
                break
            default:
                user = .failure(.init(message: baseResponse.error))
                break
            }
        }.store(in: &bag)
    }
}
