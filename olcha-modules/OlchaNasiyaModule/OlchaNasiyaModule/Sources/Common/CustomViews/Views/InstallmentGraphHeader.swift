//
//  InstallmentGraphHeader.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 17/05/23.
//

import UIKit
import OlchaUI

public class InstallmentGraphHeader: BaseView {
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .olchaTextBlack
        label.style(.semibold, 20)
        label.textAlignment = .left
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.style(.regular, 14)
        label.textColor = .olchaLightTextColornnnnnn
        return label
    }()
    
    private lazy var indicatorContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .olchaLightNeutralGray
        view.round(3)
        return view
    }()
    
    private lazy var indicator: UIView = {
        let view = UIView()
        view.backgroundColor = .olchaPrimaryColor
        view.round(3)
        return view
    }()
    
    private let headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .firstBaseline
        return stackView
    }()
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .firstBaseline
        return stackView
    }()
    
    private let paidLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.textColor = .olchaLightTextColornnnnnn
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    public let paidContent: UILabel = {
        let label = UILabel()
        label.style(.semibold, 16)
        label.textColor = .olchaTextBlack
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let needLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.textColor = .olchaLightTextColornnnnnn
        label.textAlignment = .right
        label.numberOfLines = 0
        return label
    }()
    
    public let needContent: UILabel = {
        let label = UILabel()
        label.style(.semibold, 16)
        label.textColor = .olchaTextBlack
        label.textAlignment = .right
        label.numberOfLines = 0
        return label
    }()
    
    public override func setupViews() {
        addSubview(titleLabel)
        addSubview(amountLabel)
        
        addSubview(indicatorContainer)
        indicatorContainer.addSubview(indicator)
        
        addSubview(headerStackView)
        headerStackView.addArrangedSubview(paidLabel)
        headerStackView.addArrangedSubview(needLabel)
        
        addSubview(contentStackView)
        contentStackView.addArrangedSubview(paidContent)
        contentStackView.addArrangedSubview(needContent)
    }
    
    public override func autolayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        amountLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).inset(-4)
        }
        
        indicatorContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(6)
            make.top.equalTo(amountLabel.snp.bottom).inset(-20)
        }
        
        indicatorConstraint(offset: 1)
        
        headerStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(indicatorContainer.snp.bottom).inset(-12)
        }
        
        contentStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(headerStackView.snp.bottom).inset(-2)
            make.bottom.equalToSuperview()
        }
    }
    
    public func setup(with data: InstallmentGraphModel?) {
        titleLabel.text = "order_num".localized() + (data?.id ?? 0).string
        amountLabel.text = data?.total_pay?.string.originalPrice
        
        paidLabel.text = "paid".localized(.olchaNasiyaModule)
        needLabel.text = "need_pay".localized(.olchaNasiyaModule)
        
        paidContent.text = data?.paid?.string.originalPrice
        needContent.text = data?.need_pay?.string.originalPrice
        
        guard let paid = data?.paid,
              let totalPay = data?.total_pay,
              totalPay != 0 else {
            indicatorConstraint(offset: 0)
            return
        }
        
        indicatorConstraint(offset: paid.cgfloat / totalPay.cgfloat, animated: true)
        
    }
    
    private func indicatorConstraint(offset: CGFloat, animated: Bool = false) {
        indicator.snp.remakeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(offset)
        }
        if animated {
            UIView.animate(withDuration: 0.3, animations: {
                self.layoutIfNeeded()
            })            
        }
    }
}
