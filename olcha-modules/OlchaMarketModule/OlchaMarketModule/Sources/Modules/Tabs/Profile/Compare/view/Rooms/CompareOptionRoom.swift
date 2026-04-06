//
//  CompareOptionRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 16/08/22.
//

import UIKit
import OlchaUI
class CompareOptionRoom: BaseTableCell {
    
    private let titleLabel = UILabel()
    private let valueStack = UIStackView()
    private let leftValue = UILabel()
    private let rightValue = UILabel()
    private let separator = Divide()
    
    override func setupViews() {
        container.addSubview(titleLabel)
        container.addSubview(valueStack)
        valueStack.addArrangedSubview(leftValue)
        valueStack.addArrangedSubview(rightValue)
        container.addSubview(separator)
    }
    
    override func autolayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.left.right.equalToSuperview()
        }
        
        valueStack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-4)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(separator.snp.top).inset(-8)
        }
        
        separator.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    override func configureViews() {
        titleLabel.style(.medium, 12)
        titleLabel.textColor = .olchaLightTextColornnnnnn
        titleLabel.numberOfLines = 0
        
        valueStack.axis = .horizontal
        valueStack.distribution = .fillEqually
        
        [rightValue, leftValue].forEach {
            $0.style(.medium, 14)
            $0.textColor = .olchaTextBlack
            $0.numberOfLines = 0
        }
        
        valueStack.spacing = 16
    }
    
    
    func setup(with data: FeatureData?, leftProduct: ProductModel?, rightProduct: ProductModel?) {
        titleLabel.text = data?.getName()
        
        if let index = data?.values?.firstIndex(where: { $0.product_id == leftProduct?.id }) {
            leftValue.text = data?.values?[index].getName()
        } else {
            leftValue.text = " - "
        }
        
        if let index = data?.values?.firstIndex(where: { $0.product_id == rightProduct?.id }) {
            rightValue.text = data?.values?[index].getName()
        
        } else {
            rightValue.text = " - "
        }
        
    }
}
