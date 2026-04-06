//
//  SessionManager.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 18/11/22.
//

// MARK: Request configuration
import Foundation
import Alamofire

public class SessionManager {
    
    var interceptor: RequestInterceptor?
    
    public init(interceptor: RequestInterceptor) {
        self.interceptor = interceptor
    }
    
    public lazy var session: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 30
        configuration.waitsForConnectivity = true
        return Session(
            configuration: configuration,
            interceptor: interceptor
        )
    }()
}
