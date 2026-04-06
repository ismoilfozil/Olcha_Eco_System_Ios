//
//  PartnersFilterViewController+Table.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 18/05/23.
//

import UIKit
import OlchaUI
extension PartnersFilterViewController: TableDelegates {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        input.models.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(PartnerFilterRoom.self, for: indexPath)
        if input.models.isGreater(indexPath) {
            cell.setup(with: input.models[indexPath.row].getTitle())
            cell.isChosen = input.models[indexPath.row].getIsSelected()
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        rowHeight
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        let newState = !(input.models[indexPath.row].getIsSelected())

        input.models.forEach { $0.setIsSelected(false) }
        
        input.models[indexPath.row].setIsSelected(newState)
        
        if selectedIndex != indexPath.row {
            completion?(input.models[indexPath.row])
        } else {
            completion?(nil)
        }
    
        dismiss(animated: true)
    }
    
    
}
