//
//  Logger.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 19/01/23.
//

import Foundation
import SwiftyJSON
func log(funcName: String , api : String, data: Data?, body: Data? = nil) {
    print(".My-Log                ")
    do {
        if let data = data {
            if let body = body {
                try print("function name: \(funcName);",
                          "\napi: \(api);",
                          "\nrequest body: \(JSON(data: body))",
                          "\nresponse data: \(JSON(data: data))")
            } else {
                try print("function name: \(funcName);",
                          "\napi: \(api);",
                          "\nresponse data: \(JSON(data: data))")
            }
            
        } else {
            try? print("function name: \(funcName);",
                       "\napi: \(api);",
                       "\nrequest: \(JSON(data: body ?? Data()))")
        }
    } catch {
        try? print("function name: \(funcName);",
                   "\napi: \(api);",
                   "\nbody: \(JSON(body ?? Data()))",
                   "\ndata: \(JSON(data ?? Data()))",
                   "\nerror:\(error.asAFError?.errorDescription)")
    }
    print(".                             ")
}

func decodelog(api: String, error: Error?, data: Data?) {
    print(".Decoded with error ⛔⛔⛔⛔⛔⛔⛔⛔                ")
    print("function name: \(api);\n\n\n\n error:\n\n\n\n\(error)\n\n\n\n\(JSON(data ?? Data()))\n\n\n\n")
    print(".⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔                         ")
    FirebaseLogger.decodelog(url: api, data: data, message: "\(error)")
}

func faillog(api: String, error: Error?) {
    print(".Failed with error ⛔⛔⛔⛔⛔⛔⛔⛔                ")
    print("function name: \(api);\n\n\n\n error:\n\n\n\n\(error)\n\n\n\n")
    print(".⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔                         ")
}

func log(funcName: String , api : String, params: [String : Any], data: Data?) {
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


