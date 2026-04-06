//
//  BillingCache.swift
//  OlchaBilling
//
//  Created by Elbek Khasanov on 11/07/23.
//

import Foundation
import Combine
import OlchaCore

public class BillingCache {
    public static let shared = BillingCache()
    
    public init() {}
    
    private var cache: [String: BillingPaymentsData] = [:]
    
    public func set(key: String, data: BillingPaymentsData?) {
        print("cache ---- set")
        print(".                                                                .")
        print(".                                                                .")
        print(".                                                                .")
        print(".                                                                .")
        print(data?.payment_systems)
        print(".                                                                .")
        print(".                                                                .")
        print(".                                                                .")
        print(".                                                                .")
        print("cache ---- set")
        return cache[key] = data
    }
    
    public func isExist(key: String) -> Bool {
        print("cache ---- exist?", key, cache[key] != nil)
        print(".                                                                .")
        print(".                                                                .")
        print(".                                                                .")
        print(".                                                                .")
        print(cache[key] != nil)
        print(".                                                                .")
        print(".                                                                .")
        print(".                                                                .")
        print(".                                                                .")
        print("cache ---- exist?")
        return (cache[key] != nil)
    }
    
    public func get(with key: String) -> BillingPaymentsData? {
        print("cache ---- get")
        print(".                                                                .")
        print(".                                                                .")
        print(".                                                                .")
        print(".                                                                .")
        print(cache[key])
        print(".                                                                .")
        print(".                                                                .")
        print(".                                                                .")
        print(".                                                                .")
        print("cache ---- get")
        return cache[key]
    }
    
    public func get(with key: String) -> AnyPublisher<BaseResponse<BillingPaymentsData, EmptyData>, Never> {
        return Future { [weak self] promise in
            guard let self = self else { return }
            promise(
                .success(
                    BaseResponse(status: .success, response: self.get(with: key))
                )
            )
        }.eraseToAnyPublisher()
    }
    
}
