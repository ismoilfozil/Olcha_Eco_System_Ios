//
//  SettingsViewController.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 31/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI
import OlchaUtils

public class SettingsViewController: BaseViewController<TitleNavigationBar> {
    
    private lazy var table: BaseTableView = {
        let table = BaseTableView()
        table.delegate = self
        table.dataSource = self
        table.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        table.registerClass(forCell: SettingsTableCell.self)
        return table
    }()
    
    private let subscribeView = SubscribeView()
    
    public weak var coordinator: ProfileCoordinatorProtocol?
    
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
        navigationBar.setTitle("settings_heading".localized(.olchaInvestCore))
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
    
    public func pushAboutViewController() {
        coordinator?.pushAboutViewController()
    }
    
    public func pushLanguageViewController() {
        coordinator?.pushLanguageViewController()
    }
    
    public func clearTooltipCache() {
        let someView = UIView()
        MenuViewControllerTooltip.faq(in: someView).clearCache()
        InvestViewControllerTooltip.amount(in: someView).clearCache()
        AmountViewControllerTooltip.amount(in: someView).clearCache()
        ContractViewControllerTooltip.amounts(in: someView).clearCache()
        PackagesViewControllerTooltip.currency(in: someView).clearCache()
        InvestHomeViewControllerTooltip.investButton(in: someView).clearCache()
        SelectTermViewControllerTooltip.term(in: someView).clearCache()
        SelectPackageViewControllerTooltip.selectButton(in: someView).clearCache()
        ProfileViewControllerTooltip.balance(in: someView).clearCache()
    }
    
}
