//
//  UITableView+Extension.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 30/06/22.
//

import UIKit
import OlchaUtils
public protocol Nameable {
    static var classIdentifier: String { get }
}

public extension Nameable {
    static var classIdentifier: String {
        String(describing: self)
    }
}

extension UIView: Nameable {}
public extension UITableView {
    static var defaultBundle: BundleType = .olcha
    
#warning("Comment")
    func configure() {
        self.registerClass(forCell: HeaderRoom.self)
        self.registerClass(forCell: FooterItem.self)
        
        self.separatorColor = .clear
        self.separatorStyle = .none
        self.rowHeight = UITableView.automaticDimension
        self.estimatedRowHeight = UITableView.automaticDimension
    }
    
    func dequeue<T: UITableViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.classIdentifier, for: indexPath) as? T else {
            return T(style: .default, reuseIdentifier: T.classIdentifier)
        }

        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        return cell
    }
    
    func dequeue<T: UITableViewHeaderFooterView>(_ type: T.Type) -> T {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: type.classIdentifier) as? T else {
            return T(reuseIdentifier: T.classIdentifier)
        }
        view.setNeedsLayout()
        view.layoutIfNeeded()
        return view
    }
    
    func registerClass<T: UITableViewCell>(forCell type: T.Type) {
        register(T.self, forCellReuseIdentifier: T.classIdentifier)
    }
    
    func registerClass<T: UITableViewHeaderFooterView>(forHeaderFooter type: T.Type) {
        register(T.self, forHeaderFooterViewReuseIdentifier: T.classIdentifier)
    }
    
    func registerNib<T: UITableViewCell>(forCell type: T.Type, bundleType: BundleType = defaultBundle) {
        register(UINib(nibName: T.classIdentifier, bundle: .init(identifier: bundleType.identifier)), forCellReuseIdentifier: T.classIdentifier)
    }
    
    func registerNib<T: UITableViewHeaderFooterView>(forHeaderFooter type: T.Type, bundleType: BundleType = defaultBundle) {
        register(UINib(nibName: T.classIdentifier, bundle: .init(identifier: bundleType.identifier)), forHeaderFooterViewReuseIdentifier: T.classIdentifier)
    }
    
    func flatIndex(for indexPath: IndexPath) -> Int {
        var flatIndex = 0
        for i in 0..<indexPath.section {
            flatIndex += self.numberOfRows(inSection: i)
        }
        return flatIndex + indexPath.row
    }
    
    @discardableResult
    func cacheHeights(_ height: CGFloat, indexPath: IndexPath) -> CGFloat {
        guard let self = self as? BaseTableView else { return height }
              
        if let oldHeight = self.tableHeights[indexPath] {
            if oldHeight != height {
                self.tableHeights[indexPath] = height
                return height
            } else {
                return self.tableHeights[indexPath] ?? height
            }
        } else {
            self.tableHeights[indexPath] = height
            return height
        }
    }
    
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
