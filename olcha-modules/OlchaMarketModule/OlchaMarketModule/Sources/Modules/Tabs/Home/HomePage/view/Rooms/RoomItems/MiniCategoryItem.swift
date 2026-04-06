//
//  MiniCategoryItem.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 30/06/22.
//

import UIKit
import OlchaUI
class MiniCategoryItem: BaseCollectionCell {
    
    private let imageViewContainer: UIView = {
        let view = UIView()
        view.round(32)
        view.backgroundColor = .clear
        return view
    }()
    private let imageView = UIImageView()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 11)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.text = "\t\t\t"
        return label
    }()

    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = "\t\t\t"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        skeletonViews.forEach({ $0.layoutSkeletonIfNeeded() })
    }
    
    override func setupViews() {
        container.addSubview(imageViewContainer)
        imageViewContainer.addSubview(imageView)
        container.addSubview(titleLabel)
    }
    
    
    override func configureViews() {
        backgroundColor = .olchaWhite
        skeletonConfiguration()
    }
    
    private func skeletonConfiguration() {
        makeSkeleton(views: [
            imageViewContainer,
            titleLabel,
        ])
        titleLabel.skeletonConfiguration(
            lines: .custom(2),
            lastLinePercentage: 70,
            height: .relativeToConstraints
        )
    }
    
    override func autolayout() {
        
        imageViewContainer.snp.makeConstraints { make in
            make.centerX.top.equalToSuperview()
            make.width.height.equalTo(64)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageViewContainer.snp.bottom).inset(-8)
            make.left.right.equalToSuperview().inset(8)
            make.bottom.equalToSuperview()
        }
    }
    
    func setup(with data: CategoryModel?, isIcon: Bool) {
        titleLabel.text = data?.getName()
        imageView.load(from: isIcon ? data?.home_image : data?.main_image,
                       imageType: .quadratic)
    }
    
}
