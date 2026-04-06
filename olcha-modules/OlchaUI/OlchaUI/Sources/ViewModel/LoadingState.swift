//
//  LoadingState.swift
//  OlchaCore
//
//  Created by Elbek Khasanov on 23/01/23.
//

import Combine
import OlchaCore
// MARK: - State
public enum LoadingState<Value, ErrorType>: Equatable {
    public static func == (lhs: LoadingState<Value, ErrorType>, rhs: LoadingState<Value, ErrorType>) -> Bool {
        switch (lhs, rhs) {
        case (.standart, .standart):
            return true
        case (.loading, .loading):
            return true
        case (.success(_), .success(_)):
            return true
        case (.failure(_), .failure(_)):
            return true
        default:
            return false
        }
    }
    
    
    case standart
    case loading
    case success(Value?)
    case failure(ErrorType?)
    
}

public extension LoadingState {
    var value: Value? {
        guard case let .success(value) = self else { return nil }
        return value
    }
}
