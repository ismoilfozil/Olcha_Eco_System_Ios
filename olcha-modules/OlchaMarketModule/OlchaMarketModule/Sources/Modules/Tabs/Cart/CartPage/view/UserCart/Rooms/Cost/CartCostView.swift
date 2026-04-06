//
//  CartCostView.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 02/02/24.
//

import UIKit
import OlchaUI

public class CartCostView: BaseView {
    
    private let containerStack = UIStackView()
   
    public weak var observers: CartObservers?
   
    public var hideInfoButtons = false
    
    public override func setupViews() {
        addSubview(containerStack)
    }
    
    public override func autolayout() {
        containerStack.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        
        containerStack.axis = .vertical
        containerStack.spacing = 8
        fillTitles(costType: .full)
        
    }
    
    public func setup(observers: CartObservers?, costType: CostType) {
        self.observers = observers
        fillTitles(costType: costType)
    }
//    (observers?.selectedBuyType ?? .cash) == .cash ? cashItemTitles : creditItemTitles
    private func fillTitles(costType: CostType) {
        let titles = getItems(type: costType)
        
        containerStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for titleItem in titles {
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.spacing = 4
            stack.distribution = .fillEqually
            stack.alignment = .firstBaseline
            
            let titleLabel = getTitleLabel(titleItem: titleItem)
            
            let valueLabel = getValueLabel(titleItem: titleItem)
            
            stack.addArrangedSubview(titleLabel)
            stack.addArrangedSubview(valueLabel)
            
            titleLabel.settings.text = titleItem.title
            
            
            var value: String = ""
            switch titleItem {
            case .overall:
                value = (observers?.getCost?.total_cost ?? 0).string.price
                let divide = Divide()
                containerStack.addArrangedSubview(divide)
                divide.snp.makeConstraints { make in
                    make.left.right.equalToSuperview()
                }
                titleLabel.infoButton.isHidden = hideInfoButtons
                titleLabel.infoButton.clicked { [weak self] in
                    guard let self else { return }
                    observers?.navigation.getCost.send()
                }
                break
            case .payment_of_commission:
                value = (observers?.getCost?.payment_of_commission ?? 0.0).string.originalPrice
                break
            case .installment_total_sum:
                value = (observers?.getCost?.installment_total_sum ?? 0).string.price
                break
            case .first_fee_sum:
                value = (observers?.getCost?.first_fee_sum ?? 0).string.price
                break
            case .discount:
                value = (observers?.getCost?.discount_total ?? 0).string.price
                valueLabel.textColor = .olchaAccentColor
                break
            case .products:
                titleLabel.countLabel.text = "\((observers?.getCost?.total_amount ?? 0).string)"
                titleLabel.countLabel.isHidden = false
                value = (observers?.getCost?.products_total_price ?? 0).string.price
                break
            case .coupon:
                value = (observers?.coupon?.value ?? 0).string.price
                valueLabel.textColor = .olchaAccentColor
                break
            case .bonus:
                value = (observers?.getCost?.bonus_value ?? 0).string.price
                valueLabel.textColor = .olchaAccentColor
                break
            case .shippingPrice:
                value = (observers?.getCost?.delivery_price ?? 0).string.price
                titleLabel.infoButton.isHidden = hideInfoButtons
                titleLabel.infoButton.clicked { [weak self] in
                    guard let self else { return }
                    observers?.navigation.shippingData.send()
                }
                break
            case .payment:
                value = observers?.selectedPayment?.getName() ?? ""
                break
            }
            
            valueLabel.text = value
            containerStack.addArrangedSubview(stack)
        }
    }
}

//MARK: - Cost Factory
extension CartCostView {
    fileprivate func getTitleLabel(titleItem: CostItem) -> CostTitleView {
        let titleLabel = CostTitleView()
        titleLabel.settings.font = titleItem.titleFont
        titleLabel.countLabel.isHidden = true
        titleLabel.infoButton.isHidden = true
        return titleLabel
    }
    
    fileprivate func getValueLabel(titleItem: CostItem) -> UILabel {
        let valueLabel = UILabel()
        
        valueLabel.textColor = titleItem.valueColor
        valueLabel.font = titleItem.valueFont
        valueLabel.numberOfLines = 0
        valueLabel.textAlignment = .right
        return valueLabel
    }
}

extension CartCostView {
    fileprivate func getItems(type: CostType) -> [CostItem] {
        
        switch type {
        case .short:
            return [
                .products,
                .shippingPrice,
                .overall
            ]
        case .full:
            switch observers?.selectedBuyType {
            case .credit:
                return [
                    .products,
                    .coupon,
                    .bonus,
                    .discount,
                    .payment_of_commission,
                    .shippingPrice,
                    .installment_total_sum,
                    .first_fee_sum,
                    .payment,
                    .overall
                ]
            default:
                return [
                    .products,
                    .coupon,
                    .bonus,
                    .discount,
                    .payment_of_commission,
                    .shippingPrice,
                    .payment,
                    .overall
                ]
            }
        }
    }
}

extension CartCostView {
    public enum CostType {
        case short
        case full
    }
    
    public enum CostItem {
        case overall
        case products
        case discount
        case coupon
        case bonus
        case shippingPrice
        case payment
        case first_fee_sum
        case payment_of_commission
        case installment_total_sum
        
        var title: String {
            switch self {
            case .overall:
                return "overall".localized()
            case .products:
                return "products".localized()
            case .discount:
                return "sale".localized()
            case .coupon:
                return "coupon".localized()
            case .bonus:
                return "bonus".localized()
            case .shippingPrice:
                return "delivery".localized()
            case .payment:
                return "payment_type".localized()
            case .first_fee_sum:
                return "first_payment".localized()
            case .payment_of_commission:
                return "payment_comission".localized()
            case .installment_total_sum:
                return "overall_payment".localized()
            }
        }
        
        var valueColor: UIColor? {
            switch self {
                case .discount, .coupon, .bonus:
                return .olchaAccentColor
                default:
                return .olchaTextBlack
            }
        }
        
        var titleFont: UIFont {
            switch self {
            case .overall:
                return .style(.semibold, 24)
            default:
                return .style(.medium, 16)
            }
        }
        
        var valueFont: UIFont {
            switch self {
            case .overall:
                return .style(.semibold, 22)
            default:
                return .style(.medium, 16)
            }
        }
    }
}
