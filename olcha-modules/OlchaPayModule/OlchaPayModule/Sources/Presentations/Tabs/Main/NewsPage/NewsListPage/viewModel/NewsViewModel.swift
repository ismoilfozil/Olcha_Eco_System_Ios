//
//  NewsViewModel.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 16/02/23.
//

import Foundation
import OlchaUI
import OlchaCore
import UIKit
public class NewsViewModel: BaseViewModel {
    
    @Published var newsData: LoadingState<NewsData, BaseErrorType> = .standart
    
    private let loadNewsUseCase: LoadNewsProtocol
    
    public init(loadNewsUseCase: LoadNewsProtocol) {
        self.loadNewsUseCase = loadNewsUseCase
    }
    
    func loadImages(page: Int) {
        newsData = .loading
        loadNewsUseCase.execute(page: page)
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    self.newsData = .success(baseResponse.response)
                    break
                default:
                    self.newsData = .failure(.init(message: baseResponse.error))
                    break
                }
            }.store(in: &bag)
    }
    
    func sizeOfImageAt(urlString: String?) -> CGSize? {
        do {
            guard let urlString = urlString, let url = URL(string: urlString) else { return nil }
            let data = try Data(contentsOf: url)
            let image = UIImage(data: data)
            return image?.size
        } catch {
            return nil
        }
    }
}
