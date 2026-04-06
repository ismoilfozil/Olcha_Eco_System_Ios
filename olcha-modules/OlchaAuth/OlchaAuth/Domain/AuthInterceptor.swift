//
//  AuthInterceptor.swift
//  OlchaAuth
//
//  Created by Elbek Khasanov on 12/04/23.
//

import Foundation
import Alamofire
import SwiftyJSON
import OlchaCore


// MARK: - Request Interceptor
public class AuthInterceptor: RequestInterceptor {
    private typealias RefreshCompletion = ((Alamofire.RetryResult) -> Void)

    // MARK: - Config
    private var isRefreshing = false
    private var requestsToRetry: [RefreshCompletion] = []
    
    public init() {}
    
    let observer = RefreshAuthObserver.shared
    
    let retryLimit = 5
    // MARK: - ADAPT
    public func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest
        request.setValue(AuthGlobalDefaults.getToken(), forHTTPHeaderField: "Authorization")
        completion(.success(request))
    }
    
    // MARK: - RETRY
    public func retry(_ request: Alamofire.Request, for session: Alamofire.Session, dueTo error: Error, completion: @escaping (Alamofire.RetryResult) -> Void) {
        
        LogDB.shared.logs.append(
            LogModel(url: request.request?.url?.absoluteString,
                     code: request.response?.statusCode,
                     header: "\(request.request?.headers)",
                     requestType: request.request?.httpMethod,
                     body: "\(JSON(request.request?.httpBody))",
                     response: "\(JSON(request.response))")
        )
        
        guard let code = request.response?.statusCode,
              code == .authError
              else {
                  completion(.doNotRetryWithError(error))
                  return
              }
        
        guard let refresh = AuthGlobalDefaults.refresh_token, refresh != "" else {
            AuthGlobalDefaults.logout()
            completion(.doNotRetry)
            requestsToRetry.removeAll()
            return
        }

        requestsToRetry.append(completion)

        guard request.retryCount < retryLimit else {
            completion(.doNotRetry)
            requestsToRetry.removeAll()
            return
        }
        
        guard let refreshRequest = createAuthRequest() else { return }
        
        guard isRefreshing == false else { return }
        isRefreshing = true
        makeRefreshRequest(refreshRequest: refreshRequest, firedRequest: request)
        
    }
    
    private func createAuthRequest() -> URLRequest? {
        let authApi: AuthAPIProtocol = AuthType.authApi
        let api = authApi.refreshAuth()
        return NetworkManager.createRequest(api: api)
    }
 
    private func makeRefreshRequest(refreshRequest: URLRequest, firedRequest: Alamofire.Request) {
        
        AF.request(refreshRequest).response { [weak self] response in
            guard let self = self else { return }
            let loginModel = AuthType.getLoginModel(data: response.data)
            
            print(response.request?.url?.absoluteString, response.value)
            LogDB.shared.logs.append(
                LogModel(url: refreshRequest.url?.absoluteString,
                         code: response.response?.statusCode,
                         header: "\(response.request?.headers)",
                         requestType: refreshRequest.httpMethod,
                         body: "\(JSON(response.request?.httpBody))",
                         response: "\(JSON(response.data))")
            )
            
            let access_token = loginModel?.access_token
            let refresh_token = loginModel?.refresh_token
            
            AuthGlobalDefaults.access_token = access_token
            AuthGlobalDefaults.refresh_token = refresh_token
            
            if access_token != nil && refresh_token != nil {
                AuthGlobalDefaults.client_type = AuthTexts.refresh_token
            } else {
                AuthGlobalDefaults.client_type = AuthTexts.client_credentials
            }

            self.isRefreshing = false
            
            if isRefreshAuthError(response.response) {
                self.observer.refreshExpireObserver.send {
                    self.retryAllRequests()
                }
            } else {
                self.retryAllRequests()
            }
        }
    }
    
    private func retryAllRequests() {
        requestsToRetry.forEach { $0(.retry) }
        requestsToRetry.removeAll()
    }
    
    private func isRefreshAuthError(_ response: HTTPURLResponse?) -> Bool {
        (response?.statusCode == .authError)
    }
}

///
/// - USER TYPE
/// - ``1-step`` -> check access_token
/// - ``2-step`` -> if access_token returns 401, try to get refresh token
/// - ``3-step`` -> if refresh_token returns 401, change user type -> guest type
///
/// - GUEST TYPE
/// - ``1-step`` -> check access_token
/// - ``2-step`` -> if access_token returns 401, get new access_token
///

public class Interc: RequestInterceptor {
    
}
