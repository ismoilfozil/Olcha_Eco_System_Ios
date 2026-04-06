//
//  ComparePage+Table.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 15/08/22.
//

import UIKit
extension ComparePage: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        features.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(CompareOptionRoom.self, for: indexPath)
        cell.setup(with: features[indexPath.row],
                   leftProduct: leftProduct,
                   rightProduct: rightProduct)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == table {
            updateLayout(scrollView)
        }
    }
    
    private func updateLayout(_ scrollView: UIScrollView) {
        
        let y = -scrollView.contentOffset.y
        let topMargin = min(max(y-HEIGHTS.categories_container-24.0, 0), HEIGHTS.categories_container)
        let height = min(max(y-HEIGHTS.categories_container, HEIGHTS.shrinked_header), HEIGHTS.expanded_header)
        
        headerContainer.snp.remakeConstraints { make in
            make.right.left.equalToSuperview()
            make.top.equalToSuperview().inset(topMargin)
            make.height.equalTo(height)
        }

        leftProductsCollection.reloadData()
        rightProductsCollection.reloadData()
        
    }
}
