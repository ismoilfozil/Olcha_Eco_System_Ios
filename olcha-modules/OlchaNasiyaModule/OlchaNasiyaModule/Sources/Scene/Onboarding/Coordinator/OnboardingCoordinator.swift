////
////  OnboardingCoordinator.swift
////  OlchaNasiyaModule
////
////  Created by Elbek Khasanov on 27/07/23.
////
//
//import UIKit
//import OlchaUI
//public protocol OnboardingCoordinatorProtocol: Coordinator {
//    var completion: (() -> Void)? { get set }
//    func pushSplashOnboarding()
//    func pushSliderOnboarding()
//    func finishOnboarding()
//}
//
//public class OnboardingCoordinator: OnboardingCoordinatorProtocol {
//    
//    public var navigationController: UINavigationController
//    
//    public var completion: (() -> Void)?
//    
//    public init(navigationController: UINavigationController) {
//        self.navigationController = navigationController
//    }
//    
//    public func start() {
//        pushSplashOnboarding()
//    }
//    
//    public func pushSplashOnboarding() {
//        let vc: LanguageOnboardingViewController = NasiyaDIContainer.shared.resolve()
//        vc.coordinator = self
//        vc.completion = { [weak self] in
//            guard let self = self else { return }
//            pushSliderOnboarding()
//        }
//        navigationController.set([vc])
//    }
//    
//    public func pushSliderOnboarding() {
//        let vc: OnboardingViewController = NasiyaDIContainer.shared.resolve()
//        vc.coordinator = self
//        navigationController.set([vc])
//    }
//    
//    public func finishOnboarding() {
//        completion?()
//    }
//}
