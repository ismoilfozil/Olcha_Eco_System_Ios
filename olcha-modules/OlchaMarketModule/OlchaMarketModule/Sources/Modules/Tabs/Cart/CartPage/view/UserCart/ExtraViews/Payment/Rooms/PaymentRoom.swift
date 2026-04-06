//
//  File.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 07/02/24.
//

import UIKit
import OlchaUI
class PaymentRoom: BaseTableCell {
    
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .fill
        return stackView
    }()
    
    private let leftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .radio_unselected
        return imageView
    }()
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 2
        stackView.axis = .vertical
        stackView.alignment = .leading
        return stackView
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 16)
        label.textColor = .olchaTextBlack
        label.numberOfLines = 0
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 10)
        label.textColor = .olchaLightTextColornnnnnn
        label.numberOfLines = 0
        return label
    }()
    
    let separator = Divide()
    
    var isChosen: Bool = false {
        didSet {
            leftImageView.image = isChosen ? .round_selected_check : .round_unselected_check
        }
    }
    
    override func setupViews() {
        container.addSubview(leftImageView)
        container.addSubview(contentStackView)
        contentStackView.addArrangedSubview(iconImageView)
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(iconImageView)
        contentStackView.addArrangedSubview(subtitleLabel)
        container.addSubview(separator)
    }
    
    override func autolayout() {
        
        leftImageView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.left.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(100)
            make.left.equalToSuperview()
        }
        
        contentStackView.snp.makeConstraints { make in
            make.right.top.bottom.equalToSuperview().inset(16)
            make.left.equalTo(leftImageView.snp.right).inset(-16)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        separator.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }
    
    func setup(title: String, imageURL: String, subtitle: String) {
        
        titleLabel.text = title
        titleLabel.isHidden = title == ""
        
        subtitleLabel.text = subtitle
        subtitleLabel.isHidden = subtitle == ""
        
        iconImageView.load(from: imageURL)
        iconImageView.isHidden = imageURL == ""
        titleLabel.isHidden = imageURL != ""
    }
}
