//
//  HomeProductPageControlRoom.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 16/11/23.
//

import UIKit
import OlchaUI
import Combine

class HomeProductPageControlRoom: BaseTableCell {
    
    private var bag = Set<AnyCancellable>()
    fileprivate var pages: [HomeSegmentModel] = []
    fileprivate var viewControllers: [UIViewController] = []
    
    lazy var pageViewController: UIPageViewController = {
        let pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageVC.delegate = self
        pageVC.dataSource = self
        return pageVC
    }()
    
    fileprivate var currentPageIndex = 0
    
    weak var observer: HomePageProductsObserver? {
        didSet {
            setupObservers()
        }
    }
    
    override func setupViews() {
        container.addSubview(pageViewController.view)
    }
    
    override func autolayout() {
        pageViewController.view.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
    
    private func setupObservers() {
        
        observer?.setViewControllerObserver.sink(receiveValue: { [weak self] (index, direction) in
            guard let self, viewControllers.isGreater(index) else { return }
            DispatchQueue.main.async {
                self.currentPageIndex = index
                self.pageViewController.setViewControllers([self.viewControllers[index]],
                                                           direction: direction,
                                                           animated: false)
            }
        }).store(in: &bag)
        
        observer?.setupViewControllersObserver.sink { [weak self] pages in
            guard let self else { return }
            setupPages(pages)
        }.store(in: &bag)
        
    }
    
    private func setupPages(_ models: [HomeSegmentModel]) {
        
        guard models != pages || models.isEmpty else { return }
        
        self.pages = models
        viewControllers.removeAll()
        for model in models {
            viewControllers.append(createPage(model: model))
        }
        guard !viewControllers.isEmpty else {
            return
        }
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.pageViewController.setViewControllers(
                [self.viewControllers[0]],
                direction: .forward, animated: false
            )
        }
    }
    
    private func createPage(model: HomeSegmentModel) -> UIViewController {
        let page = HomeSegmentProductsListPage()
        
        page.filters.route = (model.query ?? "")
        page.observer = observer
        return page
    }
}

extension HomeProductPageControlRoom: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = viewControllers.firstIndex(of: viewController) else {
            return nil
        }
        guard currentIndex > 0 else { return nil }
        return viewControllers[currentIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = viewControllers.firstIndex(of: viewController) else {
            return nil
        }
        guard currentIndex < viewControllers.count - 1 else { return nil }
        return viewControllers[currentIndex + 1]
    }
    
    func updateSegmentedControl() {
        observer?.updateSegmentedControlObserver.send(currentPageIndex)
    }
}

extension HomeProductPageControlRoom: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else { return }
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = viewControllers.firstIndex(of: currentViewController) {
            currentPageIndex = currentIndex
            updateSegmentedControl()
        }
    }
}
