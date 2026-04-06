//
//  LocationsListPage+Table.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 08/09/22.
//

import UIKit
extension LocationsListPage: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        locationsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(LocationCardRoom.self, for: indexPath)
        
        let isDefault = (locationsList[indexPath.row].main_address ?? 0) == 1
        
        checkPaginator(index: indexPath.row)
        cell.setup(with: locationsList[indexPath.row])
        cell.changeState(isDefault: isDefault)
        
        cell.changeStateButton.clicked { [weak self] in
            guard let self = self,
                  let id = self.locationsList[indexPath.row].id else { return }
            
            let oldValue = self.locationsList[indexPath.row].main_address ?? 0
            
            self.locationsList = self.locationsList.map { address -> UserAddress in
                var newAddress = address
                newAddress.main_address = 0
                return newAddress
            }
            
            if oldValue == 0 {
                self.locationsList[indexPath.row].main_address = 1
                self.makeDefaultAddress(id: id)
            }
            
            self.table.reloadData()
        }
        
        cell.deleteButton.settings.clicked { [weak self] in
            guard let self = self,
                  let id = self.locationsList[indexPath.row].id else { return }
            
            self.showAddressDeleteSubmit {
                self.locationsList.remove(at: indexPath.row)
                self.table.reloadData()
                self.deleteAddress(id: id)
            }
            
        }
        
        cell.editIconButton.clicked { [weak self] in
            guard let self = self else { return }
            self.coordinator?.pushAddLocationMap(address: self.locationsList[indexPath.row]) {
                tableView.reloadData()
            }
        }
        
        return cell
    }
    
    func checkPaginator(index: Int) {
        if index == (locationsList.count - 3) {
            if !paging.isLoading {
                paging.current = paging.current + 1
                if paging.current <= paging.total {
                    loadMore()
                }
            }
        }
    }
    
    
}
