//
//  SuggestionCollectionCell.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 15/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

public class SuggestionCollectionCell: BaseCollectionCell {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var titleBackgroundGradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        let gradientColor = UIColor.hex("#0A0909")
        gradient.colors = [gradientColor.withAlphaComponent(0.0).cgColor, gradientColor.withAlphaComponent(0.3).cgColor, gradientColor.withAlphaComponent(0.6).cgColor]
        gradient.locations = [0.0, 0.7, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        return gradient
    }()
    
    private let titleBackground = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 12)
        label.textColor = .white
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    public override func setupViews() {
        container.addSubview(imageView)
        container.addSubview(titleBackground)
        titleBackground.addSubview(titleLabel)
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = "\t"
        titleBackground.removeCAGradientLayers()
    }
    
    public override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        titleBackgroundGradient.frame = titleBackground.bounds
    }
    
    public override func autolayout() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        titleBackground.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(titleLabel.snp.top).offset(-4)
        }
        titleLabel.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview().inset(8)
        }
    }
    
    public override func configureViews() {
        container.round()
        configureSkeleton()
    }

    private func setGradient() {
        titleBackground.removeCAGradientLayers()
        titleBackground.layer.insertSublayer(titleBackgroundGradient, at: 0)
        container.layoutIfNeeded()
    }
    
    public func setup(with data: SuggestionItemModel) {
        titleLabel.text = data.title.unwrap
        imageView.load(from: data.image.unwrap)
        setGradient()
    }
    
}

private extension SuggestionCollectionCell {
    func configureSkeleton() {
        makeSkeleton(views: [
            imageView
        ])
    }
}
