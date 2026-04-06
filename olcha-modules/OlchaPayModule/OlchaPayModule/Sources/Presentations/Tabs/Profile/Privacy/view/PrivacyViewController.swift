//
//  PrivacyViewController.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 05/03/23.
//

import UIKit
import OlchaUI

public class PrivacyViewController: BaseViewController<BackNavigationBar> {

    private lazy var table: BaseTableView = {
        let table = BaseTableView()
        table.delegate = self
        table.dataSource = self
        table.registerClass(forCell: ProfileMenuRoom.self)
        table.configure()
        return table
    }()
    
    let sections: [Section] = [
        .offerta,
        .privacy_policy,
        .call,
        .message
    ]
    
    weak var coordinator: ProfileCoordinatorProtocol?
    
    public override func setupViews() {
        container.addSubview(table)
    }
    
    public override func autolayout() {
        table.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        navigationBar.setTitle("support".localized())
    }
    
}
