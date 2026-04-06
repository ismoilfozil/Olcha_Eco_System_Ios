//
//  SelectableFiltersPage+Extensions.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 12/07/22.
//

import UIKit
import OlchaUI
extension SelectableFiltersPage: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch self.section {
        case .tags:
            return self.tags.count
        case .brands:
            return self.manufacturers.count
        case .features:
            return self.values.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(SelectFilterItem.self, for: indexPath)
        
        switch self.section {
        case .tags:
            let value = tags[indexPath.row]
            
            cell.setup(with: value.name ?? "")
            cell.isChosen = (value.isSelected ?? false)
            
            cell.selectButton.clicked { [weak self] in
                guard let self = self else { return }
                
                self.tags[indexPath.row].isSelected.optionalToggle()
                self.reloadTable()
            }
            break
        case .brands:
            let value = manufacturers[indexPath.row]
            
            cell.setup(with: value.getName())
            cell.isChosen = (value.isSelected ?? false)
            cell.selectButton.clicked { [weak self] in
                guard let self = self else { return }
                
                self.manufacturers[indexPath.row].isSelected.optionalToggle()
                self.reloadTable()
            }
            
            break
        case .features:
            let value = values[indexPath.row]
            cell.setup(with: value.getName())
            cell.isChosen = (value.isSelected ?? false)
            
            cell.selectButton.clicked { [weak self] in
                guard let self = self else { return }
                
                self.values[indexPath.row].isSelected.optionalToggle()
                self.reloadTable()
            }
            break
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    
}
