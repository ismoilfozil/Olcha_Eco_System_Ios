//
//  BrandProductsPage+Table.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 31/08/22.
//

import OlchaUI
import UIKit
import SkeletonView
extension BrandProductsPage {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        brandSections().count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = brandSections()[section]
        
        switch section {
        case .sliders:
            return sliders.isEmpty ? 0 : 1
        case .bigBanner:
            return bigBanner == nil ? 0 : 1
        case .flagmans:
            return flagmans.count
        case .bestseller:
            return 2
        case .products:
            return productsSkeleton.getCount(products.count)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = brandSections()[indexPath.section]
        
        switch section {
        case .sliders:
            let cell = collectionView.dequeue(BannersRoom.self,
                                              for: indexPath)
            cell.pushSliderObserver = pushSliderObserver
            cell.setup(with: sliders)
            return cell
        case .bigBanner:
            let cell = collectionView.dequeue(BigBannerCell.self, for: indexPath)
            cell.layoutIfNeeded()
            cell.setup(with: bigBanner?.getMobileImage() ?? "")
            
            
            return cell
        case .flagmans:
            let cell = collectionView.dequeue(BannerItem.self, for: indexPath)
            cell.layoutIfNeeded()
            if flagmans.isGreater(indexPath) {
                cell.setupFlagmans(with: flagmans[indexPath.item])
            }
            
            
            return cell
        case .bestseller:
            if indexPath.item == 0 {
                let cell = collectionView.dequeue(ComponentCollectionHeader.self, for: indexPath)
                cell.configure(with: .title("bestsellers".localized()))
                return cell
            } else {
                let cell = collectionView.dequeue(PromotedCollectionRoom.self, for: indexPath)
                cell.responder.skeleton = bestsellerSkeleton
                cell.responder.productHelper = productHelper
                cell.responder.setup(with: self.bestseller)
                cell.responder.configure(style: .white,
                               withShowAll: true,
                               cellType: .shrink)
                
                cell.responder.seeAllButton.clicked { [weak self] in
                    guard let self = self else { return }
                    self.coordinator?.pushProductsList(filters: self.bestSellerFilters)
                }
                
                return cell
            }
        case .products:
            let cell = collectionView.dequeue(ProductCell.self, for: indexPath)
            cell.productHelper = productHelper
            cell.layoutIfNeeded()
            if indexPath.item < 12 {
                animatingCells[indexPath] = cell
            }
            
            if products.isGreater(indexPath) {
                cell.setup(with: products[indexPath.item])
                checkPaginator(index: indexPath.item)
            }
            
            
            cell.configure(skeleton: productsSkeleton)
            return cell
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = brandSections()[indexPath.section]
        switch section {
        case .bigBanner:
            brandCoordinator?.pushSlider(bigBanner)
            break
        case .flagmans:
            if flagmans.isGreater(indexPath) {
                self.brandCoordinator?.pushSlider(flagmans[indexPath.item])
            }
            break
        case .products:
            if products.isGreater(indexPath) {
                productHelper?.pushProduct.send(products[indexPath.item])
            }
            break
        default: break
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? BaseCollectionCell)?.cellWillAppear()
    }
    
}
