//
//  NotificationsPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 12/10/22.
//

import UIKit
import Combine
import OlchaUI
import OlchaCore
class NotificationsPage: BaseViewController {
    
    private let table = BaseTableView()
    
    private let viewModel = ProfilePageViewModel()
    
    private var bag = Set<AnyCancellable>()
    
    private let paging = Paging()
    
    var notifications: [NotificationEntity] = [] {
        didSet {
            notifications.isEmpty ? enablePlaceholder() : disablePlaceholder()
        }
    }
    
    override func setupViews() {
        container.addSubview(table)
    }
    
    override func autolayout() {
        table.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureViews() {
        navigation.configure(style: .back)
        navigation.setTitle("notifications".localized())
        table.delegate = self
        table.dataSource = self
        table.configure()
        table.registerClass(forCell: NotificationRoom.self)
        
        languageUpdated()
    }
    
    override func languageUpdated() {
        placeholder.setupTitle("empty_notification".localized())
        placeholder.setupButtonTitle()
    }
    
    override func initialRequest() {
        loadNotifications()
    }
    
    override func setupObservers() {
        super.baseSetupObservers(viewModel: viewModel)
        
        viewModel
            .$notificationsError
            .dropFirst()
            .sink { [weak self] isError in
                guard let self = self else { return }
                self.paging.isLoading = false
                self.paging.current -= 1
            }.store(in: &bag)
        
        viewModel
            .$notificationsData
            .dropFirst()
            .sink { [weak self] data in
                guard let self = self else { return }
                self.notifications.append(contentsOf:  data?.notifications ?? [])
                self.paging.current = data?.paginator?.current_page ?? 1
                self.paging.total = data?.paginator?.last_page ?? 1
                self.paging.isLoading = false
                self.table.reloadData()
            }.store(in: &bag)
        
        placeholderButton { [weak self] in
            guard let self = self else { return }
            popToMainTab(mainTabIndex: OlchaTab.home)
        }
    }
    
    func loadMore(index: Int) {
        if (notifications.count-1) == index {
            if !paging.isLoading {
                paging.current += 1
                if paging.current <= paging.total {
                    loadNotifications()
                }
            }
        }
    }
    
    func loadNotifications() {
        paging.isLoading = true
        viewModel.loadNotifications(page: paging.current)
    }
    
    func readNotification(index: Int) {
        guard index < notifications.count, (notifications[index].read ?? false) == false, let id = notifications[index].id else { return }
        notifications[index].read = true
        viewModel.readNotification(id: id)
    }
}
