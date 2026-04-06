//
//  SearchViewModel.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 03/04/23.
//

import UIKit
import OlchaUI
import Combine
import OlchaCore

public class SearchViewModel: BaseViewModel, ObservableObject {

    private var debounceTimer: Timer?
    private var categoryID: Int?
    private var page: Int = 1
    private var searchText: String = "" {
        didSet {
            if oldValue != searchText {
                page = 1
                providers = .success(nil)
            }
        }
    }
    
    @Published var providers: LoadingState<ProvidersData, BaseErrorType> = .standart
    
    private let searchProvidersUseCase: SearchProvidersProtocol

    public init(searchProvidersUseCase: SearchProvidersProtocol) {
        self.searchProvidersUseCase = searchProvidersUseCase
    }

    public func search(page: Int,
                       searchText: String?,
                       categoryID: Int?) {
        guard let searchText = searchText, searchText.withoutSpace.count > 2 else { return }
        self.page = page
        self.categoryID = categoryID
        if self.searchText == searchText {
            searchProviders()
        } else {
            self.searchText = searchText
            
            debounceTimer?.invalidate()
            
            debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
                guard let self = self else { return }
                self.searchProviders()
            }
        }
    }
    
    private func searchProviders() {
        
        providers = .loading
        searchProvidersUseCase.execute(filter: .init(page: page,
                                                     search: searchText,
                                                     categoryID: categoryID)
        ).sink { [weak self] baseResponse in
            guard let self = self else { return }
            
            switch baseResponse.status {
            case .success:
                self.providers = .success(baseResponse.response)
                break
            case .canceled:
                break
            case .fail:
                self.providers = .failure(.init(message: baseResponse.error))
                break
            }
            
        }.store(in: &bag)
    }

}
