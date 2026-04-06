//
//  OlchaBankCardsViewAssembly.swift
//  OlchaBankCards
//
//  Created by Elbek Khasanov on 22/05/23.
//


import Foundation
import Swinject
final class ViewAssembly: Assembly {
    public func assemble(container: Container) {


        container.register(AddCardModalPage.self) { (r, name: String?) in
            let viewModel = r.resolve(BankCardViewModel.self, argument: name)!
            return MainActor.assumeIsolated { AddCardModalPage(viewModel: viewModel) }
        }

    }
}
