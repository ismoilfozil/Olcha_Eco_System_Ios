//
//  HomePageProductsObserver.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 17/11/23.
//

import Combine
import UIKit

enum ScrollType {
    case table
    case collection
}

final class HomePageProductsObserver {
    let updateSegmentedControlObserver = PassthroughSubject<Int, Never>()
    let setViewControllerObserver = PassthroughSubject<(index: Int, direction: UIPageViewController.NavigationDirection), Never>()
    let setupViewControllersObserver = CurrentValueSubject<[HomeSegmentModel], Never>([])
    
    let scrollObserver = CurrentValueSubject<ScrollType, Never>(.table)
    var productHelper: ProductHelper?
    
    let collectionReloader = PassthroughSubject<Bool, Never>()
    
    var homeProductPages: [HomeSegmentModel] = []
    var currentIndex: Int?
}
