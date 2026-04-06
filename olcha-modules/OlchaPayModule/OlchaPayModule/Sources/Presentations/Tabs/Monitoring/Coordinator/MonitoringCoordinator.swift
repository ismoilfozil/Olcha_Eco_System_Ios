//
//  MonitoringCoordinator.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 28/03/23.
//

import UIKit
import Combine
import OlchaUI
public protocol MonitoringCoordinatorProtocol: Coordinator {
    func pushPaymentDetail(transaction: TransactionModel?)
    func presentMonitoringFilter(acceptObserver: PassthroughSubject<TransactionsFilters, Never>?,
                                 bankCard: UserBankCardModel?,
                                 features: TransactionsFeatures?,
                                 filters: TransactionsFilters)
    
    func pushCardMonitoring(bankCard: UserBankCardModel?)
}

public class MonitoringCoordinator: PayMainCoordinator, MonitoringCoordinatorProtocol {
    
    
    public override func start() {
        let vc: MonitoringViewController = PayDIContainer.shared.resolve()
        vc.coordinator = self
        navigationController.set([vc])
    }
    
    public func pushPaymentDetail(transaction: TransactionModel?) {
        paymentsCoordinator.pushTransactionDetail(transaction: transaction)
    }
    
    public func presentMonitoringFilter(acceptObserver: PassthroughSubject<TransactionsFilters, Never>?,
                                        bankCard: UserBankCardModel?,
                                        features: TransactionsFeatures?,
                                        filters: TransactionsFilters) {
        let vc: MonitoringFilterViewController = PayDIContainer.shared.resolve()
        vc.acceptObserver = acceptObserver
        vc.filters = filters
        vc.features = features
        vc.bankCard = bankCard
        vc.coordinator = self
        vc.setupFilters()
        navigationController.presentModally(vc)
    }
    
    public func pushCardMonitoring(bankCard: UserBankCardModel?) {
        let vc: MonitoringViewController = PayDIContainer.shared.resolve()
        vc.coordinator = self
        vc.card = bankCard
        vc.initialType = .card
        navigationController.push(vc)
    }
}
