//
//  BaseNetworkOptions.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 29/06/22.
//

import Foundation
import Alamofire

///
/// - ``BaseAPI`` - is protocol to make request. You have to implement it. NetworkManager.request func waits `BaseApi` protocol
///
public protocol BaseAPI {
    var baseURL: String { get }
    var version: String { get }
    var path: String { get }
    var method: RequestType { get }
    var headers: ApiHeader { get }
    var body: Data? { get }
    var params: [String: String] { get }
    var queryItems: [URLQueryItem] { get }
    
    func encode<T: Codable>(_ model: T) -> Data?
}

extension BaseAPI {
    public func encode<T: Codable>(_ model: T) -> Data? {
        var data: Data?
        do {
            data = try JSONEncoder().encode(model)
        } catch {}
        return data
    }
}

public enum RequestType: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
}

open class BaseSetterAPI: BaseAPI {
    private var _baseURL: String = ""
    public var baseURL: String {
        get {
            return _baseURL
        }
        
        set {
            _baseURL = newValue
        }
    }
    
    private var _version: String = ""
    public var version: String {
        get {
            return _version
        }
        
        set {
            _version = newValue
        }
    }
    
    private var _path: String = ""
    public var path: String {
        get {
            return _path
        }
        
        set {
            _path = newValue
        }
    }
    
    private var _method: RequestType = .get
    public var method: RequestType {
        get {
            return _method
        }
        
        set {
            _method = newValue
        }
    }
    
    private var _headers: ApiHeader = BaseHeader.shared
    public var headers: ApiHeader {
        get {
            return _headers
        }
        
        set {
            _headers = newValue
        }
    }
    
    private var _body: Data? = nil
    public var body: Data? {
        get {
            return _body
        }
        
        set {
            _body = newValue
        }
    }
    
    private var _params: [String : String] = [:]
    public var params: [String : String] {
        get {
            return _params
        }
        
        set {
            _params = newValue
        }
    }
    
    private var _queryItems: [URLQueryItem] = []
    public var queryItems: [URLQueryItem] {
        get {
            return _queryItems
        }
        
        set {
            _queryItems = newValue
        }
    }
    
    public init(
        path: String,
        version: String,
        method: RequestType,
        queryItems: [URLQueryItem],
        body: Codable? = nil,
        params: [String : String],
        headers: ApiHeader,
        baseURL: String
    ) {
        self.baseURL = baseURL
        self.version = version
        self.path = path
        self.method = method
        self.headers = headers
        if let body {
            self.body = encode(body)
        }
        self.params = params
        self.queryItems = queryItems
    }
    
    public init() {}
}

