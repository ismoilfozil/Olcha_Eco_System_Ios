//
//  PartnersViewController+Actions.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 19/05/23.
//

import UIKit
extension PartnersViewController {
    
    @objc func textFieldDidChange(_ sender: UITextField) {
        output.timerManager.startTimer { [weak self] in
            guard let self = self else { return }
            output.filter.searchText = navigationBar.searchField.textField.text
        }
    }
    
    func loadMore(index: Int) {
        guard canLoad(index: index,
                      paging: output.filter.partners.paging,
                      list: output.filter.partners.models) else { return }
        viewModel.loadPartners(filter: output.filter)
    }
    
    func selectRegion() {
        coordinator?.presentFilters(filters: output.filter.regions) { [weak self] filterModel in
            guard let self = self else { return }
            output.filter.selectedRegion = filterModel
            setFiltersTitle()
        }
    }
    
    func selectCategory() {
        coordinator?.presentFilters(filters: output.filter.categories) { [weak self] filterModel in
            guard let self = self else { return }
            output.filter.selectedCategory = filterModel
            setFiltersTitle()
        }
    }
    
    func filtersUpdated() {
        output.filter.reset()
        
        viewModel.loadPartners(filter: output.filter, cancel: true)
    }

}
