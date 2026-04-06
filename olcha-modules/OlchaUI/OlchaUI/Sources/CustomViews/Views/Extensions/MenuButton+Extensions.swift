//
//  MenuButton+Extensions.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 10/09/22.
//

import UIKit
extension MenuButton: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(TitleLabelRoom.self, for: indexPath)
        cell.setup(with: items[indexPath.item])
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        cellHeight
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        selectedIndex?(indexPath.row)
        openMenu = false
    }
    
    
}
