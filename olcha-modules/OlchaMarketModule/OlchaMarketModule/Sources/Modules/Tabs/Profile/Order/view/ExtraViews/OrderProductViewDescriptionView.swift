//
//  OrderProductViewDescriptionView.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 22/12/23.
//

import UIKit
import OlchaUI

public class OrderProductViewDescriptionView: BaseView {
    
    private let container: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private let topSeparator = Divide()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.textColor = .olchaTextBlack
        label.numberOfLines = 0
        label.text = ""
        label.isHidden = true
        return label
    }()
    
    private let bottomSeparator: Divide = {
        let view = Divide()
        view.isHidden = true
        return view
    }()
    
    private let moreButtonContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .olchaLightNeutralGray
        view.round(12, topCorner: false, bottomCorner: true)
        return view
    }()
    
    private let moreButtonStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    private let moreButtonIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .arrow_down
        return imageView
    }()
    
    private let moreButtonLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.textColor = .olchaTextBlack
        label.text = "more_information".localized()
        return label
    }()
    
    let moreButton = IButton()
    
    var isOpened: Bool = false {
        didSet {
            descriptionLabel.isHidden = !isOpened
            bottomSeparator.isHidden = !isOpened
            moreButtonIcon.image = isOpened ? .arrow_up : .arrow_down
        }
    }
    
    public override func setupViews() {
        addSubview(container)
        container.addArrangedSubview(topSeparator)
        container.addArrangedSubview(descriptionLabel)
        container.addArrangedSubview(bottomSeparator)
        container.addArrangedSubview(moreButtonContainer)
        moreButtonContainer.addSubview(moreButtonStack)
        moreButtonStack.addArrangedSubview(moreButtonLabel)
        moreButtonStack.addArrangedSubview(moreButtonIcon)
        moreButtonContainer.addSubview(moreButton)
    }
    
    public override func autolayout() {
        container.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }
        
        topSeparator.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        bottomSeparator.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        moreButtonContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(48)
        }
        
        moreButtonStack.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        moreButtonLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
        }
        
        moreButtonIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        moreButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        isOpened = false
        moreButton.round(16, topCorner: false, bottomCorner: true)
        container.setCustomSpacing(0, after: bottomSeparator)
    }
    
    func setup(title: String?) {
        descriptionLabel.text = title ?? " - "
        moreButtonLabel.text = "more_information".localized()
    }
}
