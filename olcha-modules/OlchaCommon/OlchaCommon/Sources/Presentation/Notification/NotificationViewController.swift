//
//  NotificationViewController.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 29/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI
import OlchaUtils

public class NotificationViewController: BaseViewController<TitleNavigationBar> {
    
    private lazy var headerCollectionView: UICollectionView = {
        let layout = NotificationLayoutManager().getLayout(with: .header)
        let collection = UICollectionView(frame: .zero,
                                          collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.registerClass(forCell: NotificationHeaderItem.self)
        collection.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        return collection
    }()
    
    private lazy var table: BaseTableView = {
        let table = BaseTableView()
        table.registerClass(forCell: NotificationTableCell.self)
        table.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        table.delegate = self
        table.dataSource = self
        table.configure()
        table.backgroundColor = .lightGrayBackground
        return table
    }()
    
    public var selectObserver: ((ClickAction) -> Void)?
    public let input: Input
    public let output: Output
    public let viewModel: CommonViewModel
    
    public init(
        viewModel: CommonViewModel,
        input: Input = .init(),
        output: Output = .init()
    ) {
        self.viewModel = viewModel
        self.input = input
        self.output = output
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setupViews() {
        container.addSubview(headerCollectionView)
        container.addSubview(table)
    }
    
    public override func autolayout() {
        headerCollectionView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(0)
        }
        table.snp.makeConstraints { make in
            make.top.equalTo(headerCollectionView.snp.bottom).inset(-4)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        placeholder.titleLabel.style(.semibold, 20)
        placeholder.mainButton.isHidden = true
        languageUpdated()
    }
    
    public override func languageUpdated() {
        navigationBar.setTitle("notification_heading".localized(.common))
        placeholder.setupTitle("notification_empty_placeholder".localized(.common))
    }
    
    public override func setupObservers() {
        handle(viewModel.$notifications, showLoader: true) { [weak self] data in
            guard let self else { return }
            input.notifications.models.append(contentsOf: data?.notifications ?? [])
            reloadTable()
        } failure: { [weak self] error in
            guard let self else { return }
            reloadTable()
        }
    }
    
    public override func initialRequest() {
        viewModel.loadNotifications(page: 1, type: .all)
    }
    
    public func reloadTable() {
        table.reloadData()
        if input.notifications.models.isEmpty {
            enablePlaceholder()
        } else {
            disablePlaceholder()
        }
    }
    
}
