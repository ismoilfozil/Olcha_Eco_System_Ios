//
//  PDFinvoice.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 22/09/23.
//

import UIKit
import OlchaUI

public class PDFinvoice: BaseView {
    
    private let logo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .olchaInvoiceIcon
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private let bottomSeparator = Divide()
    
    private let sections: [Section] = [
        .sender,
        .receiver,
        .total
    ]
    
    private var transaction: TransactionModel?
    
    public override func setupViews() {
        addSubview(logo)
        addSubview(mainStackView)
        addSubview(bottomSeparator)
    }
    
    public override func autolayout() {
        logo.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
        
        mainStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(logo.snp.bottom).inset(-16)
        }
        
        bottomSeparator.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview().inset(16)
        }
    }
    
    public override func configureViews() {
        backgroundColor = .olchaWhite
    }
    
    public func setup(transaction: TransactionModel?) {
        self.transaction = transaction
        createSections()
    }
}


private extension PDFinvoice {
    func createSections() {
        mainStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for section in sections {
            switch section {
            case .sender:
                mainStackView.addArrangedSubview(
                    getTitlesView(title: "sender_card".localized(),
                                  value: transaction?.card_id?.bank_card?.getSpacedPan())
                )
                
                mainStackView.addArrangedSubview(
                    getTitlesView(title: "sender".localized(),
                                  value: transaction?.card_id?.bank_card?.full_name)
                )
                
                mainStackView.addArrangedSubview(Divide())
                
                break
            case .receiver:
                for field in (transaction?.fields ?? []).filter ({ $0.is_money == false }) {
                    mainStackView.addArrangedSubview(
                        getTitlesView(title: field.key,
                                      value: field.value)
                    )
                }
                mainStackView.addArrangedSubview(
                    getTitlesView(title: "date".localized(),
                                  value: transaction?.dateTime())
                )
                mainStackView.addArrangedSubview(Divide())
                break
            case .total:
                mainStackView.addArrangedSubview(
                    getTitlesView(title: "status".localized(),
                                  value: transaction?.getStatus())
                )
                mainStackView.addArrangedSubview(
                    getTitlesView(title: "summa".localized(),
                                  value: transaction?.amount?.string.originalPrice)
                )
                break
            }
        }
    }
    
    func getTitlesView(title: String?,
                       titleFont: UIFont = .style(.medium, 12),
                       titleColor: UIColor? = .olchaDarkGray,
                       value: String?,
                       valueFont: UIFont = .style(.medium, 12),
                       valueColor: UIColor? = .olchaTextBlack
    ) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 2
        stack.distribution = .equalCentering
        
        
        let titleLabel = UILabel()
        titleLabel.text = title ?? " - "
        titleLabel.style(.medium, 8)
        titleLabel.textAlignment = .left
        titleLabel.textColor = .olchaDarkGray
        
        let valueLabel = UILabel()
        valueLabel.text = value ?? " - "
        valueLabel.style(.medium, 8)
        valueLabel.textAlignment = .right
        valueLabel.textColor = .olchaTextBlack
        
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(valueLabel)
        
        
        return stack
    }
}

extension PDFinvoice {
    public enum Section {
        case sender
        case receiver
        case total
    }
}
