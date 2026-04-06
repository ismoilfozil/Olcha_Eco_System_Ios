//
//  NetworkManager.swift
//  OlchaCore
//
//  Created by Elbek Khasanov on 20/01/23.
//

import Foundation
import Alamofire
import Combine
import SwiftyJSON


public enum UploadType {
    case image
    case video
}

public protocol FirebaseLogDelegate: AnyObject {
    func requestLog(request: URLRequest, response: AFDataResponse<Data?>)
    func decodeLog(url: String?, response: AFDataResponse<Data?>, message: String)
}

public protocol NetworkManagerProtocol: AnyObject {
    
    ///
    /// - `simple request` ``request<Output: Codable, OutputErrors: Codable>(api:isSingleRequest:isCancellable:)`` :
    /// - `Output`                        - to decode response
    /// - `OutputErrors`           - to decode error response
    /// - `BaseAPI`                      - is api protocol, which includes base parametrs to connect with network.
    /// - `isSingleRequest`    - value for receiving, response without `baseResponse`
    /// - `isCancellable`        - value for `revoke, fire, cancel` previous `same request`
    ///
    func request<Output: Codable, OutputErrors: Codable>(api: BaseAPI, isSingleRequest: Bool, isCancellable: Bool) -> AnyPublisher<(BaseResponse<Output, OutputErrors>), Never>
    
    ///
    /// - `simple upload` ``upload(type:api:progress:onCompletion:)`` :
    /// - `Output`                        - to decode response;
    /// - `OutputErrors`           - to decode error response;
    /// - `UploadType`                - is media type: `image`, `video`;
    /// - `progress`                    - progress for which count is uploaded;
    /// - `onCompletion`           - to observe completion
    ///
    func upload<Output: Codable, OutputErrors: Codable>(
        type: UploadType,
        api: BaseAPI,
        progress: PassthroughSubject<Double, Never>?,
        onCompletion: @escaping (BaseResponse<Output, OutputErrors>) -> Void )
    
    ///
    /// - `simple request json` ``requestJSON(api:onCompletion:)`` :
    /// - `Output`                        - to decode response;
    /// - `OutputErrors`           - to decode error response;
    /// - `BaseAPI`                      - is api protocol, which includes base parametrs to connect with network.
    /// - `onCompletion`           - to observe completion
    ///
    func requestJSON(api: BaseAPI,
                     onCompletion: @escaping (BaseResponseData) -> Void )
}

public extension NetworkManagerProtocol {
    func request<Output: Codable, OutputErrors: Codable>(api: BaseAPI, isSingleRequest: Bool = false, isCancellable: Bool = false) -> AnyPublisher<(BaseResponse<Output, OutputErrors>), Never> {
        self.request(api: api, isSingleRequest: isSingleRequest, isCancellable: isCancellable)
    }
}

public class NetworkManager: NetworkManagerProtocol {
    
    private let sessionManager: SessionManager
    
    ///
    /// Don't make network queue concurrent. It must always be serial.
    ///
    private let networkQueue: DispatchQueue
    
    public init(interceptor: RequestInterceptor) {
        sessionManager = SessionManager(interceptor: interceptor)
        networkQueue = DispatchQueue(label: "com.olcha.OlchaCore.network-queue", qos: .utility)
    }
    
    weak var logDelegate: FirebaseLogDelegate?
    
    var currentRequest: DataRequest?
    
    public func request<Output: Codable, OutputErrors: Codable>(
        api: BaseAPI,
        isSingleRequest: Bool = false,
        isCancellable: Bool = false) -> AnyPublisher<(BaseResponse<Output, OutputErrors>), Never> {
            return Future { [weak self] promise in
                guard let self = self else { return }
                
                if let path = self.currentRequest?.request?.url?.path {
                    if path.contains(api.path) && isCancellable {
                        self.currentRequest?.cancel()
                    }
                }
                
                var baseResponse = BaseResponse<Output, OutputErrors>(status: .fail,
                                                                      error: nil,
                                                                      response: nil)
                
                guard let request = NetworkManager.createRequest(api: api) else {
                    return promise(.success(baseResponse))
                }
                let requestTime = getDateString(with: Date())
                currentRequest = self.sessionManager
                    .session
                    .request(request)
                    .validate()
                    .response(queue: networkQueue) { response in
                        print("HEADERS: ", request.headers)
                        
                        let result = response.result
                        print("REQUEST FINISHED 🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀", request.url)
                        
                        LogDB.shared.logs.append(
                            LogModel(url: request.url?.absoluteString,
                                     code: response.response?.statusCode,
                                     header: "\(request.headers)",
                                     requestType: request.httpMethod,
                                     body: "\(JSON(request.httpBody))",
                                     response: "\(JSON(response.data))",
                                     requestTime: requestTime,
                                     responseTime: self.getDateString(with: Date())
                                    )
                        )
                        
                        
                        var baseDecodedData: BaseDecodingResponse<Output, OutputErrors>?
                        
                        do {
                            baseDecodedData = try self.decodeBaseResponse(response.data, isSingleRequest: isSingleRequest)
                        } catch {
                            decodelog(api: api.path, error: error, data: response.data)
                            self.logDelegate?.decodeLog(url: request.url?.absoluteString, response: response, message: "\(error)")
                            baseResponse.status = .fail
                        }
                        
                        log(funcName: "\(String(describing: request.url))",
                            api: api.path,
                            data: response.data,
                            body: api.body)
                        switch result {
                        case .success:
                            if let baseDecodedData = baseDecodedData {
                                if !isSingleRequest {
                                    if baseDecodedData.status?.lowercased() == "ok" || baseDecodedData.status?.lowercased() == "success" || baseDecodedData.success == true {
                                        baseResponse.error = baseDecodedData.message
                                        baseResponse.status = .success
                                        baseResponse.response = baseDecodedData.data
                                    } else {
                                        baseResponse.error = baseDecodedData.message
                                        baseResponse.status = .fail
                                        baseResponse.response = nil
                                        baseResponse.errors = baseDecodedData.errors
                                        self.logDelegate?.requestLog(request: request, response: response)
                                    }
                                    
                                } else {
                                    baseResponse.error = nil
                                    baseResponse.status = .success
                                    baseResponse.response = baseDecodedData.data
                                }
                                
                            }
                            break
                        case .failure(let error):
                            faillog(api: api.path, error: error)
                            self.logDelegate?.requestLog(request: request, response: response)
                            
                            baseResponse.error = baseDecodedData?.message
                            baseResponse.status = .fail
                            baseResponse.response = baseDecodedData?.data
                            baseResponse.errors = baseDecodedData?.errors
                            
                            if error.isExplicitlyCancelledError {
                                baseResponse.status = .canceled
                            }
                            break
                            
                        }
                        
                        let finalResponse = baseResponse
                        DispatchQueue.main.async {
                            promise(.success(finalResponse))
                        }
                    }
                
                
            }.eraseToAnyPublisher()
        }
    
    public func requestJSON(api: BaseAPI,
                            onCompletion: @escaping (BaseResponseData) -> Void ) {
        var baseResponse = BaseResponseData(status: .fail,
                                            error: nil,
                                            response: nil)
        
        guard let request = NetworkManager.createRequest(api: api) else {
            onCompletion(baseResponse)
            return
        }
        
        sessionManager
            .session
            .request(request)
            .validate()
            .response { (response) in
                let result = response.result
                print("REQUEST FINISHED 🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀", request.url)
                log(funcName: "\(request.url)", api: api.path, data: response.data)
                switch result {
                case .success(let data):
                    if let data = data {
                        baseResponse.response = data
                        baseResponse.status = .success
                        baseResponse.error = nil
                    }
                    break
                case .failure(let error):
                    faillog(api: api.path, error: error)
                    baseResponse.status = .fail
                    baseResponse.response = nil
                    break
                }
                
                onCompletion(baseResponse)
            }
    }
    
    
    public func upload<Output: Codable, OutputErrors: Codable>(
        type: UploadType,
        api: BaseAPI,
        progress: PassthroughSubject<Double, Never>?,
        onCompletion: @escaping (BaseResponse<Output, OutputErrors>) -> Void ) {
            var baseResponse = BaseResponse<Output, OutputErrors>(status: .fail,
                                                                  error: nil,
                                                                  response: nil)
            
            guard let baseURL = URL(string: api.baseURL + api.version) else {
                onCompletion(baseResponse)
                return
            }
            
            let path = api.path
            let urlWithPath = baseURL.appendingPathComponent(path).absoluteString.removingPercentEncoding ?? ""
            guard
                let url = URL(string: urlWithPath)
            else {
                onCompletion(baseResponse)
                return
            }
            
            
            AF.upload(
                multipartFormData: { (multipartFormData) in
                    if let data = api.body {
                        switch type {
                        case .image:
                            multipartFormData.append(data, withName: "file", fileName: "JPEG", mimeType: "image/jpeg")
                            break
                        case .video:
                            break
                        }
                    }
                    
                    for (key, value) in api.params {
                        if let val = value.data(using: .utf8) {
                            multipartFormData.append(val, withName: key)
                        }
                        
                    }
                },
                to: url,
                method: .init(rawValue: api.method.rawValue),
                headers: api.headers.items
            ).uploadProgress(closure: { percent in
                progress?.send(percent.fractionCompleted)
            }).response { [weak self] (response) in
                guard let self = self else { return }
                let result = response.result
                print("UPLOAD FINISHED ✈️✈️✈️✈️✈️✈️✈️✈️✈️✈️✈️✈️", url)
                
                log(funcName: "\(String(describing: url))", api: api.path, data: response.data)
                
                switch result {
                case .success(let data):
                    if let data = data {
                        do {
                            
                            let decodedData = try data.decodeData() as BaseDecodingResponse<Output, OutputErrors>
                            
                            if decodedData.status == "ok" { //Texts.status_ok
                                baseResponse.error = nil
                                baseResponse.status = .success
                                baseResponse.response = decodedData.data
                                
                            } else {
                                baseResponse.error = decodedData.message
                                baseResponse.status = .fail
                                baseResponse.response = nil
                            }
                            
                            
                        } catch {
                            decodelog(api: api.path, error: error, data: data)
                            self.logDelegate?.decodeLog(url: url.absoluteString, response: response, message: "\(error)")
                            baseResponse.status = .fail
                        }
                    }
                    break
                case .failure(let error):
                    faillog(api: api.path, error: error)
                    baseResponse.status = .fail
                    baseResponse.response = nil
                    break
                }
                
                onCompletion(baseResponse)
            }
        }
    
    private func decodeBaseResponse<Output, OutputErrors>(_ data: Data?, isSingleRequest: Bool) throws -> BaseDecodingResponse<Output, OutputErrors>? {
        
        if let data = data {
            if !isSingleRequest {
                return try data.decodeData() as BaseDecodingResponse<Output, OutputErrors>
            } else {
                let decodedData = try data.decodeData() as Output
                return BaseDecodingResponse<Output, OutputErrors>(message: nil, data: decodedData, status: nil)
            }
        }
        return nil
    }
    
    public static func createRequest(api: BaseAPI) -> URLRequest? {
        
        guard let baseURL = URL(string: api.baseURL + api.version) else { return nil }
        
        let path = api.path
        
        let version = api.version
        
        let urlWithPath = baseURL
            .appendingPathExtension(version)
            .appendingPathComponent(path).absoluteString
        
        var urlComponents = URLComponents(string: urlWithPath)
        
        if !api.queryItems.isEmpty {
            urlComponents?.queryItems = api.queryItems
        }
        
        guard
            let percentRemovedURL = urlComponents?
                .url?
                .absoluteString
                .removingPercentEncoding,
            
            let url = URL(string: percentRemovedURL
                                .correctQueryItems
                                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
                
        else {
            return nil
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = api.method.rawValue
        request.httpBody = api.body
        
        ///For bundles
        ///
        request.allHTTPHeaderFields = NetworkManager.registerDefault(headers: api.headers.items)
        
        return request
    }
    
    public static func registerDefault(headers: HTTPHeaders) -> [String: String] {
        var dict = headers.dictionary
        dict["ClientModel"] = "ios"
        
        dict["Content-Type"] = "application/json"
        dict["Accept"] = "application/json"
        
        dict["ClientVersion"] = Bundle.main.releaseVersionNumber
        
        return dict
    }
    
    
}

public extension NetworkManager {
    func getDateString(with date: Date) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatterGet.string(from: date)
    }
}
