//
//  PartnersViewController+Table.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 18/05/23.
//

import UIKit
import OlchaUI
import SkeletonView

extension PartnersViewController: UICollectionViewDelegateFlowLayout, SkeletonCollectionViewDataSource {
    
    public func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return PartnerStoreItem.classIdentifier
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        collection.baseSections.count
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collection.baseSections[section] {
        case .models:
            return getStoresCount()
        case .indicator:
            return output.filter.partners.paging.footerLoadingCount()
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collection.baseSections[indexPath.section] {
        case .models:
            let cell = collectionView.dequeue(PartnerStoreItem.self, for: indexPath)
            cell.layoutIfNeeded()
            cell.configure(skeleton: output.skeleton)
            
            if output.filter.partners.models.isGreater(indexPath) {
                cell.setup(with: output.filter.partners.models[indexPath.row].getImageURL())
            }
            
            loadMore(index: indexPath.row)
            
            return cell
        case .indicator:
            let cell = collection.dequeue(FooterCollectionItem.self, for: indexPath)
            cell.responder.configureIndicator()
            return cell
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collection.baseSections[indexPath.section] {
        case .models:
            return .init(width: collectionView.frame.width / 2,
                         height: 112)
        case .indicator:
            return .init(width: collectionView.frame.width, height: 44)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collection.baseSections[indexPath.section] {
        case .models:
            if output.filter.partners.models.isGreater(indexPath.row) {
                coordinator?.pushPartnerInfo(partner: output.filter.partners.models[indexPath.row])
            }
        default:
            break
        }
    }
    
    private func getStoresCount() -> Int {
        output.skeleton.getCount(output.skeleton.getCount(output.filter.partners.modelsCount))
    }
}
