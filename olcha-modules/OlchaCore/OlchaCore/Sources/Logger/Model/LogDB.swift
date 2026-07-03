
//  LogDB.swift
//  OlchaCore
//
//  Created by Elbek Khasanov on 01/05/23.
//

import Foundation
public class LogDB: @unchecked Sendable {
    public static let shared = LogDB()
    
    public var logsAppended: (() -> Void)?
    private var _logs: [LogModel] = []
    public var logs: [LogModel] {
        get {
            return _logs.sorted(by: { $0.requestTime ?? "" > $1.requestTime ?? "" })
        }
        
        set {
            _logs = newValue
            logsAppended?()
        }
    }
    
}
