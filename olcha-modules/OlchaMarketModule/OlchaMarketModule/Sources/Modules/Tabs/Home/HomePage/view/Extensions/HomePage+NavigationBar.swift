//
//  HomePage+NavigationBar.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 22/07/22.
//

import UIKit
extension HomePage {
    
    func baseSetupNavigationBottomView() {
        setupNavigationBottomView()
        autolayoutNavigationBottomView()
        configureNavigationBottomView()
    }
    
    private func setupNavigationBottomView() {
        container.clipsToBounds = true
        container.addSubview(bottomBar)
        bottomBar.addSubview(searchView)
        bottomBar.addSubview(extraView)
        bottomBar.addSubview(searchButton)
        
        extraView.addArrangedSubview(saleButton)
        extraView.addArrangedSubview(monthlyButton)
        
        extraView.isHidden = true
    }
    
    private func autolayoutNavigationBottomView() {
        bottomBar.backgroundColor = .olchaBackgroundColor
        bottomBar.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().inset(0)
            make.height.equalTo(self.navigationBottomBarHeight)
        }
        
        
        searchView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(36)
        }
        
        searchButton.snp.makeConstraints { make in
            make.edges.equalTo(searchView.snp.edges)
        }
        
        extraView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            
            make.top.equalTo(self.searchView.snp.bottom).inset(-12)
            make.height.equalTo(36)
        }
        
        saleButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
        }
        
        monthlyButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
        }
    }
    
    private func configureNavigationBottomView() {
        searchView.setPlaceholder()
        
        extraView.distribution = .fillEqually
        extraView.spacing = 12
        extraView.axis = .horizontal
        
       
        saleButton.designButton(with: .percentage?.resizedImage(20),
                                accentColor: .olchaAccentColor)
        
        saleButton.setTitleColor(.clear, for: .disabled)
        monthlyButton.setTitleColor(.clear, for: .disabled)
        
        monthlyButton.designButton(accentColor: .olchaGreen)
        
        saleButton.setTitle("sale".localized(), for: .normal)
        monthlyButton.setTitle("monthly".localized(), for: .normal)
        
        searchButton.clicked { [weak self] in
            guard let self = self else { return }
            self.coordinator?.pushSearch()
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        
        if scrollView == table {
            tableScrolling()
            let sectionToCheck = 4
            if scrollView.isHeaderPinned(forSection: sectionToCheck, inTableView: table) && !scrollView.isScrollingTop {
                productsObserver.scrollObserver.send(.collection)
            }
        }
        
        return
        let hidden = (scrollView.panGestureRecognizer.translation(in: scrollView).y < 0)

        guard scrollView.contentOffset.y > (navigationBottomBarHeight) else {
            changeTopExtraBar(hidden: false, animated: false)
            return
        }
        changeTopExtraBar(hidden: hidden, animated: true)
        
        
    }

    
    func changeTopExtraBar(hidden: Bool, animated: Bool) {
        
        guard topExtraNavigationHidden != hidden else { return }
        topExtraNavigationHidden = hidden
        
        self.bottomBar.snp.updateConstraints { make in
            make.top.equalToSuperview().inset(hidden ? -300 : 0)
        }
        
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            self.view.layoutIfNeeded()
        }
        
    }
}
