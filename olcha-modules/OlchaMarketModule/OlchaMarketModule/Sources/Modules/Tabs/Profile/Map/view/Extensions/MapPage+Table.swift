//
//  MapPage+Table.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 08/09/22.
//

import UIKit
//extension MapPage: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        searchedLocations.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeue(TitleLabelRoom.self, for: indexPath)
//        cell.setup(with: searchedLocations[indexPath.row].display_name)
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        roomHeight
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: false)
//        
//        searchHintTable.isHidden = true
//        streetMapViewModel.currentLocation = self.searchedLocations[indexPath.row]
//        
//        viewModel.mapLocation = streetMapViewModel.getCurrentLocationCoordinate()
//        moveTo(location: viewModel.mapLocation)
//        
//        view.endEditing(true)
//    }
//}
