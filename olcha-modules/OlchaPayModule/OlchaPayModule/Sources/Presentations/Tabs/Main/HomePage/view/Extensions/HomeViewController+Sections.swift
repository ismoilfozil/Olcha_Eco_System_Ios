//
//  HomePageView+Table.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 01/02/23.
//


import UIKit
import OlchaUI

extension HomeViewController {
    public enum Section: Int {
        case phone
        case categories
        
        case saved
        case news
        case history
    }
    
    public func setupStackSections() {
        for section in sections {
            switch section {
            
            case .phone:
                scrollView.addArrangedSubview(homePhoneView)
                scrollView.container.setCustomSpacing(12, after: homePhoneView)
                break
            case .categories:
                scrollView.addArrangedSubview(categoriesGroup)
                break
            case .saved:
                scrollView.addArrangedSubview(savedTransactionsGroup)
                scrollView.container.setCustomSpacing(12, after: savedTransactionsGroup)
                break
            case .news:
                scrollView.addArrangedSubview(newsGroup)
                scrollView.container.setCustomSpacing(24, after: newsGroup)
                break
            case .history:
                scrollView.addArrangedSubview(historyTransactionsGroup)
                scrollView.container.setCustomSpacing(24, after: historyTransactionsGroup)
                break
            }
        }
    }
    
    public func getStackItem<V>(section: Section) -> V? where V: UIView {
        if scrollView.container.arrangedSubviews.isGreater(section.rawValue) {
            return scrollView.container.arrangedSubviews[section.rawValue] as? V
        }
        return nil
    }
    
    private func configureSections() {
        
    }
}
