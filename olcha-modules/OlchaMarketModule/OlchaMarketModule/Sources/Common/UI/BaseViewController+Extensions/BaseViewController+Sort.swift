//
//  BaseViewController+Sort.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 08/07/22.
//

import UIKit
extension BaseViewController {
    func setupSortMenus() {
        self.sortMenus = ButtonMenus()
        self.view.addSubview(sortMenus ?? UIView(frame: .zero))
        self.sortMenus?.snp.makeConstraints { make in
            make.height.width.equalTo(0)
        }
        self.sortMenus?.isHidden = true
    }
    
    
    func hideMenus() {
        self.sortMenus?.isHidden = true
        self.sortMenus?.snp.updateConstraints { make in
            make.width.height.equalTo(0)
        }
    }
    /// getting buttons frame inside main superview  to show menu panel
    func openMenus(with data: [SortItem] = MarketTexts.sort.products,
                   sender: UIView,
                   selectedSort: SortItem) {
        guard (sortMenus?.isHidden ?? true) else {
            sortMenus?.isHidden = true
            return
        }
        let buttonRect = sender.convert(sender.frame, to: self.view)
        
        self.sortMenus?.menuItems(data, selectedSort)

        self.sortMenus?.snp.updateConstraints { make in
            let height = (self.sortMenus?.cellHeight ?? 0) * CGFloat(data.count)
            let edge: CGFloat = 4.0 + 4.0
            make.width.equalTo(buttonRect.width)
            make.height.equalTo(height + edge)
        }
        self.view.layoutIfNeeded()
        self.sortMenus?.frame.origin = .init(x: buttonRect.origin.x,
                                             y: buttonRect.origin.y + (self.sortMenus?.cellHeight ?? 0) + 8)
        self.sortMenus?.isHidden = false
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        hideMenus()
    }
}
