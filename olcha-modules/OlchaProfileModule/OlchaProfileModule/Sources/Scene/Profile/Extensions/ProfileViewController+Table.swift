////
////  ProfileViewController+Table.swift
////  OlchaProfileModule
////
////  Created by Elbek Khasanov on 20/09/23.
////
//
//import UIKit
////import OlchaUI
//
//extension ProfileViewController: TableDelegates {
//    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        2
//    }
//    
//    public func numberOfSections(in tableView: UITableView) -> Int {
//        2
//    }
//    
//    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeue(ProfileDataRoom.self, for: indexPath)
//        cell.setup(icon: .user, title: "Moi zakazi")
//        return cell
//    }
//    
//    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view = ProfileHeaderView()
//        view.setup(with: "Header 1")
//        return view
//    }
//        
//    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        UITableView.automaticDimension
//    }
//}
