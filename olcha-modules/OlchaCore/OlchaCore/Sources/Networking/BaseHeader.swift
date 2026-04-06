//
//  BaseHeader.swift
//  OlchaCore
//
//  Created by Elbek Khasanov on 24/01/23.
//

import Foundation
import Alamofire

public protocol ApiHeader: AnyObject {
    var items: HTTPHeaders { get set }
}

public class BaseHeader: ApiHeader {
    public var items: HTTPHeaders
    
    init(items: HTTPHeaders) {
        self.items = items
    }
    
    static var shared : BaseHeader {
        
        let items: HTTPHeaders = [
        ]
        
        let baseHeader = BaseHeader(items: items)
        return baseHeader
    }
    
}


