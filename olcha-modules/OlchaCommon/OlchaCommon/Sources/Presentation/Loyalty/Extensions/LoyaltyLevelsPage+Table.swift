//
//  LoyaltyLevelsPage+Table.swift
//  OlchaCommon
//
//  Created by Elbek Khasanov on 21/07/24.
//

import UIKit
extension LoyaltyLevelsPage: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        levels.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(LoyaltyLevelRoom.self, for: indexPath)
        cell.setupLevel(levels[indexPath.row])
        return cell
    }
    
}
