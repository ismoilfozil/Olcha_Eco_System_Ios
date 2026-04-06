//
//  ShippingProductRoom+Extension.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 03/10/22.
//

import UIKit
extension ShippingProductRoom: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        shippingTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(ShippingTypeRoom.self, for: indexPath)
        let item = shippingTypes[indexPath.row]
        cell.setup(with: item)
        cell.isChosen = (item == selectedShippingType)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        itemHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        observers?.shippingType = shippingTypes[indexPath.row]
        observers?.action.shippingTypeSelected.send()
    }
}

extension ShippingProductRoomView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        shippingTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(ShippingTypeRoom.self, for: indexPath)
        let item = shippingTypes[indexPath.row]
        cell.setup(with: item)
        cell.isChosen = (item == selectedShippingType)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        itemHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        observers?.shippingType = shippingTypes[indexPath.row]
        observers?.action.shippingTypeSelected.send()
    }
}
