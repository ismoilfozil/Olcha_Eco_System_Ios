
import UIKit
import OlchaUI

class BonusModalPage: BaseModalViewController {
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        return stackView
    }()
    
    private let bonusField: LightField = {
        let field = LightField()
        field.type = .amountWithoutRange
        field.placeholder = "enter_amount".localized()
        return field
    }()
    
    private let useAllButton: IButton = {
        let button = IButton()
        button.setTitle("all".localized(), for: .normal)
        button.titleLabel?.style(.medium, 12)
        button.setTitleColor(.olchaTextBlack, for: .normal)
        button.backgroundColor = .lightGrayBackground1
        button.round(8)
        return button
    }()
    
    private let bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.distribution = .fill
        return stackView
    }()
    
    private let bottomHintTitleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 12)
        label.textColor = .olchaTextBlack
        label.text = "max_bonus".localized()
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private let bottomHintValueLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 12)
        label.textColor = .olchaTextBlack
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private let saveButton: OlchaButton = {
        let button = OlchaButton()
        button.setTitle("save".localized())
        return button
    }()
    
    var completion: (() -> Void)?
    
    weak var observers: CartObservers?
    
    override func setupViews() {
        container.addSubview(contentStackView)
        contentStackView.addArrangedSubview(bonusField)
        bonusField.rightButtonContainer.addSubview(useAllButton)
        contentStackView.addArrangedSubview(bottomStackView)
        bottomStackView.addArrangedSubview(bottomHintTitleLabel)
        bottomStackView.addArrangedSubview(bottomHintValueLabel)
        
        container.addSubview(saveButton)
    }
    
    override func autolayout() {
        contentStackView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
        }
        
        useAllButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview().inset(8)
            
            make.width.equalTo(80)
        }
        
        bonusField.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        bottomStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        bottomHintTitleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
        }
        
        bottomHintValueLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(contentStackView.snp.bottom).inset(-50)
            make.bottom.left.right.equalToSuperview().inset(16)
        }
    }
    
    override func configureViews() {
        xButton.isHidden = true
        setHeader(title: "use_bonus".localized())
        
    }
    
    override func setupObservers() {
        useAllButton.clicked { [weak self] in
            guard let self else { return }
            bonusField.setValue(string: observers?.bonus?.getMaximumBonus().string)
        }
        
        bonusField.observeText { [weak self] in
            guard let self else { return }
            checkButtonState()
        }
        
        saveButton.clicked { [weak self] in
            guard let self else { return }
            observers?.bonus?.usingBonus = bonusField.getValue()
            observers?.isBonusUsing = true
            observers?.action.bonus.send()
            dismiss(animated: true)
        }
    }
    
    override func setupOptionalInitialRequests() {
        setupBonus()
    }
    
    override func setupOptionalObservers() {
        checkButtonState()
    }
    
    func setupBonus() {
        bonusField.text = (observers?.bonus?.usingBonus ?? "0").priceWithoutCurrency
       
        let errorMessage = "bonus_max_rule".localized() + " : " + (observers?.bonus?.getMaximumBonus().string.originalPrice ?? "")
        bonusField.append(rule: TextFieldRules.shared.maxCashRule(max: observers?.bonus?.getMaximumBonus().double, errorMessage: errorMessage))
        
        bottomHintValueLabel.text = observers?.bonus?.bonus?.originalPriceDouble
        checkButtonState()
    }
    
    private func checkButtonState() {
        
        var isValidated = true
        
        if !(bonusField.getValue().int > 0) {
            isValidated = false
        }
        
        if !bonusField.isValidated() {
            isValidated = false
        }
        
        isValidated ? saveButton.enableButton() : saveButton.disableButton()
    }
}
