//
//  HorizontalButton.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 08/07/22.
//

import UIKit
import OlchaUI
class FilterButton: UIView {
    private let container = UIStackView()
    private let button = UIButton()
    private let leftIcon = IconButton()
    
    private let rightLabelContainer = UIView()
    private let rightLabel = UILabel()
    private let titleLabel = UILabel()
    
    var index = 0
    var buttonAction: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        autolayout()
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
        
    }
    
    private func setupViews() {
        self.addSubview(container)
        self.container.axis = .horizontal
        self.container.spacing = 6
        
        self.container.addArrangedSubview(self.leftIcon)
        self.container.addArrangedSubview(self.titleLabel)
        self.container.addArrangedSubview(self.rightLabelContainer)
        
        self.rightLabelContainer.addSubview(self.rightLabel)
        self.addSubview(button)
    }
    
    private func autolayout() {
        self.container.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(12)
            make.top.bottom.equalToSuperview().inset(8)
        }
        
        self.leftIcon.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(6)
            make.top.bottom.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        self.rightLabelContainer.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.height.equalTo(20)
            make.right.equalToSuperview().inset(6)
        }
        
        self.rightLabel.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
        }
        
        self.button.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
    private func configureViews() {
        self.backgroundColor = .olchaAccentColor
        self.round(8)
        
        self.leftIcon.setIcon(.filter)
        
        self.titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        self.titleLabel.textColor = .white
        self.titleLabel.text = "filters".localized()
            
        self.rightLabel.textAlignment = .center
        self.rightLabel.textColor = .olchaAccentColor
        self.rightLabel.style(.medium, 14)

        self.rightLabelContainer.backgroundColor = .white
        self.rightLabelContainer.round(10)
        
        self.button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    }
    
    
    func setRightCount(_ count: Int) {
        if count == 0 {
            self.rightLabelContainer.isHidden = true
        } else {
            self.rightLabelContainer.isHidden = false
            if count > 9 {
                self.rightLabel.text = "9+"
            } else {
                self.rightLabel.text = count.string
            }
        }
    }
    
    func countFeatures(filters: ProductListFilters?) {
        
        var featuresCount = 0
        var features = filters?.features ?? []
        if (filters?.filterPrice.min) != nil || (filters?.filterPrice.max) != nil {
            featuresCount = featuresCount + 1
        }
        
        var i = 0
        while i < features.count {
            let values = features[i].values
            
            var k = 0
            
            while k < values?.count ?? 0 {
                if (values?[k].isSelected ?? false) == true {
                    featuresCount = featuresCount + 1
                    break
                }
                k = k + 1
            }
            
            i = i + 1
        }
        var manufactureCount = 0
        for i in 0..<(filters?.manufacturers.count ?? 0) {
            if (filters?.manufacturers[i].isSelected ?? false) {
                manufactureCount = 1
            }
        }
        featuresCount += manufactureCount
        setRightCount(featuresCount)
    }
    
    func clicked(_ action: @escaping () -> ()) {
        self.buttonAction = action
    }
    
    @objc func buttonClicked() {
        buttonAction?()
    }
    
}
