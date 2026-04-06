//
//  CartLocationsRoom+Table.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 30/09/22.
//


import UIKit
extension CartLocationsModalPage: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return locationsCount
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeue(CartLocationRoom.self, for: indexPath)
            cell.configure(skeleton: skeleton)
            if locations.isGreater(indexPath) {
                let item = locations[indexPath.row]
                cell.setup(with: item)
                cell.isChosen = (item == selectedAddress)
                cell.editButton.clicked { [weak self] in
                    guard let self = self else { return }
                    dismiss(animated: true) {
                        self.observers?.navigation.editAddress.send(item)
                    }
                }
            }
            return cell
        } else {
            let cell = tableView.dequeue(CartAddLocationRoom.self, for: indexPath)
            cell.setup()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if locations.isGreater(indexPath) {
                selectedAddress = locations[indexPath.row]
            }
        } else {
            dismiss(animated: true) { [weak self] in
                guard let self else { return }
                self.observers?.navigation.addAddress.send()
            }
        }
    }
}
