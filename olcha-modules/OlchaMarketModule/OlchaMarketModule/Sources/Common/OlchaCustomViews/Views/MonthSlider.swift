//
//  Slider.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 27/07/22.
//

import UIKit
class MonthSlider: UIView {
    private let container = UIView()
    private let dateContainer = UIStackView()
    private let minCreditMonth = UILabel()
    private let selectedCreditMonth = UILabel()
    private let maxCreditMonth = UILabel()
    private let slider = SliderView()
    weak var delegate: SliderViewDelegate?
    
    private var min: Int = 3 {
        didSet {
            selectedCreditMonth.text = min.string + " " + "month_short".localized()
            minCreditMonth.text = min.string + " " + "month_short".localized()
        }
    }
    
    private var max: Int = 12 {
        didSet {
            maxCreditMonth.text = max.string + " " + "month_short".localized()
        }
    }
    
    public var forcedStep: Int = 3 {
        didSet {
            selectedCreditMonth.text = forcedStep.string + " " + "month_short".localized()
            slider.forcedStep = forcedStep
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        baseSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        baseSetup()
    }
    
    func setup(min: Int, max: Int, delegate: SliderViewDelegate) {
        self.min = min
        self.max = max
        self.delegate = delegate
        self.slider.setup(min: min, max: max, delegate: self)
    }
    
    private func baseSetup() {
        setupViews()
        autolayout()
        configureViews()
    }
    
    private func setupViews() {
        addSubview(container)
        container.addSubview(dateContainer)
        dateContainer.addArrangedSubview(minCreditMonth)
        dateContainer.addArrangedSubview(selectedCreditMonth)
        dateContainer.addArrangedSubview(maxCreditMonth)
        container.addSubview(slider)
        
    }
    
    private func autolayout() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        dateContainer.snp.makeConstraints { make in
            make.top.right.left.equalToSuperview()
            make.height.equalTo(20)
        }
        
        slider.snp.makeConstraints { make in
            make.top.equalTo(dateContainer.snp.bottom).inset(-4)
            make.height.equalTo(30)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    private func configureViews() {
        dateContainer.axis = .horizontal
        dateContainer.distribution = .fillProportionally
        
        minCreditMonth.textAlignment = .left
        maxCreditMonth.textAlignment = .right
        selectedCreditMonth.textAlignment = .center
        
        minCreditMonth.style(.regular, 12)
        maxCreditMonth.style(.regular, 12)
        selectedCreditMonth.style(.semibold, 14)
        
        minCreditMonth.textColor = .olchaTextBlack
        maxCreditMonth.textColor = .olchaTextBlack
        selectedCreditMonth.textColor = .olchaTextBlack
        
        
        minCreditMonth.text = "3 мес"
        selectedCreditMonth.text = "12 мес"
        maxCreditMonth.text = "12 мес"
        
    }
}

extension MonthSlider: SliderViewDelegate {
    func valueChanged(month: Int) {
        
        self.delegate?.valueChanged(month: month)
        selectedCreditMonth.text = month.string + " " + "month_short".localized()
    }
}
