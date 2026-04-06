//
//  PartnerViewAssembly.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 18/05/23.
//

import Foundation
import Swinject

final class PartnerViewAssembly: Assembly {
    func assemble(container: Container) {
        container.register(PartnersViewController.self) { r in
            let viewModel = r.resolve(PartnerViewModel.self)!
            return PartnersViewController(viewModel: viewModel)
        }
        
        container.register(PartnersFilterViewController.self) { r in
            return PartnersFilterViewController()
        }
        
        container.register(PartnerInfoViewController.self) { r in
            let viewModel = r.resolve(PartnerViewModel.self)!
            return PartnerInfoViewController(viewModel: viewModel)
        }
    }
}
