//
//  CategoryItem.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 27/03/23.
//

import UIKit
import OlchaUI
public class CategoryItem: BaseCollectionCell {

    private lazy var icon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage()
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 14)
        label.textColor = .olchaTextBlack
        label.numberOfLines = 2
        label.textAlignment = .center
        label.text = "                                  "
        return label
    }()
    
    public override func prepareForReuse() {
        icon.image = nil
        titleLabel.text = "                 "
        super.prepareForReuse()
    }
    
    public override func setupViews() {
        container.addSubview(icon)
        container.addSubview(titleLabel)
    }
    
    public override func autolayout() {
        horizontalEdge = 4
        verticalEdge = 4
        
        icon.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.top.equalToSuperview().inset(24)
            make.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview().inset(4)
            make.top.equalTo(icon.snp.bottom).inset(-4)
        }
    }
    
    public override func configureViews() {
        container.round()
        makeSkeleton(views: [
            container,
            icon,
            titleLabel
        ])
    }
    
    func setup(with data: CategoryModel?) {
        titleLabel.text = data?.getTitle()
        icon.load(from: data?.logo)
    }
    
}
