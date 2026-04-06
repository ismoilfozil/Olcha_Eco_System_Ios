//
//  PaymentAssembly.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 24/02/23.
//

import Foundation
import Swinject
final class PaymentsViewAssembly: Assembly {
    func assemble(container: Container) {
        
        container.register(ProvidersListViewController.self) { r in
            let viewModel = r.resolve(PaymentsViewModel.self)!
            return ProvidersListViewController(viewModel: viewModel)
        }
        
        container.register(ServicesListViewController.self) { r in
            let viewModel = r.resolve(PaymentsViewModel.self)!
            return ServicesListViewController(viewModel: viewModel)
        }
        
        container.register(DetailedTransactionViewController.self) { r in
            let transactionViewModel = r.resolve(TransactionViewModel.self, name: .shared)!
            let makeTransactionViewModel = r.resolve(MakeTransactionViewModel.self)!
            return DetailedTransactionViewController(
                makeTransactionViewModel: makeTransactionViewModel,
                transactionViewModel: transactionViewModel
            )
        }
        
        container.register(PaymentsGroupViewController.self) { r in
            return PaymentsGroupViewController()
        }
        
        container.register(PaymentViewController.self) { r in
            let bankCardsViewModel = r.resolve(BankCardsViewModel.self, name: .shared)!
            let makeTransactionViewModel = r.resolve(MakeTransactionViewModel.self)!
            let paymentsViewModel = r.resolve(PaymentsViewModel.self)!
            return PaymentViewController(bankCardsViewModel: bankCardsViewModel,
                                         makeTransactionViewModel: makeTransactionViewModel,
                                         paymentsViewModel: paymentsViewModel)
        }
        
        container.register(PhonePaymentViewController.self) { r in
            let bankCardsViewModel = r.resolve(BankCardsViewModel.self, name: .shared)!
            let makeTransactionViewModel = r.resolve(MakeTransactionViewModel.self)!
            let paymentsViewModel = r.resolve(PaymentsViewModel.self)!
            return PhonePaymentViewController(bankCardsViewModel: bankCardsViewModel,
                                              makeTransactionViewModel: makeTransactionViewModel,
                                              paymentsViewModel: paymentsViewModel)
        }
        
        container.register(PaymentOtpViewController.self) { r in
            let transactionViewModel = r.resolve(TransactionViewModel.self, name: .shared)!
            let bankCardsViewModel = r.resolve(BankCardsViewModel.self, name: .shared)!
            let makeTransactionViewModel = r.resolve(MakeTransactionViewModel.self)!
            return PaymentOtpViewController(transactionViewModel: transactionViewModel,
                                            makeTransactionViewModel: makeTransactionViewModel,
                                            bankCardsViewModel: bankCardsViewModel)
        }
        
        container.register(PaymentFinishViewController.self) { r in
            let transactionViewModel = r.resolve(TransactionViewModel.self, name: .shared)!
            let makeTransactionViewModel = r.resolve(MakeTransactionViewModel.self)!
            return PaymentFinishViewController(
                transactionViewModel: transactionViewModel,
                makeTransactionViewModel: makeTransactionViewModel
            )
        }
        
        container.register(SaveTransactionViewController.self) { r in
            let viewModel = r.resolve(SavedTransactionsViewModel.self, name: "shared")!
            return SaveTransactionViewController(viewModel: viewModel)
        }
        
        container.register(EditTransactionViewController.self) { r in
            let viewModel = r.resolve(SavedTransactionsViewModel.self, name: "shared")!
            return EditTransactionViewController(viewModel: viewModel)
        }
        
        container.register(PDFinvoiceViewController.self) { (r, transaction: TransactionModel?) in
            return PDFinvoiceViewController(transaction: transaction)
        }
        
        container.register(SaveTransactionFinishViewController.self) { r in
            return SaveTransactionFinishViewController()
        }
        
        container.register(QRCameraViewController.self) { r in
            return QRCameraViewController()
        }
        
        container.register(QRPaymentModalViewController.self) { r in
            return QRPaymentModalViewController()
        }
        
        container.register(CategoriesViewController.self) { r in
            let viewModel = r.resolve(PaymentsViewModel.self, name: "shared")!
            return CategoriesViewController(viewModel: viewModel)
        }
        
    }
}
