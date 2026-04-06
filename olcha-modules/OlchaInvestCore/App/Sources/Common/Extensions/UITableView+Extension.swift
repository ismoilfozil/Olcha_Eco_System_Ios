//
//  UITableView+Extension.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 12/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit

extension UITableView {
    func hasRow(at indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
    
    func cell<T: UITableViewCell>(at indexPath: IndexPath) -> T? {
        cellForRow(at: indexPath) as? T
    }
    
    func cell<T: UITableViewCell>(at row: Int, in section: Int = 0) -> T? {
        cellForRow(at: IndexPath(row: row, section: section)) as? T
    }
}
