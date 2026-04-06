//
//  CardsAssembly.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 24/02/23.
//

import Foundation
import Swinject
final class CardsAssembly: Assembly {
    func assemble(container: Container) {
        
        container.register(MainCardsViewController.self) { r in
            let bankCardsViewModel = r.resolve(BankCardsViewModel.self, name: .shared)!
            let crudCardViewModel = r.resolve(CrudCardViewModel.self, name: .shared)!
            return MainCardsViewController(
                bankCardsViewModel: bankCardsViewModel,
                crudCardViewModel: crudCardViewModel
            )
            
        }
        
        container.register(CardColorModalViewController.self) { r in
            return CardColorModalViewController()
        }
        
        container.register(CardNameModalViewController.self) { r in
            return CardNameModalViewController()
        }
        
        container.register(AddCardViewController.self) { r in
            let viewModel = r.resolve(CrudCardViewModel.self, name: .shared)!
            return AddCardViewController(viewModel: viewModel)
        }
        
        container.register(AddCardVerifyViewController.self) { r in
            let viewModel = r.resolve(CrudCardViewModel.self, name: .shared)!
            
            return AddCardVerifyViewController(viewModel: viewModel)
        }

        container.register(AddCardFinishViewController.self) { r in
            return AddCardFinishViewController()
        }
        
    }
}
