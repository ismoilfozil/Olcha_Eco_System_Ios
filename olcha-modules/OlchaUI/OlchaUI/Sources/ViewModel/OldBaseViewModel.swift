//
//  BaseViewModel.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 29/06/22.
//

import Foundation
import Combine
import UIKit
import OlchaUtils
import SwiftyJSON
import OlchaCore

open class OldBaseViewModel {
    private var bag = Set<AnyCancellable>()
    @Published public var centerLoading: Bool = false
    @Published public var postLoading: Bool = false
    @Published public var errorMessage: String = ""
    @Published public var successMessage: String = ""
    
    public var centerLoadingsCount = 0
    public let authObserver = PassthroughSubject<Bool, Never>()
    
    private let manager: NetworkManagerProtocol
    
    public init(manager: NetworkManagerProtocol) {
        self.manager = manager
    }
    
    public func startRequesting<Response: Codable>(
        api: BaseAPI,
        isCancellable: Bool = false,
        isSingleRequest: Bool = false,
        centerLoader: Bool = false,
        indicator: CurrentValueSubject<Bool, Never>? = nil,
        onCompleted: @escaping (Response?) -> Void,
        onError: ((String?) -> Void)? = nil
    )  {
        
        request(api: api,
                isCancellable: isCancellable,
                isSingleRequest: isSingleRequest,
                centerLoader: centerLoader,
                indicator: indicator,
                onCompleted: onCompleted,
                onError: onError) { (error: EmptyData?) in }
    }
    
    public func startRequestingWithErrors<Response: Codable, OutputErrors: Codable>(
        api: BaseAPI,
        isCancellable: Bool = false,
        isSingleRequest: Bool = false,
        centerLoader: Bool = false,
        indicator: CurrentValueSubject<Bool, Never>? = nil,
        onCompleted: @escaping (Response?) -> Void,
        onError: ((String?) -> Void)? = nil,
        onErrors: ((OutputErrors?) -> Void)? = nil
    )  {
        
        request(api: api,
                isCancellable: isCancellable,
                isSingleRequest: isSingleRequest,
                centerLoader: centerLoader,
                indicator: indicator,
                onCompleted: onCompleted,
                onError: onError,
                onErrors: onErrors
        )
    }
    
    public func startDataRequesting(
        api: BaseAPI,
        centerLoader: Bool = false,
        indicator: CurrentValueSubject<Bool, Never>? = nil,
        onCompleted: @escaping (Data?) -> Void,
        onError: ((String?) -> Void)? = nil)  {
            indicator?.send(true)
            if centerLoading {
                self.centerLoading = true
            }
            self.manager.requestJSON(api: api) {
                [weak self] (result: BaseResponseData) in
                guard let self = self else { return }
                if centerLoader {
                    self.centerLoading = false
                }
                switch result.status {
                case .success:
                    onCompleted(result.response)
                    break
                default:
                    if onError == nil {
                        self.show(error: result.error)
                    } else {
                        onError?(result.error)
                    }
                    break
                }
                indicator?.send(false)
            }
        }
    
    public func startUploading<Response: Codable>(
        api: BaseAPI,
        type: UploadType = .image,
        centerLoader: Bool = false,
        indicator: CurrentValueSubject<Bool, Never>? = nil,
        progress: PassthroughSubject<Double, Never>? = nil,
        onCompleted: @escaping (Response?) -> Void,
        onError: ((String?) -> Void)? = nil
    ) {
        indicator?.send(true)
        if centerLoader {
            self.centerLoading = true
        }
        manager.upload(type: type,
                       api: api,
                       progress: progress
        ) { [weak self] (result: BaseResponse<Response, EmptyData>) in
            guard let self = self else { return }
            if centerLoader {
                self.centerLoading = false
            }
            switch result.status {
            case .success:
                onCompleted(result.response)
                break
            default:
                if onError == nil {
                    self.show(error: result.error)
                } else {
                    onError?(result.error)
                }
                break
            }
            indicator?.send(false)
        }
    }
    
    private func request<Response: Codable, OutputErrors: Codable>(
        api: BaseAPI,
        isCancellable: Bool = false,
        isSingleRequest: Bool = false,
        centerLoader: Bool = false,
        indicator: CurrentValueSubject<Bool, Never>? = nil,
        onCompleted: @escaping (Response?) -> Void,
        onError: ((String?) -> Void)? = nil,
        onErrors: ((OutputErrors?) -> Void)? = nil)  {
            indicator?.send(true)
            postLoading = true
            
            if centerLoader {
                self.centerLoading = true
            }
                        
            self.manager.request(api: api,
                                 isSingleRequest: isSingleRequest,
                                 isCancellable: isCancellable
            ).sink { [weak self] (result: BaseResponse<Response, OutputErrors>) in
                guard let self = self else { return }
                
                self.postLoading = false
                if centerLoader {
                    self.centerLoading = false
                }
                
                switch result.status {
                case .success:
                    onCompleted(result.response)
                    break
                case .canceled:
                    break
                default:
                    
                    if result.errors != nil {
                        onErrors?(result.errors)
                    } else {
                        if onError == nil {
                            self.show(error: result.error)
                        } else {
                            onError?(result.error)
                        }
                    }
                    
                    break
                }
                indicator?.send(false)
            }
            .store(in: &bag)
            
        }
    
    public func show(error: String?) {
        self.errorMessage = error ?? Texts.fail
    }
    
    public func show(success: String?) {
        self.successMessage = success ?? ""
    }
    
    deinit {
        bag.forEach { $0.cancel() }
    }
}

