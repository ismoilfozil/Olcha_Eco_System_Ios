//
//  HomeProductPageControlRoomHeader.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 17/11/23.
//

import UIKit
import OlchaUI
import Combine
class HomeProductPageControlRoomHeader: UITableViewHeaderFooterView {
    private var bag = Set<AnyCancellable>()
    private let segmentControl = ScrollableSegmentedControl()
    
    weak var observer: HomePageProductsObserver? {
        didSet {
            setupObservers()
        }
    }
    
    var currentPageIndex = 0
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
        autolayout()
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(segmentControl)
    }
    
    func autolayout() {
        segmentControl.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureViews() {
        backgroundColor = .olchaWhite
        segmentControl.backgroundColor = .olchaWhite
        
        segmentControl.segmentSelected = { [weak self] index in
            guard let self, index != currentPageIndex else { return }
            let direction: UIPageViewController.NavigationDirection = index > currentPageIndex ? .forward : .reverse
            observer?.setViewControllerObserver.send((index: index, direction: direction))
            currentPageIndex = index
        }
    }
    
    private func setupObservers() {
//        if let currentIndex = observer?.currentIndex {

        segmentControl.selectSegment(currentPageIndex)
//            segmentControl.setSelectedSegmentIndex(currentPageIndex, animated: false)
//        }
        
        observer?.updateSegmentedControlObserver.sink(receiveValue: { [weak self] index in
            guard let self else { return }
            currentPageIndex = index
            segmentControl.setSelectedSegmentIndex(index, animated: true)
        }).store(in: &bag)
        
        observer?.setupViewControllersObserver.sink(receiveValue: { [weak self] pages in
            guard let self else { return }
            segmentControl.setupSegment(titles: pages.map { $0.getName() })
        }).store(in: &bag)
    }
}
