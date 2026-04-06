//
//  MenuViewController.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 30/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI
import SideMenu
import OlchaAuth

public class MenuViewController: BaseViewController<EmptyNavigationBar> {
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let profileView = ProfileView()
    
    private lazy var table: DynamicTable = {
        let table = DynamicTable()
        table.registerClass(forCell: MenuViewControllerTableCell.self)
        table.isScrollEnabled = false
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    private var tooltips: [MenuViewControllerTooltip] {
        let firstCell: MenuViewControllerTableCell? = table.cell(at: IndexPath(row: 0, section: 0))
        let secondCell: MenuViewControllerTableCell? = table.cell(at: IndexPath(row: 1, section: 0))
        let thirdCell: MenuViewControllerTableCell? = table.cell(at: IndexPath(row: 2, section: 0))
        guard let firstCell, let secondCell, let thirdCell else { return [] }
        return [
            .suggestions(in: firstCell.contentView),
            .faq(in: secondCell.contentView),
            .support(in: thirdCell.contentView)
        ]
    }
    private let tooltipManager = TooltipManager()
    public var coordinator: MenuCoordinatorProtocol?
    public let profileViewModel: ProfileViewModel
    
    public init(profileViewModel: ProfileViewModel) {
        self.profileViewModel = profileViewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profileViewModel.loadUserData()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.backgroundColor = .black.withAlphaComponent(0.4)
        tooltipManager.didViewAppear = true
        guard let topView = view else { return }
        tooltipManager.setup(tooltips: tooltips, darkView: topView)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tooltipManager.destroy()
        view.backgroundColor = .clear
    }
    
    public override func setupViews() {
        view.addSubview(backgroundView)
        backgroundView.addSubview(profileView)
        backgroundView.addSubview(table)
    }
    
    public override func autolayout() {
        backgroundView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.8)
            make.left.top.bottom.equalToSuperview()
        }
        profileView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        table.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(22)
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        view.backgroundColor = .clear
        profileView.setNameLabel(" - ")
        languageUpdated()
    }
    
    public override func languageUpdated() {
        profileView.setSubNameLabel("profile_personal_details".localized(.olchaInvestCore))
        table.reloadData()
    }
    
    public override func setupObservers() {
        handle(profileViewModel.$user, success: { [weak self] data in
            guard let self = self else { return }
            profileView.setNameLabel((data?.phone ?? " - ").formatFullPhoneNumber)
        })
    }
    
    public override func initialRequest() {
        profileViewModel.loadUserData()
    }
    
    public func pushSuggestionsViewController() {
        coordinator?.pushSuggestionsViewController()
    }
    
    public func pushFaqViewController() {
        coordinator?.pushFaqViewController()
    }
    
    public func pushHelpViewController() {
        coordinator?.pushHelpViewController()
    }
    
    public func logoutUser() {
        coordinator?.logout()
    }
    
}

extension MenuViewController: TableDelegates {
    public var rows: [MenuRow] {
        [.suggestion, .faq, .support, .logout]
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(MenuViewControllerTableCell.self, for: indexPath)
        cell.setup(with: rows[indexPath.row])
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) { [weak self] in
            guard let self else { return }
            switch rows[indexPath.row] {
            case .suggestion: pushSuggestionsViewController()
            case .faq: pushFaqViewController()
            case .support: pushHelpViewController()
            case .logout: logoutUser()
            }
        }
    }
}
