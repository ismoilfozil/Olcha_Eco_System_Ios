//
//  PaymentTypeRoom.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 12/02/23.
//

import UIKit
import OlchaUI
public class PaymentTypeRoom: BaseTableCell {

    
    private lazy var icon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
//        imageView.backgroundColor = .olchaLightNeutralGray
//        imageView.round(8)
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.textColor = .olchaTextBlack
        label.numberOfLines = 0
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.text = "                                                                                                   "
        return label
    }()
    
    private lazy var disabledTitle: UILabel = {
        let label = UILabel()
        label.style(.medium, 10)
        label.textColor = .olchaAccentColor
        label.text = "profilactica".localized()
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.isHidden = true
        return label
    }()
    
    private lazy var disableContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.05)
        view.isHidden = true
        return view
    }()
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        icon.image = nil
        titleLabel.text = ""
        disabledTitle.isHidden = true
        disableContainer.isHidden = true
    }
    
    public override func setupViews() {
        container.addSubview(icon)
        container.addSubview(titleLabel)
        container.addSubview(disabledTitle)
        container.addSubview(disableContainer)
    }
    
    public override func autolayout() {
        
        icon.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(12)
            make.top.bottom.equalToSuperview().inset(12)
            make.width.height.equalTo(36)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(2)
            make.left.equalTo(icon.snp.right).inset(-8)
        }
        
        disabledTitle.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right).inset(-4)
            make.top.bottom.equalToSuperview().inset(2)
            make.right.equalToSuperview().inset(8)
        }
        
        disableContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        horizontalEdge = 16
        verticalEdge = 4
    }
    
    public override func configureViews() {
        container.round()
        container.border(with: .olchaLightNeutralDarkGray)
        
        makeSkeleton(views: [
            container,
            icon,
            titleLabel
        ])
        disabledTitle.isHiddenWhenSkeletonIsActive = true
        disableContainer.isHiddenWhenSkeletonIsActive = true
    }
    
    public func setup(title: String?, image: String?) {
        icon.load(from: image)
        
        titleLabel.text = title
    }
    
    public func checkState(isDisabled: Bool) {
        disableContainer.isHidden = !isDisabled
        disabledTitle.isHidden = !isDisabled
    }
}
