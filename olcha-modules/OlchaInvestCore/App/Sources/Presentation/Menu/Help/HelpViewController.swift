//
//  HelpViewController.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 05/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI
import OlchaUtils

public class HelpViewController: BaseViewController<TitleNavigationBar> {
    
    private lazy var table: BaseTableView = {
        let table = BaseTableView()
        table.registerClass(forCell: InvestHomeModalTableCell.self)
        table.delegate = self
        table.dataSource = self
        table.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 120, right: 16)
        return table
    }()
    
    private let subscribeView = SubscribeView()
    
    public var coordinator: HelpCoordinatorProtocol?
    
    public override func setupViews() {
        container.addSubview(table)
        container.addSubview(subscribeView)
    }
    
    public override func autolayout() {
        table.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(subscribeView.snp.top).offset(-20)
        }
        subscribeView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        languageUpdated()
    }
    
    public override func languageUpdated() {
        navigationBar.setTitle("help_heading".localized(.olchaInvestCore))
        subscribeView.languageUpdated()
        table.reloadData()
    }

    public override func initialRequest() {
        table.reloadData()
    }
    
    public override func setupObservers() {
        subscribeView.fbButtonClicked { [weak self] in
            self?.openURL(Texts.socialUrl.fbUrl)
        }
        subscribeView.igButtonClicked { [weak self] in
            self?.openURL(Texts.socialUrl.igUrl)
        }
        subscribeView.tgButtonClicked { [weak self] in
            self?.openURL(Texts.socialUrl.tgUrl)
        }
    }
    
    public func pushWriteUsViewController() {
        coordinator?.pushWriteUsViewController()
    }
    
    public func pushFaqViewController() {
        coordinator?.pushFaqViewController()
    }
    
    public func presentPhoneAlert() {
        let alert = UIAlertController(title: "help_call_alert_title".localized(.olchaInvestCore), message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "help_call_alert_cancel".localized(.olchaInvestCore), style: .destructive))
        alert.addAction(UIAlertAction(title: "help_call_alert_call".localized(.olchaInvestCore), style: .default, handler: { [weak self] _ in
            self?.openPhone()
        }))
        present(alert, animated: true)
    }
}
