//
//  PaymentGraphRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 24/10/22.
//

import UIKit
import Combine
import OlchaUI
class PaymentGraphRoom: BaseTableCell {
    
    private let containerStack = UIStackView()
    private let dateContainer = UIView()
    private let dateTitle = UILabel()
    private let expandeIcon = UIImageView()
    let dateButton = Button()
    
    weak var tableReloader: PassthroughSubject<Bool, Never>?
    
    private let dataSection = UIView()
    private let dataContainer = UIStackView()
    
    var isExpande: Bool = false {
        didSet {
            stateExpandeButton()
        }
    }
    
    var data: InstallmentResultData?
    
    override func setupViews() {
        container.addSubview(containerStack)
        containerStack.addArrangedSubview(dateContainer)
        dateContainer.addSubview(dateTitle)
        dateContainer.addSubview(expandeIcon)
        dateContainer.addSubview(dateButton)
        containerStack.addArrangedSubview(dataSection)
        dataSection.addSubview(dataContainer)
    }
    
    override func autolayout() {
        
        containerStack.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(8)
        }
        
        dataSection.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        dateContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        dataContainer.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview().inset(16)
            
            make.top.equalToSuperview().inset(2)
        }
        
        dateTitle.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(10)
        }
        
        expandeIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(16)
            make.width.height.equalTo(20)
        }
        
        dateButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureViews() {
        containerStack.round()
        containerStack.border()
        containerStack.axis = .vertical
        containerStack.spacing = 2
        
        dataContainer.axis = .vertical
        dataContainer.spacing = 8
        
        dateTitle.style(.medium, 14)
        
        expandeIcon.image = .down_anchor_black
    }
    
    
   private func getItem(title: String?, value: String?) -> UIView {
       let miniContainer = UIView()
           
       let valuesContainer = UIStackView()
       let titleLabel = UILabel()
       let valueLabel = UILabel()
       let separator = UILabel()
       
       miniContainer.addSubview(separator)
       miniContainer.addSubview(valuesContainer)
       valuesContainer.addArrangedSubview(titleLabel)
       valuesContainer.addArrangedSubview(valueLabel)
       
       
       itemConfiguration(valuesContainer: valuesContainer,
                         titleLabel: titleLabel,
                         valueLabel: valueLabel,
                         separator: separator)
       
       let titleAttr = NSMutableAttributedString(string: (title ?? "") + " ",
           attributes: [
               .font: UIFont.style(.medium, 14),
               .backgroundColor: UIColor.olchaBackgroundColor,
               .foregroundColor: UIColor.olchaLightTextColornnnnnn
           ]
       )
       var upgradedValue = value ?? ""
       if value == "" {
           upgradedValue = " - "
       }
       let valueAttr = NSMutableAttributedString(string:  " " + (upgradedValue),
           attributes: [
               .font: UIFont.style(.medium, 14),
               .backgroundColor: UIColor.olchaBackgroundColor,
               .foregroundColor: UIColor.olchaTextBlack
           ]
       )
       
       titleLabel.attributedText = titleAttr
       valueLabel.attributedText = valueAttr
       separator.text = "________________________________________________________________________________________________________________________________________________________________________________________"
       
       return miniContainer
   }
    
    private func itemConfiguration(
        valuesContainer: UIStackView,
        titleLabel: UILabel,
        valueLabel: UILabel,
        separator: UILabel
    ) {
        valuesContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        separator.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(valuesContainer.snp.width).multipliedBy(0.6)
        }
        
        valueLabel.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(valuesContainer.snp.width).multipliedBy(0.4)
        }
        
        valuesContainer.backgroundColor = .clear
        
        titleLabel.backgroundColor = .clear
        valueLabel.backgroundColor = .clear
        valuesContainer.axis = .horizontal
        valuesContainer.alignment = .lastBaseline
        
        separator.textColor = .olchaLightTextColornnnnnn
        separator.lineBreakMode = .byClipping
        separator.textAlignment = .center
        separator.style(.medium, 14)
        
        titleLabel.lineBreakMode = .byClipping
        titleLabel.style(.medium, 14)
        titleLabel.textColor = .olchaLightTextColornnnnnn
        
        valueLabel.textColor = .olchaTextBlack
        valueLabel.style(.semibold, 14)
        valueLabel.textAlignment = .right
        
        titleLabel.numberOfLines = 0
        valueLabel.numberOfLines = 0
        
        valueLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        valueLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        separator.textColor = .olchaLightTextColornnnnnn
        separator.style(.medium, 14)
    }
    
    private func stateExpandeButton() {
        if isExpande {
            dataSection.isHidden = false
            expandeIcon.transform = .identity
            expandeIcon.transform = expandeIcon.transform.rotated(by: .pi)
        } else {
            expandeIcon.transform = .identity
            dataSection.isHidden = true
        }
    }
    
    func setup(with data: InstallmentResultData?) {
        self.data = data
        
        isExpande = data?.isExpanded ?? false
        
        dateTitle.text = data?.payment_day?.formated_date ?? ""
        
        checkState(status: data?.status ?? "")
        
        fillWithData(data: data)
    }
    
    private func checkState(status: String) {
        
        if status == "success" {
            successState()
        } else if (data?.expiry_date ?? 0) > 0 {
            failState()
        } else {
            defaultState()
        }
        
    }
    
    private func fillWithData(data: InstallmentResultData?) {
        dataContainer.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        dataContainer.addArrangedSubview(getItem(
            title: "graph_actual_payment".localized(),
            value: data?.actual_payment_date))
        
        dataContainer.addArrangedSubview(getItem(
            title: "balance_owed".localized(),
            value: data?.debt?.string.price))
        
        dataContainer.addArrangedSubview(getItem(
            title: "payment_schedule".localized(),
            value: data?.payment))
        
        dataContainer.addArrangedSubview(getItem(
            title: "past_due_debt".localized(),
            value: data?.expiry_debt?.string.price))
        
        dataContainer.addArrangedSubview(getItem(
            title: "overdue_days".localized(),
            value: data?.expiry_date?.string))
        
        
        dataContainer.addArrangedSubview(getItem(
            title: "payment".localized(),
            value: data?.getTotalPayments().string.price))
    }
    
    
    private func successState() {
        containerStack.border(with: .olchaGreen, width: 2)
        dateTitle.textColor = .olchaGreen
        expandeIcon.image = .down_anchor_black?.withColor(.olchaGreen ?? .green)
    }
    
    private func failState() {
        containerStack.border(with: .olchaAccentColor, width: 2)
        dateTitle.textColor = .olchaAccentColor
        expandeIcon.image = .down_anchor_black?.withColor(.olchaAccentColor)
    }
    
    private func defaultState() {
        containerStack.border( width: 2)
        dateTitle.textColor = .olchaTextBlack
        expandeIcon.image = .down_anchor_black
    }
}
