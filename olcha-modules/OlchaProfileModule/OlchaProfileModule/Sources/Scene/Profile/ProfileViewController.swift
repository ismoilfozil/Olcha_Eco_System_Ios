////
////  ProfileViewController.swift
////  OlchaProfileModule
////
////  Created by Elbek Khasanov on 19/09/23.
////
//
//import UIKit
//import OlchaUI
//
//public class ProfileViewController: BaseViewController<TitleNavigationBar> {
//    
//    private lazy var table: UITableView = {
//        let table = UITableView(frame: .zero, style: .insetGrouped)
//        table.delegate = self
//        table.dataSource = self
//        table.registerClass(forCell: ProfileDataRoom.self)
//        table.configure()
//        table.separatorColor = .olchaLightNeutralGray
//        table.separatorStyle = .singleLine
//        table.separatorInset = .init(top: 0, left: 54, bottom: 0, right: 16)
//        return table
//    }()
//    
//    public override func setupViews() {
//        container.addSubview(table)
//    }
//    
//    public override func autolayout() {
//        table.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//    }
//    
//}
