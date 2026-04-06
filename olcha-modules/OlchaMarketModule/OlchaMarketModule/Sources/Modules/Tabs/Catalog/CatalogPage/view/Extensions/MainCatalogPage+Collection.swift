//
//  MainCatalogPage+Collection.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 06/07/22.
//

import UIKit

extension MainCatalogPage: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return skeleton.getCount(categories.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(MiniCategoryItem.self, for: indexPath)
        cell.layoutIfNeeded()
        cell.configure(skeleton: skeleton)
        if categories.isGreater(indexPath) {
            cell.setup(with: categories[indexPath.item],
                       isIcon: (sourceType == .initial))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard categories.isGreater(indexPath) else { return }
        let model = categories[indexPath.item]
        switch sourceType {
        case .initial:
            coordinator?.pushCatalogListPage(pageState: .category(model, nil))
            break
        case .route:
            if (model.children?.isEmpty ?? true ) {
                coordinator?.pushProductsListPage(category: model, brand: nil, catalogStack: [model])
            } else {
                coordinator?.pushCatalogListPage(pageState: .category(model, nil))
            }
            break
        }
    }
}
