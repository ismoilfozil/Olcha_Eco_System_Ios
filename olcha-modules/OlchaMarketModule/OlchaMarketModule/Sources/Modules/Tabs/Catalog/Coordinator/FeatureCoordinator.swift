//
//  FeatureCoordinator.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 12/07/22.
//

import UIKit
import BonsaiController
import OlchaUI
public protocol FeatureCoordinatorProtocol: Coordinator {
    func pushAllFeaturesList(with filters: ProductListFilters?, index: Int)
    func pushAllManufacturersList(with filters: ProductListFilters?)
    func pushAllTagsList(with filters: ProductListFilters?)
    
    
    func pushFeaturesPage(with filters: ProductListFilters?)
    func presentFeaturesFilterModal(with filters: ProductListFilters?, index: Int)
    func presentPriceFilterModal(with filters: ProductListFilters?)
    func presentManufacturersFilterModal(with filters: ProductListFilters?)
    
    func presentHistoricalDismissedViewController()
    func popViewController()
    func dismissViewController()
}
public class FeatureCoordinator: OlchaMainCoordinator, FeatureCoordinatorProtocol {
    
    var dismissedViewController: UIViewController?
    
    public override func start() {}
    
    public func pushFeaturesPage(with filters: ProductListFilters?) {
        let vc = FeaturesPage()
        vc.coordinator = self
        vc.filters = filters
        navigationController.push(vc)
    }
    
    
    
    public func pushAllFeaturesList(with filters: ProductListFilters?, index: Int) {
        dismissPresentedViewController()
        let vc = SelectableFiltersPage()
        vc.coordinator = self
        vc.section = .features(index: index)
        vc.filters = filters
        navigationController.push(vc)
    }
    
    
    
    public func pushAllManufacturersList(with filters: ProductListFilters?) {
        dismissPresentedViewController()
        let vc = SelectableFiltersPage()
        vc.coordinator = self
        vc.section = .brands
        vc.filters = filters
        navigationController.push(vc)
    }
    
    public func pushAllTagsList(with filters: ProductListFilters?) {
        dismissPresentedViewController()
        let vc = SelectableFiltersPage()
        vc.coordinator = self
        vc.section = .tags
        vc.filters = filters
        navigationController.push(vc)
    }
    
    public func presentFeaturesFilterModal(with filters: ProductListFilters?, index: Int) {
        let vc = FeatureModalPage()
        
        vc.section = .features(index: index)
        vc.filters = filters
        vc.coordinator = self
        vc.isPriceFilter = false
        navigationController.presentModally(vc)
    }
    
    public func presentManufacturersFilterModal(with filters: ProductListFilters?) {
        let vc = FeatureModalPage()
        vc.filters = filters
        vc.section = .brands
        vc.coordinator = self
        vc.isPriceFilter = false
        
        navigationController.presentModally(vc)
    }
    
    public func presentPriceFilterModal(with filters: ProductListFilters?) {
        let vc = FeatureModalPage()
        vc.filters = filters
        vc.coordinator = self
        vc.isPriceFilter = true
        navigationController.presentModally(vc)
    }
    
    public func popViewController() {
        navigationController.pop()
    }
    
    public func dismissViewController() {
        navigationController.dismiss()
    }
    
    public func dismissPresentedViewController() {
        if navigationController.presentedViewController is ModalPageType {
            self.dismissedViewController = navigationController.presentedViewController
            dismissViewController()
        }
    }
    
    public func presentHistoricalDismissedViewController() {
        
        if let vc = self.dismissedViewController {
            navigationController.presentModally(vc)
            self.dismissedViewController = nil
        }
    }
}
