//
//  OrderProductRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 24/10/22.
//

import UIKit
import OlchaUI
class OrderPaymentProductRoom: BaseTableCell {
    private let productImage = UIImageView()
    private let adultChecker = AdultChecker(withTitle: false)
    private let productTitle = UILabel()
    private let productPrice = UILabel()
    
    private let dateTitle = UILabel()
    private let dateValue = UILabel()
    private let statusTitle = UILabel()
    private let statusValue = UILabel()
    private let checkButtonContainer = UIView()
    let checkButton: IButton = {
        let button = IButton()
        button.setTitleColor(.olchaBlue, for: .normal)
        button.titleLabel?.style(.medium, 14)
        let title = "show_check".localized()
        let attributedTitle = NSAttributedString(string: title, attributes: [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .underlineColor: UIColor.olchaBlue
        ])
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
    }()
    let reviewButton = OlchaButton()
    
    let separator = Divide()
    
    var product: ProductModel?
    
    private let titleStack = UIStackView()
    private let dateTitleContainer = UIView()
    private let statusTitleContainer = UIView()
    
    let bottomSection = OrderProductViewDescriptionView()
    
    var isOpened: Bool = true {
        didSet {
            bottomSection.isOpened = isOpened
        }
    }
    
    override func setupViews() {
        container.addSubview(separator)
        container.addSubview(productImage)
        container.addSubview(adultChecker)
        container.addSubview(titleStack)
        titleStack.addArrangedSubview(productTitle)
        titleStack.addArrangedSubview(productPrice)
        titleStack.addArrangedSubview(dateTitleContainer)
        titleStack.addArrangedSubview(statusTitleContainer)
        titleStack.addArrangedSubview(checkButtonContainer)
        checkButtonContainer.addSubview(checkButton)
        titleStack.addArrangedSubview(reviewButton)
        statusTitleContainer.addSubview(statusTitle)
        statusTitleContainer.addSubview(statusValue)
        
        dateTitleContainer.addSubview(dateTitle)
        dateTitleContainer.addSubview(dateValue)
        
        container.addSubview(bottomSection)
    }
    
    override func autolayout() {
        
        productImage.snp.remakeConstraints { make in
            make.width.height.equalTo(64)
            make.top.equalTo(separator.snp.bottom).inset(-16)
            make.left.equalToSuperview().inset(16)
        }
        
        adultChecker.snp.makeConstraints { make in
            make.edges.equalTo(productImage)
        }
        
        separator.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview()
        }
        
        titleStack.snp.makeConstraints { make in
            make.left.equalTo(productImage.snp.right).inset(-8)
            make.top.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16)

        }
        
        checkButtonContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        checkButton.snp.makeConstraints { make in
            make.bottom.top.left.equalToSuperview()
            make.right.lessThanOrEqualToSuperview()
        }
        
        dateTitle.snp.makeConstraints { make in
            make.top.bottom.left.equalToSuperview()
        }
        
        dateValue.snp.makeConstraints { make in
            make.left.equalTo(dateTitle.snp.right).inset(-2)
            make.top.bottom.equalToSuperview()
        }
        
        statusTitle.snp.makeConstraints { make in
            make.top.bottom.left.equalToSuperview()
        }
        
        statusValue.snp.makeConstraints { make in
            make.left.equalTo(statusTitle.snp.right).inset(-2)
            make.top.bottom.equalToSuperview()
        }
     
        reviewButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
        }
        
        productTitle.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        productPrice.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        dateTitleContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        statusTitleContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        bottomSection.snp.makeConstraints { make in
            make.top.equalTo(titleStack.snp.bottom).inset(-4)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    override func configureViews() {
        
        titleStack.axis = .vertical
        titleStack.spacing = 8
        titleStack.setCustomSpacing(4, after: dateTitleContainer)
        titleStack.alignment = .trailing
        
        productTitle.style(.semibold, 14)
        productTitle.numberOfLines = 3
        productTitle.textColor = .olchaTextBlack
        productTitle.text = " "
        
        productPrice.style(.bold, 16)
        productPrice.textColor = .olchaTextBlack
        
        dateTitle.style(.medium, 14)
        dateTitle.text = "order_date".localized() + ": "
        dateTitle.textColor = .olchaLightTextColornnnnnn
        
        statusTitle.style(.medium, 14)
        statusTitle.text = "status".localized() + ": "
        statusTitle.textColor = .olchaLightTextColornnnnnn
        
        dateValue.style(.medium, 14)
        dateValue.textColor = .olchaTextBlack
        dateValue.textAlignment = .left
        
        statusValue.style(.medium, 14)
        statusValue.textAlignment = .left
        
        reviewButton.setTitle("add_review".localized())
        reviewButton.isHidden = true
    }
    
    func setup(with data: ProductModel?,
               date: String?) {
        reviewButton.isHidden = !(data?.can_comment ?? false)
        self.product = data
        productImage.load(from: data?.main_image,
                          imageType: .quadratic)

        productTitle.text = data?.getName()
        productPrice.text = data?.price?.price
        
        dateValue.text = date ?? ""
        checkQR()
        adultChecker.check(data)
        statusValue.text = data?.status_name
        if let hexColor = data?.status_color {
            let color = UIColor.hex(hexColor)
            statusValue.textColor = color
        } else {
            statusValue.textColor = .olchaTextBlack
        }
        
        bottomSection.setup(title: data?.status_description)
    }
    
    private func checkQR() {
        let isQRHidden = ((product?.qrcode ?? "") == "")
        checkButton.isHidden = isQRHidden
    }
    
}
