//
//  PartnerInfoViewController+Table.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 19/05/23.
//

import UIKit
import OlchaUI
extension PartnerInfoViewController {
    
    public enum Section {
        case header
        case location
        case description
        case category
    }
    
    
    public func createRooms() {
        scrollView.container.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for section in sections {
            switch section {
                
            case .header:
                createHeaderRoom()
                break
            case .location:
                createLocationsRoom()
                break
            case .description:
                createDescriptionRoom()
                break
            case .category:
                createCategoriesRoom()
                break
            }
        }
        
    }
    
    private func createHeaderRoom(){
        let view = PartnerHeaderRoom()
        view.setup(with: input.partnerModel)
        scrollView.addArrangedSubview(view)
        
        sectionViews[.header] = view
    }
    
    private func createLocationsRoom() {
        
        let count = input.locations.isEmpty ? 0 : (input.locations.count + 1)
        for i in 0..<count {
            switch i {
            case 0:
                let view = HeaderView()
                view.verticalEdge = 12
                view.setup(title: "store_locations".localized(.olchaNasiyaModule))
                scrollView.addArrangedSubview(view)
                break
            default:
                let view = PartnerLocationRoom()
                view.setup(title: input.locations[i - 1].getTitle(),
                           phone: input.locations[i - 1].phone)
                scrollView.addArrangedSubview(view)
                break
            }
        }
    }
    
    private func createDescriptionRoom() {
        
        let headerView = HeaderView()
        headerView.verticalEdge = 12
        headerView.setup(title: "about_partner".localized(.olchaNasiyaModule))
        scrollView.addArrangedSubview(headerView)
        
        
        let view = PartnerDescriptionRoom()
        view.setup(with: input.partnerModel?.getDescription())
        scrollView.addArrangedSubview(view)
        
    }
    
    private func createCategoriesRoom() {

        let view = PartnerCategoriesRoom()
        view.setup(categories: input.categories)
        scrollView.addArrangedSubview(view)
        
    }
    
    
}

extension PartnerInfoViewController {
    private func reloadHeader() {
        (sectionViews[.header] as? PartnerHeaderRoom)?.setup(with: input.partnerModel)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        reloadHeader()
    }
}
