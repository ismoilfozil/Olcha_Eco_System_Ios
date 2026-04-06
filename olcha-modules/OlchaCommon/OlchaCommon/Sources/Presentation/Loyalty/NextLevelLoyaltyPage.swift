//
//  NextLevelLoyaltyPage.swift
//  OlchaCommon
//
//  Created by Elbek Khasanov on 06/07/24.
//

import UIKit
import OlchaUI
public class NextLevelLoyaltyPage: BaseModalViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 18)
        label.textColor = .olchaTextBlack
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let loyaltyImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private let loyaltyTitleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 18)
        label.textColor = .olchaTextBlack
        return label
    }()
    
    private let loyaltySubtitleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 16)
        label.textColor = .olchaTextBlack
        return label
    }()
    
    private let featuresStackView: UIStackView = {
        let stackView = UIStackView()
        return stackView
    }()
    
    private let cancelButton: OlchaButton = {
        let button = OlchaButton()
        button.setTitle("understand".localized())
        return button
    }()
    
    public override func setupViews() {
        container.addSubview(titleLabel)
        
        container.addSubview(loyaltyImageView)
        container.addSubview(loyaltyTitleLabel)
        container.addSubview(loyaltySubtitleLabel)
        container.addSubview(featuresStackView)
        container.addSubview(cancelButton)
    }
    
    public override func autolayout() {
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(16)
        }
        
        loyaltyImageView.snp.makeConstraints { make in
            make.width.height.equalTo(60)
            make.top.equalTo(titleLabel.snp.bottom).inset(-8)
            make.left.equalToSuperview().inset(16)
        }
        
        loyaltyTitleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(loyaltyImageView.snp.centerY)
            make.left.equalTo(loyaltyImageView.snp.right).inset(-16)
            make.right.equalToSuperview().inset(16)
        }
        
        loyaltySubtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(loyaltyImageView.snp.centerY)
            make.left.equalTo(loyaltyImageView.snp.right).inset(-16)
            make.right.equalToSuperview().inset(16)
        }
        
        featuresStackView.snp.makeConstraints { make in
            make.top.equalTo(loyaltyImageView.snp.bottom).inset(-24)
            make.left.right.equalToSuperview().inset(16)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
            make.top.equalTo(featuresStackView.snp.bottom).inset(-24)
        }
    }
    
    public override func configureViews() {
        xButton.isHidden = true
    }
    
    private func getFeatureView() -> UIView {
        let view = UIView()
        
        let percentageLabel = UILabel()
        percentageLabel.style(.semibold, 16)
        percentageLabel.textColor = .olchaTextBlack
        
        let descriptionLabel = UILabel()
        descriptionLabel.textColor = .olchaTextBlack
        descriptionLabel.style(.medium, 14)
        descriptionLabel.numberOfLines = 0
        
        view.addSubview(percentageLabel)
        view.addSubview(descriptionLabel)
                
        return view
    }
}
