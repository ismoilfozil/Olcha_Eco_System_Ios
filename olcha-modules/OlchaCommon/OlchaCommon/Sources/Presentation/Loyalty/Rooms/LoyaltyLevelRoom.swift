//
//  LoyaltyLevelRoom.swift
//  OlchaCommon
//
//  Created by Elbek Khasanov on 21/07/24.
//

import UIKit
import OlchaUI
public class LoyaltyLevelRoom: BaseTableCell {
    
    private let levelTitleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 12)
        label.textColor = .olchaLightTextColornnnnnn
        label.text = "your_level".localized()
        return label
    }()
    
    private let levelValueLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 24)
        label.textColor = .olchaTextBlack
        return label
    }()
    
    private let levelImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let percentagesContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }()
    
    private let cashbackStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    private let saleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    private let cashbackPercentageLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 18)
        label.textColor = .olchaTextBlack
        return label
    }()
    
    private let cashbackTitleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 12)
        label.textColor = .olchaTextBlack
        label.numberOfLines = 2
        label.text = "cashback_for_purchase".localized()
        return label
    }()
    
    private let salePercentageLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 18)
        label.textColor = .olchaTextBlack
        return label
    }()
    
    private let saleTitleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 12)
        label.textColor = .olchaTextBlack
        label.numberOfLines = 2
        label.text = "sale_for_purchase".localized()
        return label
    }()
    
    private let gradientView: GradusGradientView = {
        let view = GradusGradientView()
        view.secondColor = .lightGrayBackground ?? .lightGray
        view.angleº = 240
        view.fadeIntensity = 0.7
        view.alpha = 0.5
        return view
    }()
    
    public override func setupViews() {
        container.addSubview(gradientView)
        container.addSubview(levelTitleLabel)
        container.addSubview(levelValueLabel)
        container.addSubview(levelImageView)
        
        container.addSubview(percentagesContainer)
        
        percentagesContainer.addArrangedSubview(cashbackStackView)
        percentagesContainer.addArrangedSubview(saleStackView)
        
        cashbackStackView.addArrangedSubview(cashbackPercentageLabel)
        cashbackStackView.addArrangedSubview(cashbackTitleLabel)
        
        saleStackView.addArrangedSubview(salePercentageLabel)
        saleStackView.addArrangedSubview(saleTitleLabel)
    }
    
    public override func autolayout() {
        horizontalEdge = 16
        verticalEdge = 8
        
        levelTitleLabel.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(16)
        }
        
        levelValueLabel.snp.makeConstraints { make in
            make.top.equalTo(levelTitleLabel.snp.bottom).inset(-4)
            make.left.equalToSuperview().inset(16)
        }
        
        levelImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.right.equalToSuperview().inset(16)
            make.width.height.equalTo(64)
        }
        
        percentagesContainer.snp.makeConstraints { make in
            make.top.equalTo(levelValueLabel.snp.bottom).inset(-12)
            make.left.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
            make.right.lessThanOrEqualToSuperview()
        }
    
        cashbackStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
        }
        
        saleStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
        }
        
        cashbackTitleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        cashbackPercentageLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        salePercentageLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        saleTitleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        gradientView.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.bottom.right.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        container.round()
        container.backgroundColor = .lightGrayBackground ?? .lightGray
    }
    
    public func setupLevel(_ level: LoyaltyModel) {
        levelValueLabel.text = level.getTitle()
        cashbackPercentageLabel.text = level.getCashback().string.originalPriceWithoutCurrency + " %"
        salePercentageLabel.text = level.getSale().string.originalPriceWithoutCurrency + " %"
        levelImageView.image = level.getImage()
        gradientView.firstColor = level.getColor() ?? .olchaWhite
    }
    
}
