//
//  SettingsViewController.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 05/03/23.
//

import UIKit
import OlchaUI
public class SettingsViewController: BaseViewController<BackNavigationBar> {
    
    private lazy var table: BaseTableView = {
        let table = BaseTableView()
        table.delegate = self
        table.dataSource = self
        table.configure()
        table.registerClass(forCell: SettingsPincodeRoom.self)
        table.registerClass(forCell: SettingsLanguageRoom.self)
        table.registerClass(forCell: SettingsPushRoom.self)
        table.registerClass(forCell: ProfileMenuRoom.self)
        return table
    }()

    let sections: [Section] = [
        .language,
        .pincode,
        .push,
        .editPincode
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
        navigationBar.setTitle("settings".localized())
    }
    
    public override func languageUpdated() {
        navigationBar.setTitle("settings".localized())
        table.reloadData()
    }
    
}
