//
//  SuggestionViewController.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 15/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

public class SuggestionViewController: BaseViewController<TitleNavigationBar> {

    private enum LayoutConstants: CGFloat {
        case groupHeight = 180.0
        case groupInterItemSpacing = 12.0
        case supplementaryItemHeight = 40.0
        case interGroupSpacing = 8.0
        case sectionEdgeInset = 5.0
        case horizontalInset = 16.0
    }
    
    private let layout: UICollectionViewCompositionalLayout = {
        let itemSize: NSCollectionLayoutSize = .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize: NSCollectionLayoutSize = .init(widthDimension: .fractionalWidth(0.4), heightDimension: .absolute(LayoutConstants.groupHeight.rawValue))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
        group.contentInsets.top = 12
        group.contentInsets.bottom = 24
        group.interItemSpacing = .fixed(LayoutConstants.groupInterItemSpacing.rawValue)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets.leading = LayoutConstants.horizontalInset.rawValue
        section.contentInsets.trailing = LayoutConstants.horizontalInset.rawValue
        section.interGroupSpacing = LayoutConstants.interGroupSpacing.rawValue
        section.boundarySupplementaryItems = [
            .init(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(LayoutConstants.supplementaryItemHeight.rawValue)), elementKind: UICollectionView.elementKindSectionHeader, alignment: NSRectAlignment.top)
        ]
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }()
    
    private lazy var collection: BaseCollectionView = {
        let collection = BaseCollectionView(frame: .zero, collectionViewLayout: self.layout)
        collection.delegate = self
        collection.dataSource = self
        collection.registerClass(forCell: SuggestionCollectionCell.self)
        collection.registerClass(forHeader: SuggestionCollectionHeaderReusableView.self, kind: UICollectionView.elementKindSectionHeader)
        return collection
    }()
    
    public var input: Input
    public var output: Output
    private let viewModel: SuggestionViewModel
    public var coordinator: SuggestionCoordinatorProtocol?
    
    public init(
        input: Input = .init(),
        output: Output = .init(),
        viewModel: SuggestionViewModel
    ) {
        self.input = input
        self.output = output
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setupViews() {
        container.addSubview(collection)
        collection.addSubview(refreshControl)
    }
    
    public override func autolayout() {
        collection.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        navigationBar.setTitle("menu_suggestions".localized(.olchaInvestCore))
    }
    
    public override func initialRequest() {
        viewModel.loadSuggestions()
    }
    
    public override func setupObservers() {
        handle(viewModel.$suggestions, success: { [weak self] data in
            guard let self else { return }
            input.suggestions.models.append(contentsOf: data?.blog_list ?? [])
            input.suggestions.paging.finished(paginator: data?.paginator)
            collection.reloadData()
        }, loading: { [weak self] isLoading in
            guard let self else { return }
            input.suggestionsSkeleton.isAnimating = isLoading
            collection.reloadData()
        })
    }
    
    public func pushSuggestionDetailViewController(model: SuggestionItemModel, categoryName: String) {
        guard let postId = model.id else { return }
        coordinator?.pushSuggestionDetailViewController(postId: postId)
    }
    
    public override func refreshList(_ sender: AnyObject) {
        input.reset()
        collection.reloadData()
        initialRequest()
        refreshControl.endRefreshing()
    }
    
}
