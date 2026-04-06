//
//  StreetMapNetworking.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 09/09/22.
//

import Foundation
import OlchaCore
enum StreetMapAPI: OlchaMarketAPI {
    case search(String)
    case loadName(latitude: Double, longitude: Double)
}

extension StreetMapAPI {
    var baseURL: String {
        return "https://nominatim.openstreetmap.org/"
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .search(let string):
            return [
                .init(name: "q", value: "\(string)"),
                .init(name: "dedupe", value: "0"),
                .init(name: "countrycodes", value: "uz"),
                .init(name: "format", value: "jsonv2")
            ]
        case .loadName(let latitude, let longitude):
            
            var lang = String.getAppLanguage()
            if lang == "oz" {
                lang = "uz"
            }
            
            return [
                .init(name: "accept-language", value: lang),
                .init(name: "lat=", value: "\(latitude)"),
                .init(name: "lon=", value: "\(longitude)"),
                .init(name: "countrycodes", value: "uz"),
                .init(name: "format", value: "json")
            ]
        }
    }
    
    var path: String {
        switch self {
        case .search:
            return "search.php"
        case .loadName:
            return "reverse"
        }
    }
    
    var method: RequestType {
        return .get
    }
    
    var body: Data? {
        return nil
    }
    
    var headers: ApiHeader {
        return OlchaMarketEmptyHeader.shared
    }
    
}
