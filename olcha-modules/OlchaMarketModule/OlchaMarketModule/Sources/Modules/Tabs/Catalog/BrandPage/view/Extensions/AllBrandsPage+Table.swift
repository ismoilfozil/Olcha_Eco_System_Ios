//
//  AllBrandsPage+Table.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 31/08/22.
//

import UIKit
extension AllBrandsPage: UITableViewDelegate, UITableViewDataSource {
    enum Section: Int {
        case keyboard
        case popular
        case brands
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionType = sections[section]
        
        switch sectionType {
        case .keyboard:
            return 1
        case .popular:
            return 1
        case .brands:
            
            let sectionIndex = getSection(at: .init(row: 0, section: section))
            if table.isLoaded(at: sectionIndex) == true {
                let isEmpty = letterBrands[sectionIndex].brands.isEmpty
                return isEmpty ? 0 : 1
            } else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        
        switch section {
            case .keyboard:
            let cell = tableView.dequeue(KeyboardFilterRoom.self, for: indexPath)
            cell.setup(with: self)
                return cell
        case .popular:
            let cell = tableView.dequeue(SingleBrandsRoom.self, for: indexPath)
            cell.pushCategoryObserver = pushCategoryObserver
            cell.pushBrandObserver = pushBrandObserver
            cell.style = .white
            cell.setup(with: self.popularBrands, withShowAll: false)
            cell.configure(roomTitle: "popular_products".localized())
            return cell
        case .brands:
            let section = getSection(at: indexPath)
            let cell = tableView.dequeue(BrandsListRoom.self, for: indexPath)
            cell.pushBrandObserver = pushBrandObserver
            cell.setup(title: letterBrands[section].letter,
                       data: letterBrands[section].brands)
            
            cell.seeAllButton.settings.clicked { [weak self] in
                guard let self = self else { return }
                self.clicked(letter: self.letterBrands[section].letter)
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let index = getSection(at: indexPath)
                
        loadBrands(at: index)
        loadBrands(at: index + 1)
        loadBrands(at: index + 2)
        
    }
    
    private func getSection(at indexPath: IndexPath) -> Int {
        return (indexPath.section - staticSections.count)
    }
}

extension AllBrandsPage: KeyboardFilterDelegate {
    func clicked(letter: String) {
        pushToLetterBrands(with: letter)
    }
}
