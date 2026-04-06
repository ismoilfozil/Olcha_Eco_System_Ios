//
//  UICollectionView+Extension.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 19/07/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit

extension UICollectionView {
    func cell<T: UICollectionViewCell>(at item: Int, in section: Int) -> T? {
        cellForItem(at: IndexPath(item: item, section: section)) as? T
    }
}
