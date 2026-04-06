//
//  SafetyViewController.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 23/05/23.
//

import UIKit
import OlchaUI
import OlchaAuth

public class SafetyViewController: BaseViewController<BackNavigationBar> {
    
    private lazy var table: BaseTableView = {
        let table = BaseTableView()
        table.delegate = self
        table.dataSource = self
        table.registerClass(forCell: SafetyPincodeRoom.self)
        table.registerClass(forCell: SafetyTitleRoom.self)
        table.configure()
        return table
    }()
    
    public let sections: [Section] = [
        .biometric,
        .pincode,
        .password,
        .deleteAccount
    ]
    
    public let viewModel: ProfileViewModel
    public weak var coordinator: CommonCoordinatorProtocol?

    public init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    public override func setupViews() {
        container.addSubview(table)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func autolayout() {
        table.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        table.reloadData()
    }
}
