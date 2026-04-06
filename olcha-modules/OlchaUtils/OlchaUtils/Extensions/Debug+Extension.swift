//
//  Debug+Extension.swift
//  OlchaUtils
//
//  Created by Elbek Khasanov on 21/11/23.
//

import Foundation

public enum AppConfiguration {
    case debug
    case testFlight
    case appStore
}

public struct Config {
    private static var isTestFlight: Bool {
        Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"
    }
    
    public static var isDebug: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    public static var isTestFlightOrDebug: Bool {
        isTestFlight || isDebug
    }
    
    public static var appConfiguration: AppConfiguration {
        isDebug ? .debug : isTestFlight ? .testFlight : .appStore
    }
}
