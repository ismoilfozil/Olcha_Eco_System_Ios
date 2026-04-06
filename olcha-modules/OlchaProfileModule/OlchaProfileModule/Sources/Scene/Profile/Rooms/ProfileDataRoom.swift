////
////  ProfileDataRoom.swift
////  OlchaProfileModule
////
////  Created by Elbek Khasanov on 20/09/23.
////
//
//import UIKit
//import OlchaUI
//
//class ProfileDataRoom: BaseTableCell {
//    
//    private lazy var contentIcon: UIImageView = {
//        let imageView = UIImageView()
//        return imageView
//    }()
//    
//    private lazy var nameLabel: UILabel = {
//        let label = UILabel()
//        label.style(.medium, 16)
//        label.textColor = .olchaTextBlack
//        return label
//    }()
//    
//    override func setupViews() {
//        container.addSubview(contentIcon)
//        container.addSubview(nameLabel)
//    }
//    
//    override func autolayout() {
//        contentIcon.snp.makeConstraints { make in
//            make.left.equalToSuperview().inset(16)
//            make.top.bottom.equalToSuperview().inset(8)
//            make.width.height.equalTo(24)
//        }
//        
//        nameLabel.snp.makeConstraints { make in
//            make.right.top.bottom.equalToSuperview().inset(12)
//            make.left.equalTo(contentIcon.snp.right).inset(-12)
//        }
//    }
//    
//    func setup(icon: UIImage?, title: String?) {
//        contentIcon.image = icon
//        nameLabel.text = title
//    }
//}
