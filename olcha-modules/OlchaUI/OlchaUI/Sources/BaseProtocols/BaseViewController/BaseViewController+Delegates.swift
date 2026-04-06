//
//  BaseViewController+Delegates.swift
//  OlchaUI
//
//  Created by Elbek Khasanov on 27/03/23.
//

import UIKit
import OlchaCore
extension BaseViewController {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }
    
    public func loadingController(_ isLoading: Bool, _ reloader: AnyObject, _ list: [Any]) {
        if isLoading {
            if list.isEmpty {
                self.showLoader()
            } else {
                if let table = reloader as? UITableView {
                    table.reloadData()
                } else if let collection = reloader as? UICollectionView {
                    collection.reloadData()
                }
            }
        } else {
            self.hideLoader()
        }
    }
}
