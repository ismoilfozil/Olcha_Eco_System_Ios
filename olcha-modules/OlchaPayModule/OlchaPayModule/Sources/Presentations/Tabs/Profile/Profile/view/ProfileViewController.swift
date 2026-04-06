//
//  SettingsViewController.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 14/02/23.
//

import UIKit
import OlchaAuth
import OlchaUI
public class ProfileViewController: BaseViewController<TitleNavigationBar> {

    private lazy var table: BaseTableView = {
        let table = BaseTableView()
        table.delegate = self
        table.dataSource = self
        table.configure()
        table.registerClass(forCell: UserRoom.self)
        table.registerClass(forCell: ProfileMenuRoom.self)
        return table
    }()
    
    weak var coordinator: ProfileCoordinatorProtocol?
    
    public let viewModel: ProfileViewModel
    
    public var user: User? {
        didSet {
            table.reloadData()
        }
    }
    
    public init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let sections: [Section] = [
        .user,
//        (PayAppConfigurator.shared.isModule ? .olcha : nil),
        .notifications,
        .settings,
        .support,
        .logout
    ].compactMap { $0 }
    
    public override func setupViews() {
        container.addSubview(table)
    }
    
    public override func autolayout() {
        table.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        navigationBar.setTitle("profile".localized())
        navigationBar.backButton.isHidden = true
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        table.reloadData()
    }
    
    public override func initialRequest() {
        viewModel.loadUserData()
    }
    
    public override func setupObservers() {
        handle(viewModel.$user, success: { [weak self] data in
            guard let self = self else { return }
            self.user = data
        })
    }
    
    public override func languageUpdated() {
        navigationBar.setTitle("profile".localized())
        table.reloadData()
    }
}
