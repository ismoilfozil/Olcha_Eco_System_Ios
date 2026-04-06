//
//  LogModel.swift
//  OlchaCore
//
//  Created by Elbek Khasanov on 01/05/23.
//

import Foundation
public struct LogModel {
    var url: String?
    var code: Int?
    var header: String?
    var requestType: String?
    var body: String?
    var response: String?
    var requestTime: String?
    var responseTime: String?
    
    public init(url: String? = nil,
                code: Int? = nil,
                header: String? = nil,
                requestType: String? = nil,
                body: String? = nil,
                response: String? = nil,
                requestTime: String? = nil,
                responseTime: String? = nil
    ) {
        self.url = url
        self.code = code
        self.header = header
        self.requestType = requestType
        self.body = body
        self.response = response
        self.requestTime = requestTime
        self.responseTime = responseTime
    }
}
