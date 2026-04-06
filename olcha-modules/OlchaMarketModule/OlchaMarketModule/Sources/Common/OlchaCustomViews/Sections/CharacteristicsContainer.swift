//
//  CharacteristicsContainer.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 26/07/22.
//
import OlchaUI
import UIKit
import SnapKit
class CharacteristicsContainer: UIView {
    
    private let container = UIStackView()
    private var characteristics: [CharacteristicFeature] = []
    
    
    func setup(with characteristics: [CharacteristicFeature]) {
        if self.characteristics.isEmpty {
            self.characteristics = characteristics
            drawContentView()
        }
    }
    
    func shrink() {
        container.arrangedSubviews.forEach { $0.isHidden = true }
        container.arrangedSubviews.first?.isHidden = false
    }
    
    func expand() {
        container.arrangedSubviews.forEach { $0.isHidden = false }
    }
    
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
        addSubview(container)
    }
    
    private func autolayout() {
        container.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
    private func configureViews() {
        container.axis = .vertical
    }
    
    private func drawContentView() {
        for i in 0..<characteristics.count {
            let header: String = characteristics[i].getName()
            
            let section = getSection(header: header, data: characteristics[i].data ?? [])
            
            section.isHidden = (i != 0)
            self.container.addArrangedSubview(section)
        }
    }
    
    private func getSection(header: String, data: [CharacteristicFeatureData]) -> UIStackView {
        let miniContainer = UIStackView()
        miniContainer.axis = .vertical
        miniContainer.spacing = 8
        let headerItem = getHeaderTitle(title: header)
        miniContainer.addArrangedSubview(headerItem)
        for k in 0..<data.count {
            
            
            let title: String = data[k].getFeatureName()
            
            let value: String = data[k].getFeatureValueName()
            
            
            let item = getCharacteristicItem(title: title, value: value)
            miniContainer.addArrangedSubview(item)
        }
        
        return miniContainer
    }
    
    private func getHeaderTitle(title: String) -> UIView {
        let miniContainer = UIView()
        let titleLabel = UILabel()
        miniContainer.addSubview(titleLabel)
        
        headerTitleConfiguration(label: titleLabel)
        titleLabel.text = title
        
        return miniContainer
    }
    
    private func getCharacteristicItem(title: String, value: String) -> UIView {
        let miniContainer = UIView()
        
        let valuesContainer = UIStackView()
        let titleLabel = UILabel()
        let valueLabel = UILabel()
        let separator = Divide()
        
        miniContainer.addSubview(separator)
        miniContainer.addSubview(valuesContainer)
        valuesContainer.addArrangedSubview(titleLabel)
        valuesContainer.addArrangedSubview(valueLabel)
        
        
        
        
        itemConfiguration(valuesContainer: valuesContainer,
                          titleLabel: titleLabel,
                          valueLabel: valueLabel,
                          separator: separator)
        
        let titleAttr = NSMutableAttributedString(string: title + " ",
                                                  attributes: [
                                                    .font: UIFont.style(.medium, 14),
                                                    .backgroundColor: UIColor.olchaBackgroundColor,
                                                    .foregroundColor: UIColor.olchaLightTextColornnnnnn
                                                  ]
        )
        
        let valueAttr = NSMutableAttributedString(string:  " " + value,
                                                  attributes: [
                                                    .font: UIFont.style(.medium, 14),
                                                    .backgroundColor: UIColor.olchaBackgroundColor,
                                                    .foregroundColor: UIColor.olchaTextBlack
                                                  ]
        )
        
        titleLabel.attributedText = titleAttr
        valueLabel.attributedText = valueAttr
        separator.backgroundColor = .olchaLightTextColornnnnnn
        
        return miniContainer
    }
    
    private func itemConfiguration(
        valuesContainer: UIStackView,
        titleLabel: UILabel,
        valueLabel: UILabel,
        separator: UIView
    ) {
        valuesContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(1)
        }
        separator.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(valuesContainer.snp.width).multipliedBy(0.4)
        }
        
        valueLabel.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(valuesContainer.snp.width).multipliedBy(0.4)
        }
        
        valuesContainer.backgroundColor = .clear
        
        titleLabel.backgroundColor = .clear
        valueLabel.backgroundColor = .clear
        valuesContainer.axis = .horizontal
        valuesContainer.alignment = .lastBaseline
        
        titleLabel.lineBreakMode = .byClipping
        titleLabel.style(.medium, 14)
        titleLabel.textColor = .olchaLightTextColornnnnnn
        
        valueLabel.textColor = .olchaTextBlack
        valueLabel.style(.medium, 14)
        valueLabel.textAlignment = .right
        
        titleLabel.numberOfLines = 0
        valueLabel.numberOfLines = 0
        
        valueLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        valueLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
    }
    
    private func headerTitleConfiguration(label: UILabel) {
        label.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(8)
            make.top.equalToSuperview().inset(12)
        }
        
        
        label.style(.semibold, 18)
        label.textColor = .olchaTextBlack
    }
    
}
