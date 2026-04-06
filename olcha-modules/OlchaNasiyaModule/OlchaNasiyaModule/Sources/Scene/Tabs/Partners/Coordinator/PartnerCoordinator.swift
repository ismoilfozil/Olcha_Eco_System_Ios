//
//  PartnerCoordinator.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 18/05/23.
//

import OlchaUI
import UIKit
public protocol PartnerCoordinatorProtocol: Coordinator {
    func presentFilters(filters: [PartnersFilterModel], completion: ((PartnersFilterModel?) -> Void)?)
    func pushPartnerInfo(partner: PartnerModel?)
    func presentMenu()
}

public class PartnerCoordinator: NasiyaMainCoordinator, PartnerCoordinatorProtocol {
    
    public override func start() {
        let vc: PartnersViewController = NasiyaDIContainer.shared.resolve()
        vc.coordinator = self
        navigationController.set([vc])
    }
    
    public func presentFilters(filters: [PartnersFilterModel], completion: ((PartnersFilterModel?) -> Void)?) {
        let vc: PartnersFilterViewController = NasiyaDIContainer.shared.resolve()
        vc.coordinator = self
        vc.input.models = filters
        vc.completion = completion
        vc.fillData()
        navigationController.presentModally(vc)
    }
    
    public func pushPartnerInfo(partner: PartnerModel?) {
        let vc: PartnerInfoViewController = NasiyaDIContainer.shared.resolve()
        vc.coordinator = self
        vc.input.partnerModel = partner
        navigationController.push(vc)
    }
    
    public func presentMenu() {
        menuCoordinator.start()
    }
}
