//
//  InstallmentFilter.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 11/05/23.
//

import Foundation
import Combine
import OlchaCore
import OlchaUtils
public class InstallmentFilter: Copying {
    private static let defaultStatuses: [InstallmentStatus] = [.all]
    public required init(instance: InstallmentFilter) {
        self.allStatuses = instance.allStatuses
        self.status = instance.status
        self.statusObserver = instance.statusObserver
        self.installments = instance.installments
    }
    
    private var statusesCompletion: (() -> Void)?
    
    public var installments = PagingData<InstallmentModel>()
    public var allStatuses: [InstallmentStatus] = InstallmentFilter.defaultStatuses
    public var status: InstallmentStatus
    public var statusObserver = PassthroughSubject<Bool, Never>()

    public init(status: InstallmentStatus = .all) {
        self.status = status
    }
    
    public func set(statuses: [InstallmentStatus]?) {
        guard let statuses = statuses else { allStatuses = InstallmentFilter.defaultStatuses; return }
        if allStatuses == InstallmentFilter.defaultStatuses {
            allStatuses = statuses
            statusesUpdated()
        }
    }
    
    public func reset() {
        installments.reset()
    }
    
    public func resetStatuses(status: InstallmentStatus = .all) {
        set(statuses: nil)
        self.status = status
    }
    
    public func getStatuses(completion: (() -> Void)?) {
        self.statusesCompletion = completion
        statusesUpdated()
    }
    
    private func statusesUpdated() {
        print("check equaltiy", allStatuses, InstallmentFilter.defaultStatuses)
        guard allStatuses != InstallmentFilter.defaultStatuses else { return }
        statusesCompletion?()
        statusesCompletion = nil
    }
}

extension InstallmentFilter {
    
}
