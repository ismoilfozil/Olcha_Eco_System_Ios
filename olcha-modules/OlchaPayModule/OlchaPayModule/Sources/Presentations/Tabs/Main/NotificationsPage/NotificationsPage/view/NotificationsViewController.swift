//
//  NotificationsViewController.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 15/02/23.
//

import UIKit
import OlchaUI
import OlchaCore
public class NotificationsViewController: BaseViewController<BackNavigationBar> {

    private lazy var table: BaseTableView = {
        let table = BaseTableView()
        table.delegate = self
        table.dataSource = self
        table.registerClass(forCell: NotificationRoom.self)
        table.configure()
        return table
    }()
    
    var notifications: [NotificationModel] = [] {
        didSet {
            table.reloadData()
        }
    }
    
    weak var coordinator: PayHomeCoordinatorProtocol?
    
    let paging = Paging()
    
    let viewModel: NotificationsViewModel
    
    public init(viewModel: NotificationsViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setupViews() {
        container.addSubview(table)
        table.addSubview(refreshControl)
    }
    
    public override func autolayout() {
        table.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        languageUpdated()
    }
    
    public override func languageUpdated() {
        navigationBar.setTitle("notifications".localized())
        placeholder.setupTitle("empty_notifications".localized())
    }
    
    public override func initialRequest() {
        viewModel.loadNotifications(page: 1)
    }
    
    public override func setupObservers() {
        
        handle(viewModel.$notifications,
               showLoader: true,
               success: { [weak self] data in
            guard let self = self else { return }
            paging.finished(paginator: data?.paginator)
            
            notifications.append(data?.notifications ?? [], self.paging)
            
            tableReloader()
        }, failure: { [weak self] error in
            guard let self = self else { return }
            self.paging.errorFinished()
            tableReloader()
        }, loading: { [weak self] isLoading in
            guard let self else { return }
            paging.isInitialLoad() ? showLoader() : hideLoader()
        })
               
        placeholderButton { [weak self] in
            guard let self = self else { return }
            popToRoot(mainTabIndex: PayTab.home)
        }
    }
    
    func loadMore(_ index: Int) {
        guard canLoad(index: index, paging: paging, list: notifications) else { return }
        viewModel.loadNotifications(page: paging.current)
    }
    
    public override func refreshList(_ sender: AnyObject) {
        paging.reset()
        initialRequest()
        refreshControl.endRefreshing()
    }
    
    private func checkPlaceholder() {
        notifications.isEmpty ? enablePlaceholder() : disablePlaceholder()
    }
    
    public func tableReloader() {
        checkPlaceholder()
        table.reloadData()
    }
    
}
