//
//  PayedHeaderRoom.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 23/02/23.
//

import UIKit
import OlchaUI
public class PayedHeaderRoom: BaseTableCell {
    private lazy var stackContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var icon: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 16)
        label.textColor = .olchaTextBlack
        label.text = " - "
        label.numberOfLines = 0
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 16)
        label.textColor = .olchaTextBlack
        label.text = " - "
        label.textAlignment = .right
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        icon.image = nil
    }
    
    public override func setupViews() {
        container.addSubview(stackContainer)
        stackContainer.addArrangedSubview(icon)
        stackContainer.addArrangedSubview(titleLabel)
        stackContainer.addArrangedSubview(valueLabel)
    }
    
    public override func autolayout() {
        stackContainer.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }
        
        icon.snp.makeConstraints { make in
            make.width.height.equalTo(48)
        }
    }
    
    public func setup(with data: TransactionModel?) {
        icon.load(from: data?.provider_service?.providers?.logo?.logo)
        titleLabel.text = data?.provider_service?.providers?.title_short
        valueLabel.text = data?.amount?.string.originalPrice
        
    }
}
