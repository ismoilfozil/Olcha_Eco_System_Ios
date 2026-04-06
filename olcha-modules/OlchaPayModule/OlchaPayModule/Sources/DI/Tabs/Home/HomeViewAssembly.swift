//
//  HomeAssembly.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 26/01/23.
//

import Foundation
import Swinject
final class HomeViewAssembly: Assembly {
    func assemble(container: Container) {
        container.register(HomeViewController.self) { r in
            let bankCardsViewModel = r.resolve(BankCardsViewModel.self, name: "shared")!
            let paymentsViewModel = r.resolve(PaymentsViewModel.self, name: "shared")!
            let newsViewModel = r.resolve(NewsViewModel.self)!
            let transactionViewModel = r.resolve(TransactionViewModel.self, name: "shared")!
            let savedTransactionsViewModel = r.resolve(SavedTransactionsViewModel.self, name: "shared")!
            let crudCardViewModel = r.resolve(CrudCardViewModel.self, name: .shared)!
            return HomeViewController(bankCardsViewModel: bankCardsViewModel,
                                      crudCardViewModel: crudCardViewModel,
                                      paymentsViewModel: paymentsViewModel,
                                      transactionViewModel: transactionViewModel,
                                      savedTransactionsViewModel: savedTransactionsViewModel,
                                      newsViewModel: newsViewModel)
        }
        
        container.register(CardsListModalViewController.self) { r in
            let bankCardsViewModel = r.resolve(BankCardsViewModel.self, name: "shared")!
            
            return CardsListModalViewController(viewModel: bankCardsViewModel)
        }
        
        container.register(DetailedNewsViewController.self) { (r, currentIndex: Int, currentPage: Int) in
            let viewModel = r.resolve(NewsViewModel.self)!
            
            return DetailedNewsViewController(viewModel: viewModel,
                                              currentIndex: currentIndex,
                                              currentPage: currentPage)
        }
        
        container.register(NotificationsViewController.self) { r in
            let viewModel = r.resolve(NotificationsViewModel.self)!
            return NotificationsViewController(viewModel: viewModel)
        }
        
        container.register(DetailedNotificationViewController.self) { r in
            let viewModel = r.resolve(NotificationsViewModel.self)!
            return DetailedNotificationViewController(viewModel: viewModel)
        }
        
        container.register(SearchViewController.self) { r in
            let viewModel = r.resolve(SearchViewModel.self)!
            return SearchViewController(viewModel: viewModel)
        }
        
    }
}
