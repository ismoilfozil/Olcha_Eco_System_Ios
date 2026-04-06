//
//  UploadAPI.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 02/08/22.
//

import Foundation
import OlchaCore
enum UploadAPI: OlchaMarketAPI {
    case image(data: Data)
    case video(data: Data)

}

extension UploadAPI {
    
    var path: String {
        return "files"
    }
    
    var method: RequestType {
        return .post
    }
    
    var body: Data? {
        switch self {
        case .image(let data):
            return data
        case .video(let data):
            return data
        }
    }
}
