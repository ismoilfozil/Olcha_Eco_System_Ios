//
//  SafetyViewController.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 23/05/23.
//

import UIKit
import OlchaUI
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
        .password
    ]
    
    public weak var coordinator: ProfileCoordinatorProtocol?

    public override func setupViews() {
        container.addSubview(table)
    }
    
    public override func autolayout() {
        table.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
