//
//  PriceFeatureView.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 12/07/22.
//


import UIKit
import AORangeSlider

import OlchaUI
protocol PriceFeatureDelegate: AnyObject {
    func minPriceFilter(value: Int)
    func maxPriceFilter(value: Int)
}
class PriceFeatureView: UIView {
    
    static func height(isExpanded: Bool = false) -> CGFloat {
        var height = 0.0
        height += PriceFeatureView.priceFieldsContainerHeight
        height += PriceFeatureView.sliderTopInset
        height += PriceFeatureView.sliderHeight
        
        if isExpanded {
            height += PriceFeatureView.expandedTitleLabelHeight
            height += PriceFeatureView.expandedTitleLabelBottomInset
        } else {
            height += PriceFeatureView.titleLabelHeight
            height += PriceFeatureView.titleLabelBottomInset
        }
        return height
    }
    
    static  let priceFieldsContainerHeight: CGFloat = 40.0
    static  let sliderTopInset: CGFloat = 16
    static  let sliderHeight: CGFloat = 32
    static  let titleLabelHeight: CGFloat = 20
    static  let titleLabelBottomInset: CGFloat = 8
    static  let expandedTitleLabelHeight: CGFloat = 24
    static  let expandedTitleLabelBottomInset: CGFloat = 16
    
    private let titleLabel = UILabel()
    private let priceFieldsContainer = UIStackView()
    
    private let minPriceContainer = UIView()
    private let minPricePlaceholder = UILabel()
    private let minPriceField = UITextField()
    
    private let maxPriceContainer = UIView()
    private let maxPricePlaceholder = UILabel()
    private let maxPriceField = UITextField()
    
    private let priceSlider = AORangeSlider()
    
    weak var delegate: PriceFeatureDelegate?
    
    var minValue: Int = ProductListPrice.MIN_CONSTS
    
    var maxValue: Int = ProductListPrice.MAX_CONSTS
    
    var selectedMinValue: Int? = ProductListPrice.MIN_CONSTS {
        didSet {
            self.minPriceField.text = selectedMinValue?.string.priceWithoutCurrency
        }
    }
    
    var selectedMaxValue: Int? = ProductListPrice.MAX_CONSTS {
        didSet {
            self.maxPriceField.text = selectedMaxValue?.string.priceWithoutCurrency
        }
    }
    
    weak var filters: ProductListFilters?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        baseSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        baseSetup()
    }
    
    private func baseSetup() {
        setupViews()
        autolayout()
        configureViews()
    }
    
    private func setupViews() {
        self.addSubview(titleLabel)
        self.addSubview(priceFieldsContainer)
        
        self.priceFieldsContainer.addArrangedSubview(self.minPriceContainer)
        self.priceFieldsContainer.addArrangedSubview(self.maxPriceContainer)
        
        self.minPriceContainer.addSubview(self.minPricePlaceholder)
        self.minPriceContainer.addSubview(self.minPriceField)
        
        self.maxPriceContainer.addSubview(self.maxPricePlaceholder)
        self.maxPriceContainer.addSubview(self.maxPriceField)
        
        
        self.addSubview(self.priceSlider)
    }
    private func autolayout() {
        self.titleLabel.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(PriceFeatureView.titleLabelHeight)
            make.bottom.equalTo(self.priceFieldsContainer.snp.top).inset(-PriceFeatureView.titleLabelBottomInset)
        }
        
        self.priceFieldsContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(PriceFeatureView.priceFieldsContainerHeight)
        }
        
        self.minPricePlaceholder.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(12)
            make.top.bottom.equalToSuperview()
        }
        
        self.minPriceField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().inset(4)
            make.left.equalTo(self.minPricePlaceholder.snp.right).inset(-4)
        }
        
        self.maxPricePlaceholder.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(12)
            make.top.bottom.equalToSuperview()
        }
        
        self.maxPriceField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().inset(4)
            make.left.equalTo(self.maxPricePlaceholder.snp.right).inset(-4)
        }
        
        self.priceSlider.snp.makeConstraints { make in
            make.height.equalTo(PriceFeatureView.sliderHeight)
            make.left.right.equalToSuperview()
            make.top.equalTo(priceFieldsContainer.snp.bottom).inset(-PriceFeatureView.sliderTopInset)
            make.bottom.equalToSuperview()
        }
    }
    private func configureViews() {
        self.titleLabel.style(.semibold, 14)
        self.titleLabel.textColor = .olchaTextBlack
        self.titleLabel.text = "price_sum".localized()
        
        self.priceFieldsContainer.axis = .horizontal
        self.priceFieldsContainer.spacing = 8
        self.priceFieldsContainer.distribution = .fillEqually
        
        self.minPriceContainer.round(8)
        self.maxPriceContainer.round(8)
        
        self.minPriceContainer.border()
        self.maxPriceContainer.border()
        
        self.minPricePlaceholder.style(.medium, 14)
        self.maxPricePlaceholder.style(.medium, 14)
        
        self.minPricePlaceholder.textColor = .olchaLightTextColornnnnnn
        self.maxPricePlaceholder.textColor = .olchaLightTextColornnnnnn
    
        self.minPriceField.textColor = .olchaTextBlack
        self.maxPriceField.textColor = .olchaTextBlack
        
        self.minPriceField.borderStyle = .none
        self.maxPriceField.borderStyle = .none
        
        self.minPriceField.keyboardType = .numberPad
        self.maxPriceField.keyboardType = .numberPad
        
        self.minPriceField.delegate = self
        self.maxPriceField.delegate = self
        
        self.minPriceField.font = .style(.medium, 14)
        self.maxPriceField.font = .style(.medium, 14)
        
        self.minPricePlaceholder.text = "from".localized().lowercased()
        self.maxPricePlaceholder.text = "to".localized().lowercased()
        
        self.minPriceField.placeholder = "\(ProductListPrice.MIN_CONSTS)".originalPrice
        self.maxPriceField.placeholder = "\(ProductListPrice.MAX_CONSTS)".originalPrice
        
        self.sliderConfiguration()
        
    }
    
    private func sliderConfiguration() {
        

        priceSlider.lowHandleImageNormal = .red_track
        priceSlider.highHandleImageNormal = .red_track
        
        priceSlider.trackImage = AORangeSlider.getImage(color: .olchaAccentColor, size: .init(width: 1, height: 4))
        priceSlider.trackBackgroundImage = AORangeSlider.getImage(color: .olchaLightNeutralGray ?? .lightGray, size: .init(width: 1, height: 3))

        
        priceSlider.changeValueContinuously = true
        priceSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        priceSlider.trackColor = .olchaAccentColor
        
    }
    
    func expandeTitle() {
        titleLabel.style(.bold, 18)
        titleLabel.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(PriceFeatureView.expandedTitleLabelHeight)
            make.bottom.equalTo(priceFieldsContainer.snp.top).inset(PriceFeatureView.expandedTitleLabelBottomInset)
        }
    }
    
    @objc func sliderValueChanged(_ sender: AORangeSlider) {
        rangeIsChanging()
    }
}



extension PriceFeatureView: UITextFieldDelegate {

    func rangeIsChanging() {

        self.selectedMinValue = priceSlider.lowValue.int
        self.selectedMaxValue = priceSlider.highValue.int
        
        if let min = self.selectedMinValue {
            self.delegate?.minPriceFilter(value: min)
        }
        
        if let max = self.selectedMaxValue {
            self.delegate?.maxPriceFilter(value: max)
        }
    }
    
    func setFilters(_ filters: ProductListFilters?) {
        self.filters = filters
        self.setMinimum(value: ProductListPrice.MIN_CONSTS)
        self.setMaximum(value: ProductListPrice.MAX_CONSTS)
        self.setSelectedMinimum(value: self.filters?.filterPrice.min)
        self.setSelectedMaximum(value: self.filters?.filterPrice.max)
    }
    
    private func setMinimum(value: Int) {
        self.minValue = value
        self.priceSlider.minimumValue = value.cgfloat
    }

    private func setMaximum(value: Int) {
        self.maxValue = value
        self.priceSlider.maximumValue = value.cgfloat
    }
    
    private func setSelectedMinimum(value: Int?) {
        self.selectedMinValue = value
        self.priceSlider.setValue(low: (value ?? minValue).double,
                                  high: (selectedMaxValue ?? maxValue).double,
                                  animated: true)
    }

    private func setSelectedMaximum(value: Int?) {
        self.selectedMaxValue = value
        self.priceSlider.setValue(low: (selectedMinValue ?? minValue).double,
                                  high: (value ?? maxValue).double,
                                  animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        .formatForPrice(textField, string)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let valueString = (textField.text ?? "")?.withoutSpace else { return }
        var value = Int(valueString) ?? 0
        if value > self.maxValue {
            value = self.maxValue
        }
        
        if value < self.minValue {
            value = self.minValue
        }
        
        if textField == self.minPriceField {
            self.selectedMinValue = min(value, selectedMaxValue ?? value)
        }
        
        if textField == self.maxPriceField {
            self.selectedMaxValue = max(value, selectedMinValue ?? value)
        }
        
        self.minPriceField.text = self.selectedMinValue?.string.priceWithoutCurrency
        self.maxPriceField.text = self.selectedMaxValue?.string.priceWithoutCurrency
        
        
        if let min = self.selectedMinValue {
            self.priceSlider.setValue(low: min.double, high: (selectedMaxValue ?? maxValue).double, animated: true)
            self.delegate?.minPriceFilter(value: min)
        }

        if let max = self.selectedMaxValue {
            self.priceSlider.setValue(low: (selectedMinValue ?? minValue).double, high: max.double, animated: true)
            self.delegate?.maxPriceFilter(value: max)
        }
    }
}
