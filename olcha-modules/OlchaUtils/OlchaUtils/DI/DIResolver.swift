//
//  DIResolver.swift
//  OlchaUtils
//
//  Created by Elbek Khasanov on 03/05/23.
//
import Swinject
import Foundation

extension String {
    public static let shared = "shared"
    public static let core = "core"
}

open class DIResolver: @unchecked Sendable {
    
    public let container: Container
    public let assembler: Assembler
    
    public init() {
        self.container = Container()
        self.assembler = Assembler([], container: self.container)
    }
    

    public func resolve<T>() -> T {
        var argument: String?
        if let resolvedType = container.resolve(T.self, argument: (argument as? String)) {
            return resolvedType
        } else if let resolvedType = container.resolve(T.self) {
            return resolvedType
        }
        
        fatalError()
    }

    public func resolve<T>(name: String?) -> T {
        guard let resolvedType = container.resolve(T.self, name: name) else {
            fatalError()
        }
        return resolvedType
    }

    public func resolve<T, Arg>(argument: Arg) -> T {
        guard let resolvedType = container.resolve(T.self, argument: argument) else {
            fatalError()
        }
        return resolvedType
    }

    public func resolve<T, Arg1, Arg2>(arguments arg1: Arg1, _ arg2: Arg2) -> T {
        guard let resolvedType = container.resolve(T.self, arguments: arg1, arg2) else {
            fatalError()
        }
        return resolvedType
    }

    public func resolve<T, Arg>(name: String?, argument: Arg) -> T {
        guard let resolvedType = container.resolve(T.self, name: name, argument: argument) else {
            fatalError()
        }
        return resolvedType
    }

    public func resolve<T, Arg1, Arg2>(name: String?, arguments arg1: Arg1, _ arg2: Arg2) -> T {
        guard let resolvedType = container.resolve(T.self, name: name, arguments: arg1, arg2) else {
            fatalError()
        }
        return resolvedType
    }

}
