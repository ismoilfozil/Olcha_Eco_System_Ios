//
//  SuggestionViewController+Collection.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 15/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

extension SuggestionViewController: CollectionDelegates {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return input.suggestionsSkeleton.getCount(input.sectionsCount)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section < input.sections.count {
            return input.sections[section].blogs.count
        } else {
            return input.suggestionsSkeleton.count
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(SuggestionCollectionCell.self, for: indexPath)
        cell.configure(skeleton: input.suggestionsSkeleton)
        guard input.sections.isGreater(indexPath.section) && input.sections[indexPath.section].blogs.isGreater(indexPath.item) else {
            cell.prepareForReuse()
            return cell
        }
        let data = input.sections[indexPath.section].blogs[indexPath.item]
        cell.setup(with: data)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeue(SuggestionCollectionHeaderReusableView.self, for: indexPath, kind: kind)
            var sectionName = "\t"
            if indexPath.section < input.sections.count {
                sectionName = input.sections[indexPath.section].section_name ?? ""
            }
            headerView.setHeading(text: sectionName)
            return headerView
        default:
            return UICollectionReusableView()
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard input.sections.isGreater(indexPath.section) && input.sections[indexPath.section].blogs.isGreater(indexPath.item) else {
            return
        }
        let section = input.sections[indexPath.section]
        let model = section.blogs[indexPath.item]
        let categoryName = section.section_name.unwrap
        pushSuggestionDetailViewController(model: model, categoryName: categoryName)
    }
    
}

