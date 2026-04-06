//
//  PaymentsGroupViewController.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 11/02/23.
//

import UIKit
import OlchaUI

public class PaymentsGroupViewController: BaseViewController<SearchActionNavigationBar> {

    private lazy var table: BaseTableView = {
        let table = BaseTableView()
        table.delegate = self
        table.dataSource = self
        table.registerClass(forCell: PaymentGroupRoom.self)
        table.configure()
        return table
    }()
    
    weak var coordinator: PaymentsCoordinatorProtocol?
    
    public let observerHelper = PushPaymentHelper()
    
    public override func setupViews() {
        container.addSubview(table)
    }
    
    public override func autolayout() {
        table.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    public override func configureViews() {
        navigationBar.searchView.setPlaceholder("search".localized() + "...")
        navigationBar.withNotification = false
    }
    
    public override func setupObservers() {
        observerHelper
            .pushPayment
            .sink { [weak self] isPushing in
                guard let self = self, isPushing else { return }
//                self.coordinator?.pushPaymentPage(service: nil)
            }.store(in: &bag)
    }
}
