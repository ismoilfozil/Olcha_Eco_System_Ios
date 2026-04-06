//
//  RamazanTaqvimPage+Table.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 14/03/23.
//
import OlchaUI
import UIKit
extension RamazanTimePage: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 1 : times.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeue(RamazanTimeRoom.self, for: indexPath)
            cell.setupHeader()
            return cell
        } else {
            
            let cell = tableView.dequeue(RamazanTimeRoom.self, for: indexPath)
            cell.background = (indexPath.row % 2 == 0) ? .olchaLightNeutralGray : .olchaWhite
            cell.setup(index: indexPath.row, model: times[indexPath.row])
            
            return cell
        }
    }
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        rowHeight
    }
}
