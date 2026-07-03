import OlchaAuth
import OlchaCommon
import OlchaUtils
import OlchaVerification
import Swinject

final class ProfileAssembly: Assembly {

    func assemble(container: Container) {
        container.register(EcoProfileViewController.self) { _ in
            let commonViewModel: CommonViewModel = CommonDIContainer.shared.resolve(argument: Organization.ecoSystem)
//            let loyaltyViewModel: LoyaltyViewModel = CommonDIContainer.shared.resolve()
            let profileViewModel: ProfileViewModel = AuthDIContainer.shared.resolve()
            let verificationViewModel: VerificationViewModel = OlchaVerificationDIContainer.shared.resolve()
            return EcoProfileViewController(commonViewModel: commonViewModel,
                                            profileViewModel: profileViewModel,
                                            verificationViewModel: verificationViewModel)
        }
    }

}
