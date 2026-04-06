//
//  UICollectionView+Extension.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 30/06/22.
//

import UIKit
import ViewAnimator
import Differ
import OlchaUtils
extension UICollectionView {
    public func dequeue<T: UICollectionViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.classIdentifier, for: indexPath) as? T else {
            fatalError("cannot construct \(T.self)")
        }
        return cell
    }
    
    public func registerClass<T: UICollectionViewCell>(forCell type: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.classIdentifier)
    }
    
    public func registerNib<T: UICollectionViewCell>(forCell type: T.Type, bundleType: BundleType = UITableView.defaultBundle) {
        register(UINib(nibName: T.classIdentifier, bundle: .init(identifier: bundleType.identifier)), forCellWithReuseIdentifier: T.classIdentifier)
    }
    
    public func registerClass<T: UICollectionReusableView>(forHeader type: T.Type, kind: String) {
        register(T.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.classIdentifier)
        
    }
    
    public func dequeue<T: UICollectionReusableView>(_ type: T.Type, for indexPath: IndexPath, kind: String) -> T {
        guard let view = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: T.classIdentifier, for: indexPath) as? T else {
            fatalError("cannot construct \(T.self)")
        }
        return view
    }
    
    
    public func reloadChanges<T: Collection>(from old: T, to new: T) where T.Element: Equatable {
        animateItemChanges(oldData: old, newData: new, updateData: {})
    }
    
    
    public func reloadData(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0) { [weak self] in
            guard let self = self else { return }
            self.reloadData()
        } completion: { _ in
            
            completion()
            
        }
    }
    
    public func scrollToSupplementaryView(ofKind kind: String, at indexPath: IndexPath, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) {
        self.layoutIfNeeded();
        if let layoutAttributes =  self.layoutAttributesForSupplementaryElement(ofKind: kind, at: indexPath) {
            let viewOrigin = CGPoint(x: layoutAttributes.frame.origin.x, y: layoutAttributes.frame.origin.y);
            var resultOffset : CGPoint = self.contentOffset;

            switch(scrollPosition) {
            case .top:
                resultOffset.y = viewOrigin.y - self.contentInset.top

            case .left:
                resultOffset.x = viewOrigin.x - self.contentInset.left

            case .right:
                resultOffset.x = (viewOrigin.x - self.contentInset.left) - (self.frame.size.width - layoutAttributes.frame.size.width)

            case .bottom:
                resultOffset.y = (viewOrigin.y - self.contentInset.top) - (self.frame.size.height - layoutAttributes.frame.size.height)

            case .centeredVertically:
                resultOffset.y = (viewOrigin.y - self.contentInset.top) - (self.frame.size.height / 2 - layoutAttributes.frame.size.height / 2)

            case .centeredHorizontally:
                resultOffset.x = (viewOrigin.x - self.contentInset.left) - (self.frame.size.width / 2 - layoutAttributes.frame.size.width / 2)
            default:
                break;
            }
            self.scrollRectToVisible(CGRect(origin: resultOffset, size: self.frame.size), animated: animated)
        }
    }
    
    public func forInsert(_ oldData: [Any]?, _ newData: [Any]?, _ section: Int) -> [IndexPath] {
        var indexPaths: [IndexPath] = []
        let oldIndex = (oldData ?? []).count
        let newIndex = (oldData ?? []).count + (newData ?? []).count
        
        for i in oldIndex..<newIndex {
            indexPaths.append(IndexPath(item: i, section: section))
        }
        return indexPaths
    }
    
    @discardableResult
    public func cacheSizes(_ size: CGSize, indexPath: IndexPath) -> CGSize {
        guard let self = self as? BaseCollectionView else { return size }
              
        if let oldSize = self.collectionSizes[indexPath] {
            if oldSize != size {
                self.collectionSizes[indexPath] = size
                return oldSize
            } else {
                return self.collectionSizes[indexPath] ?? size
            }
        } else {
            self.collectionSizes[indexPath] = size
            return size
        }
    }
    
}

public extension UICollectionView {
    var halfHorizontalInset: CGFloat {
        (contentInset.left + contentInset.right) / 2
    }
    
    var horizontalInset: CGFloat {
        contentInset.left + contentInset.right
    }
    
    var halfVerticalInset: CGFloat {
        (contentInset.top + contentInset.bottom) / 2
    }
    
    var verticalInset: CGFloat {
        contentInset.top + contentInset.bottom
    }
    
    func indexPathForFirstCell(reuseIdentifier: String) -> IndexPath? {
        for section in 0..<numberOfSections {
            for item in 0..<numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                if let cell = cellForItem(at: indexPath), cell.reuseIdentifier == reuseIdentifier {
                    return indexPath
                }
            }
        }
        return nil
    }
    
    func scrollToFirstCell(ofType cellType: UICollectionViewCell.Type, at scrollPosition: UICollectionView.ScrollPosition = .centeredHorizontally, animated: Bool = true) {
        guard let indexPath = indexPathForFirstCell(reuseIdentifier: cellType.classIdentifier) else { return }
        scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
    }
}
