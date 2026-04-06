//
//  OrdersStepModalPage+Table.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 19/10/22.
//

import UIKit
extension OrdersStepModalPage: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return steps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeue(OrderStepRoom.self, for: indexPath)
        cell.setup(with: steps[indexPath.row],
                   index: indexPath.row,
                   isLast: (indexPath.row + 1) == steps.count)
        
        return cell
    }
    
    
}
