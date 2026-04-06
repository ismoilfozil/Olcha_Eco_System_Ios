//
//  ReviewsAssembly.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 14/11/23.
//

import Swinject
import OlchaUtils
final class ReviewsAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(MyReviewsPage.self) { r in
            MyReviewsPage()
        }
    }
}
