import Swinject
import OlchaNasiyaModule
import OlchaPayModule
import OlchaCommon
import OlchaUtils

final class HomeAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(EcoHomeViewModel.self) { r in
            let loadBuildersUseCase = r.resolve(LoadBuildersUseCaseProtocol.self)!
            let loadBalanceUseCase = r.resolve(LoadBalanceUseCaseProtocol.self)!
            let loadBonusBalanceUseCase = r.resolve(LoadBonusBalanceUseCaseProtocol.self)!
            return EcoHomeViewModel(
                loadBuildersUseCase: loadBuildersUseCase,
                loadBalanceUseCase: loadBalanceUseCase,
                loadBonusBalanceUseCase: loadBonusBalanceUseCase
            )
        }
        
        container.register(EcoHomeViewController.self) { r in
            let nasiyaHomeViewModel: NasiyaHomeViewModel = NasiyaDIContainer.shared.resolve()
            let payBankCardsViewModel: BankCardsViewModel = PayDIContainer.shared.resolve()
            let commonViewModel: CommonViewModel = CommonDIContainer.shared.resolve(argument: Organization.ecoSystem)
            let viewModel = r.resolve(EcoHomeViewModel.self)!
            let loyaltyViewModel: LoyaltyViewModel = CommonDIContainer.shared.resolve()
            return EcoHomeViewController(
                viewModel: viewModel,
                nasiyaViewModel: nasiyaHomeViewModel,
                payBankCardsViewModel: payBankCardsViewModel,
                commonViewModel: commonViewModel, 
                loyaltyViewModel: loyaltyViewModel
            )
        }
    }
    
}
