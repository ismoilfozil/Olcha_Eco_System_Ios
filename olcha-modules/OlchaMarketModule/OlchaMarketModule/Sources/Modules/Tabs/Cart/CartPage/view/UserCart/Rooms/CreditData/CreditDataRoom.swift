//
//  CreditDataRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 04/10/22.
//

import UIKit
import OlchaUI
class CreditDataRoom: BaseTableCell {
    
    enum CreditData {
        case term
        case firstFee
        case permonth
        
        var title: String {
            switch self {
            case .term:
                return "installment_month".localized()
            case .firstFee:
                return "first_payment".localized()
            case .permonth:
                return "permonth_payment".localized()
            }
        }
    }
    
    private let titleLabel = UILabel()
    
    private let dataContainer = UIStackView()
    
    private let separator = Divide()
    
    private let creditDatas: [CreditData] = [
        .term,
        .firstFee,
        .permonth
    ]
    
    override func setupViews() {
        container.addSubview(titleLabel)
        container.addSubview(dataContainer)
        container.addSubview(separator)
    }
    
    override func autolayout() {
        
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview()
        }
        
        dataContainer.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-8)
            make.left.right.equalToSuperview().inset(16)
        }
        
        separator.snp.makeConstraints { make in
            make.top.equalTo(dataContainer.snp.bottom).inset(-24)
            make.left.equalToSuperview().inset(16)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    override func configureViews() {
        titleLabel.style(.semibold, 24)
        titleLabel.textColor = .olchaTextBlack
        
        
        dataContainer.axis = .vertical
        dataContainer.spacing = 4
    }
    
    
    private func fillLabels(data: CartCreditData) {
        dataContainer.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for credit in creditDatas {
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.spacing = 12
            stack.distribution = .fillEqually
            
            let titleLabel = UILabel()
            titleLabel.style(.medium, 14)
            titleLabel.textColor = .olchaLightTextColornnnnnn
            titleLabel.text = credit.title
            
            let valueLabel = UILabel()
            valueLabel.style(.bold, 16)
            valueLabel.textColor = .olchaTextBlack
            
            stack.addArrangedSubview(titleLabel)
            stack.addArrangedSubview(valueLabel)
            
            switch credit {
            case .term:
                valueLabel.text = data.inst_pay_time.string.month
                break
            case .firstFee:
                valueLabel.text = data.first_fee_sum.string.price
                break
            case .permonth:
                valueLabel.text = data.monthly_payment.string.price
                break
            }
            dataContainer.addArrangedSubview(stack)
        }
    }
    
    func setup(with creditOrder: CreditOrder?) {
        titleLabel.text = "credit_type_olcha".localized() + " " + (creditOrder?.creditType.title ?? "")
        guard let creditOrder = creditOrder, let data = creditOrder.creditDatas[creditOrder.creditType] else {
            return
        }
        
        fillLabels(data: data)
        
    }
    
}

class CreditDataRoomView: BaseTableCellView {
    
    enum CreditData {
        case term
        case firstFee
        case permonth
        
        var title: String {
            switch self {
            case .term:
                return "installment_month".localized()
            case .firstFee:
                return "first_payment".localized()
            case .permonth:
                return "permonth_payment".localized()
            }
        }
    }
    
    private let titleLabel = UILabel()
    
    private let dataContainer = UIStackView()
    
    private let separator = Divide()
    
    private let creditDatas: [CreditData] = [
        .term,
        .firstFee,
        .permonth
    ]
    
    override func setupViews() {
        container.addSubview(titleLabel)
        container.addSubview(dataContainer)
        container.addSubview(separator)
    }
    
    override func autolayout() {
        
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview()
        }
        
        dataContainer.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-8)
            make.left.right.equalToSuperview().inset(16)
        }
        
        separator.snp.makeConstraints { make in
            make.top.equalTo(dataContainer.snp.bottom).inset(-24)
            make.left.equalToSuperview().inset(16)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    override func configureViews() {
        titleLabel.style(.semibold, 24)
        titleLabel.textColor = .olchaTextBlack
        
        
        dataContainer.axis = .vertical
        dataContainer.spacing = 4
    }
    
    
    private func fillLabels(data: CartCreditData) {
        dataContainer.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for credit in creditDatas {
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.spacing = 12
            stack.distribution = .fillEqually
            
            let titleLabel = UILabel()
            titleLabel.style(.medium, 14)
            titleLabel.textColor = .olchaLightTextColornnnnnn
            titleLabel.text = credit.title
            
            let valueLabel = UILabel()
            valueLabel.style(.bold, 16)
            valueLabel.textColor = .olchaTextBlack
            
            stack.addArrangedSubview(titleLabel)
            stack.addArrangedSubview(valueLabel)
            
            switch credit {
            case .term:
                valueLabel.text = data.inst_pay_time.string.month
                break
            case .firstFee:
                valueLabel.text = data.first_fee_sum.string.price
                break
            case .permonth:
                valueLabel.text = data.monthly_payment.string.price
                break
            }
            dataContainer.addArrangedSubview(stack)
        }
    }
    
    func setup(with creditOrder: CreditOrder?) {
        titleLabel.text = "credit_type_olcha".localized() + " " + (creditOrder?.creditType.title ?? "")
        guard let creditOrder = creditOrder, let data = creditOrder.creditDatas[creditOrder.creditType] else {
            return
        }
        
        fillLabels(data: data)
        
    }
    
}
