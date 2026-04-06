//
//  DynamicTable.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 20/07/22.
//

import UIKit
public class DynamicTable: UITableView {
    
    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        defaultInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        defaultInit()
    }
    
    public func defaultInit(){
        self.keyboardDismissMode = .onDrag
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.tableFooterView = UIView(frame: .zero)
        self.tableHeaderView = UIView(frame: .zero)
        self.sectionFooterHeight = 0
        self.sectionHeaderHeight = 0
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        if self.nsHeightConstraint != nil {
            self.nsHeightConstraint?.constant = self.contentSize.height
        }
        else{
            self.heightAnchor.constraint(equalToConstant: self.contentSize.height).isActive = true
        }
        self.setNeedsDisplay()
    }
}

public extension UITableView {
    
    func estimatedRowHeight(_ height: CGFloat) {
        self.rowHeight = UITableView.automaticDimension
        self.estimatedRowHeight = height
    }
    
    func reloadData(delay: TimeInterval = 0, completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, delay: delay) {
            self.reloadData()
        } completion: { _ in
            completion()
        }
    }
}

extension UIView {
    
    var nsHeightConstraint: NSLayoutConstraint? {
        get {
            return constraints.filter {
                if $0.firstAttribute == .height, $0.relation == .equal {
                    return true
                }
                return false
                }.first
        }
        set{ setNeedsLayout() }
    }
}

public class DynamicCollection: BaseCollectionView {
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    public override var intrinsicContentSize: CGSize {
        return contentSize
    }
    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
