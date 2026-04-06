//
//  PaymentFinishViewController+UI.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 07/04/23.
//

import UIKit
extension PaymentFinishViewController {
    
    func getTitlesView(_ title: String?, _ value: String?) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 2
        
        
        let titleLabel = UILabel()
        titleLabel.text = title ?? " - "
        titleLabel.style(.medium, 14)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .olchaDarkGray
        
        let valueLabel = UILabel()
        valueLabel.text = value ?? " - "
        valueLabel.style(.semibold, 18)
        valueLabel.textAlignment = .center
        valueLabel.textColor = .olchaTextBlack
        
        
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(valueLabel)
        
        return stack
    }
    
    func createStackItems() {
        detailStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let model = fullTransaction ?? transaction
        
        detailStack.addArrangedSubview(
            getTitlesView("summa".localized(),
                          model?.amount?.string.originalPrice)
        )
        
        detailStack.addArrangedSubview(
            getTitlesView("sending_to".localized(),
                          model?.fields?.first?.value)
        )
        
        detailStack.addArrangedSubview(
            getTitlesView("card_transfering".localized(),
                          model?.card_id?.bankName)
        )
        
        dateLabel.text = model?.dateTime()
    }
}
