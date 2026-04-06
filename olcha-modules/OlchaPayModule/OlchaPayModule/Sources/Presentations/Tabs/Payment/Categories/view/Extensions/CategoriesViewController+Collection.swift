//
//  CategoriesViewController+Collection.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 27/03/23.
//

import UIKit
import SkeletonView
extension CategoriesViewController: UICollectionViewDelegateFlowLayout, SkeletonCollectionViewDataSource {
    public func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        CategoryItem.classIdentifier
    }
    
    
    enum Section {
        case urgent
        case categories
        
        var headerHeight: CGFloat {
            switch self {
            case .urgent:
                return 0
            case .categories:
                return 44
            }
        }
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch sections[section] {
        case .categories:
            print("check count", categories.count, skeleton.getCount(categories.count), skeleton.isAnimating)
            return skeleton.getCount(categories.count)
        default:
            return 0
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections[indexPath.section] {
        case .categories:
            let cell = collectionView.dequeue(CategoryItem.self, for: indexPath)
            cell.configure(skeleton: skeleton)
            if categories.isGreater(indexPath) {
                cell.setup(with: categories[indexPath.item])
            } else {
                cell.prepareForReuse()
            }
            return cell
        default:
            return .init()
        }
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch sections[indexPath.section] {
        case .categories:
            let size = collectionView.frame.width / 3
            return .init(width: size, height: size)
        default:
            return .zero
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch sections[indexPath.section] {
        case .categories:
            let header = collectionView.dequeue(CategoryHeader.self, for: indexPath, kind: UICollectionView.elementKindSectionHeader)
            
            header.setup(with: "all_services".localized())
            
            return header
        default:
            return UICollectionReusableView.init(frame: .zero)
        }
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return .init(width: collectionView.frame.width,
                     height: sections[section].headerHeight)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch sections[indexPath.section] {
        case .categories:
            guard categories.isGreater(indexPath) else { return }
            coordinator?.pushProvidersList(category: categories[indexPath.item])
            break
        default:
            break
        }
    }
}
