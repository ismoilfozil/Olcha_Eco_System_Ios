//
//  Logger.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 19/01/23.
//

import Foundation
import SwiftyJSON
import Alamofire
public func log(funcName: String , api : String, data: Data?, body: Data? = nil) {
    print(".My-Log🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀")
    do {
        
        try print("function name: \(funcName);",
                  "\napi: \(api);",
                  "\nrequest body: \(JSON(data: body ?? Data()))",
                  "\nresponse data: \(JSON(data: data ?? Data()))")
        
    } catch {
        try print("function name: \(funcName);",
                  "\napi: \(api);",
                  "\nbody: \(JSON(body ?? Data()))",
                  "\ndata: \(JSON(data ?? Data()))",
                  "\nerror:\(error.asAFError?.errorDescription)")
    }
    print(".                             ")
}

public func decodelog(api: String, error: Error?, data: Data?) {
    print(".Decoded with network_error ⛔⛔⛔⛔⛔⛔⛔⛔                ")
    print("function name: \(api);\n\n\n\n error:\n\n\n\n\(error)\n\n\n\n\(JSON(data ?? Data()))\n\n\n\n")
    print(".⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔                         ")
}

public func faillog(api: String, error: Error?) {
    print(".Failed with network_error ⛔⛔⛔⛔⛔⛔⛔⛔                ")
    print("function name: \(api);\n\n\n\n error:\n\n\n\n\(error)\n\n\n\n")
    print(".⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔                         ")
}

public func log(funcName: String , api : String, params: [String : Any], data: Data?) {
    print(".My-Log                   ")
    do {
        if let data = data {
            try print("function name: \(funcName);\napi: \(api);\nparams:\(params);\nresponse: \(JSON(data: data))")
        } else {
            try ("function name: \(funcName);\napi: \(api);\nparams:\(params);\nresponse elseda: \(data)")
        }
    } catch {
        print("function name: \(funcName);\napi: \(api);\nparams:\(params);\n")
    }
    print(".                             ")
}


