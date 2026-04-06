//
//  NasiyaFAQViewController+Table.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 14/05/23.
//

import UIKit
import OlchaUI
extension NasiyaFAQViewController: TableDelegates {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        input.faqs.modelsCount
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeue(NasiyaFAQRoom.self, for: indexPath)
            if input.faqs.models.isGreater(indexPath.section) {
                cell.setup(with: input.faqs.models[indexPath.section])
            }
            loadMore(index: indexPath.section)
            return cell
        } else {
            let cell = tableView.dequeue(FooterItem.self, for: indexPath)
            cell.responder.height = 1
            return cell
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard indexPath.row == 0,
              input.faqs.models.isGreater(indexPath.section) else {
            return
        }
        
        input.faqs.models[indexPath.section].isExpanded = !(input.faqs.models[indexPath.section].isExpanded ?? false)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
    }
    
}
