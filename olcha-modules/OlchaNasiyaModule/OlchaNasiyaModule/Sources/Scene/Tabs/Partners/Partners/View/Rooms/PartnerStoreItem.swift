//
//  PartnerStoreItem.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 18/05/23.
//

import UIKit
import OlchaUI
public class PartnerStoreItem: BaseCollectionCell {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    public override func setupViews() {
        container.addSubview(imageView)
    }
    
    public override func autolayout() {
        horizontalEdge = 8
        verticalEdge = 6
        imageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.left.right.equalToSuperview().inset(8)
        }
    }
    
    public override func configureViews() {
        container.backgroundColor = .lightGrayBackground
        container.round()
        
        setupSkeleton()
    }
    
    private func setupSkeleton() {
        makeSkeleton(views: [
            container,
            imageView
        ])
    }
    
    public func setup(with data: String?) {
        imageView.load(from: data, imageType: .flexible, contentMode: .scaleAspectFit)
    }
}
