import Swinject

final class OrderConfirmationAssembly: Assembly {

    func assemble(container: Container) {
        container.register(EcoOrderConfirmationViewModel.self) { (r, userId: Int) in
            let barcodeRepository = r.resolve(BarcodeRepositoryProtocol.self)!
            return EcoOrderConfirmationViewModel(barcodeRepository: barcodeRepository, userId: userId)
        }

        container.register(EcoOrderConfirmationViewController.self) { r in
            let viewModel = r.resolve(EcoOrderConfirmationViewModel.self)
            return EcoOrderConfirmationViewController(viewModel: viewModel)
        }
    }

}
