////
////  OnboardingImageRoom.swift
////  OlchaNasiyaModule
////
////  Created by Elbek Khasanov on 10/05/23.
////
//
//import UIKit
//import OlchaUI
//class OnboardingImageRoom: BaseCollectionCell {
//
//    private let imageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFit
//        return imageView
//    }()
//    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        imageView.image = nil
//    }
//    
//    override func setupViews() {
//        container.addSubview(imageView)
//    }
//    
//    override func autolayout() {
//        imageView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//    }
//    
//    func setup(image: UIImage?) {
//        imageView.image = image
//    }
//}
