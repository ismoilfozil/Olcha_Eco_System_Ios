//
//  TField.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 25/07/22.
//

import UIKit
import OlchaUtils
public typealias AmountRange = (min: Double?, max: Double?)

public enum TFieldType {
    case fullPhone
    case shortPhone
    case mobilePhone
    case number
    case amountRanged(range: AmountRange)
    case amountWithoutRange
    case amount
    case amountMaxRange(max: Double?)
    case cardNumber
    case cardExpire
    case password
    case `required`
    case `default`
    case regex(pattern: String?)
    case minLength(count: Int)
}

open class TField: UIView, UITextFieldDelegate {
    
    public var field_tag: String = ""
    
    public enum FieldState {
        case def
        case error
        case success
    }
    
    private let requiredIcon = UILabel()
    public let container = UIView()
    public let topHintLabel = UILabel()
    public let bottomHintLabel = UILabel()
    public let textFieldContainer = UIView()
    public let textFieldGrayView: UIView = {
        let view = UIView()
        view.backgroundColor = .olchaLightNeutralGray
        view.alpha = 0.6
        view.isHidden = true
        return view
    }()
    public let rightIcon = IconButton()
    
    public let phoneContainer = UIView()
    public let phoneButton = UILabel()
    
    public let phoneSeparator = UIView()
    public let settings = UITextField()
    public let button = IButton()
    
    private var textEditing: (() -> Void)?
    private var textChanged: (() -> Void)?
    
    public var fieldHeight: CGFloat = 40 {
        didSet {
            updateFieldSize()
        }
    }
    
    public var enableButton: Bool = false {
        didSet {
            button.isUserInteractionEnabled = enableButton
            settings.isUserInteractionEnabled = !enableButton
        }
    }
    
    public var enableGrayView: Bool = false {
        didSet {
            textFieldGrayView.isHidden = !enableGrayView
        }
    }
    
    public var background: UIColor? {
        didSet {
            textFieldContainer.backgroundColor = background
        }
    }
    
    public var topHint: String = "" {
        didSet {
            topHintLabel.text = topHint
            updateLayout()
        }
    }
    
    public var bottomHint: String = "" {
        didSet {
            bottomHintLabel.text = bottomHint
            updateLayout()
        }
    }
    
    public var placeholder: String = "" {
        didSet {
            settings.placeholder = placeholder
            updateLayout()
        }
    }
    
    public var rightImage: UIImage? {
        didSet {
            rightIcon.setIcon(rightImage) 
            updateLayout()
        }
    }
    
    private var passwordClosed = true {
        didSet {
            settings.isSecureTextEntry = passwordClosed
            rightIcon.setIcon(passwordClosed ? .password_closed : .password_opened)
        }
    }
    
    public var text: String? = "" {
        didSet {
            settings.text = text ?? ""
        }
    }
    
    public var isRequired: Bool = false {
        didSet {
            requiredIcon.isHidden = !isRequired
        }
    }
    
    public var type: TFieldType = .default {
        didSet {
            configureTField()
        }
    }
    
    public var widthOffset: CGFloat = 1 {
        didSet {
            updateFieldSize()
        }
    }
    
    public var canUseRules: Bool = true {
        didSet {
            
        }
    }
    
    public var saveStates: Bool = false {
        didSet {
            
        }
    }
    
    public var phoneSectionWidth: CGFloat = 84
    
    ///  * currency for amount range
    public var currency: String? = Texts.currency
    
    public var withValidation: Bool = false
    
    public var fieldMask: TFieldMask?
    
    public var fieldState: FieldState = .def
    
    public var rightButtonContainer = UIView()
    
    public let fieldRules = TextFieldRules()
    
    public var rules: [TextFieldValidationRule] = []
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        baseSetup()
    }
    
    required public init?(coder: NSCoder) {
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
        container.addSubview(topHintLabel)
        container.addSubview(requiredIcon)
        container.addSubview(textFieldContainer)
        container.addSubview(textFieldGrayView)
        container.addSubview(bottomHintLabel)
        textFieldContainer.addSubview(rightButtonContainer)
        rightButtonContainer.addSubview(rightIcon)
        textFieldContainer.addSubview(settings)
        textFieldContainer.addSubview(phoneContainer)
        phoneContainer.addSubview(phoneButton)
        phoneContainer.addSubview(phoneSeparator)
        phoneButton.text = "+998"
        phoneButton.style(.medium, 16)
        phoneButton.textColor = .olchaTextBlack
        addSubview(button)
    }
    
    private func autolayout() {
        container.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        topHintLabel.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(textFieldContainer.snp.top).inset(-8)
        }
        
        bottomHintLabel.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(textFieldContainer.snp.bottom).inset(-8)
        }
        
        requiredIcon.snp.makeConstraints { make in
            make.left.equalTo(topHintLabel.snp.right).inset(-4)
            make.centerY.equalTo(topHintLabel.snp.centerY)
            make.right.lessThanOrEqualToSuperview()
        }
        
        phoneContainer.snp.makeConstraints { make in
            make.left.bottom.top.equalToSuperview()
            make.width.equalTo(0)
        }
        
        phoneButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.right.equalTo(phoneSeparator.snp.left)
            make.left.equalToSuperview()
        }
        
        phoneSeparator.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.top.right.bottom.equalToSuperview()
        }
        
        settings.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.right.equalTo(rightButtonContainer.snp.left).inset(-6)
            make.left.equalTo(phoneContainer.snp.right).inset(-8)
        }
        
        rightButtonContainer.snp.makeConstraints { make in
            make.top.bottom.right.equalToSuperview()
            make.width.greaterThanOrEqualTo(0)
        }
        
        rightIcon.snp.makeConstraints { make in
            make.right.left.equalToSuperview().inset(0)
            make.centerY.equalToSuperview()
        }
        
        button.snp.makeConstraints { make in
            make.edges.equalTo(textFieldContainer.snp.edges)
        }
        
        textFieldGrayView.snp.makeConstraints { make in
            make.edges.equalTo(textFieldContainer)
        }
        
        updateFieldSize()
    }
    
    private func configureViews() {
        textFieldContainer.darkBorder()
        textFieldContainer.round()
        textFieldGrayView.round()
        settings.borderStyle = .none
        settings.font = .style(.medium, 16)
        settings.textColor = .olchaTextBlack
        settings.delegate = self
        
        
        topHintLabel.textColor = .olchaLightTextColornnnnnn
        topHintLabel.style(.medium, 14)
        topHintLabel.numberOfLines = 0
        
        bottomHintLabel.style(.medium, 11)
        bottomHintLabel.numberOfLines = 0
        
        
        requiredIcon.textColor = .olchaAccentColor
        requiredIcon.style(.medium, 24)
        requiredIcon.text = "*"
        isRequired = false
        phoneContainer.isHidden = true
        phoneContainer.backgroundColor = .clear
        phoneSeparator.backgroundColor = .olchaDarkGray
        phoneButton.backgroundColor = .clear
        phoneButton.textAlignment = .center
        settings.addTarget(self,
                           action: #selector(textFieldEditingChanged(_:)),
                           for: .allEvents)
        settings.addTarget(self,
                           action: #selector(textFieldTextChanged(_:)),
                           for: .editingChanged)
        
        
        button.isUserInteractionEnabled = false
        updateLayout()
    }
    
    private func updateLayout() {
        topHintLabel.snp.updateConstraints { make in
            make.bottom.equalTo(textFieldContainer.snp.top).inset(topHint == "" ? 0 : -8)
        }
        
        bottomHintLabel.snp.updateConstraints { make in
            make.top.equalTo(textFieldContainer.snp.bottom).inset(bottomHint == "" ? 0 : -8)
        }
        
        settings.snp.remakeConstraints { make in
            make.top.bottom.equalToSuperview()
            
            make.right.equalTo(rightButtonContainer.snp.left).inset(-6)
            
            make.left.equalTo(phoneContainer.snp.right).inset(-16)
        
        }
        
        let rightIconEnabled = (rightImage != nil)
        
        rightIcon.snp.remakeConstraints { make in
            make.right.left.equalToSuperview().inset(rightIconEnabled ? 12 : 0)
            if rightIconEnabled {
                make.width.height.equalTo(20)
            } else {
                make.width.equalTo(0).priority(.low)
            }
            make.centerY.equalToSuperview()
        }
        self.layoutIfNeeded()
    }
    
    public func observeText(editing: (() -> Void)?) {
        self.textEditing = editing
    }
    
    public func observeTextChanged(editing: (() -> Void)?) {
        self.textChanged = editing
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        defer {
            textField.sendActions(for: .editingChanged)
        }
        
        guard let fieldMask = fieldMask else {
            return true
        }
        
        return fieldMask.execute(textField: textField, range: range, replacingText: string)
    }
    
    @objc public func textFieldEditingChanged(_ textField: UITextField) {
        if canUseRules {
            isValidated(withMessage: true)
        }
        textEditing?()
    }
    
    @objc public func textFieldTextChanged(_ textField: UITextField) {
        if canUseRules {
            isValidated(withMessage: true)
        }
        textChanged?()
    }
    
    open func errorStyle(_ bottomHint: String? = nil) {
        fieldState = .error
        self.bottomHint = bottomHint ?? ""
        bottomHintLabel.textColor = .olchaAccentColor
        textFieldContainer.darkBorder(with: .olchaAccentColor)
    }
    
    open func errorMessage(_ bottomHint: String = "") {
        fieldState = .error
        self.bottomHint = bottomHint
        bottomHintLabel.textColor = .olchaAccentColor
    }
    
    open func successStyle() {
        fieldState = .success
        bottomHint = ""
        textFieldContainer.darkBorder(with: .olchaGreen)
    }
    
    open func defaultStyle() {
        fieldState = .def
        bottomHint = ""
        textFieldContainer.darkBorder()
    }
    
    private func configureTField() {
        rules.removeAll()
        switch type {
        case .fullPhone:
            fullPhoneConfiguration()
        case .shortPhone:
            shortPhoneConfiguration()
        case .mobilePhone:
            mobilePhoneConfiguration()
        case .amountRanged(let range):
            amountConfiguration(min: range.min ?? 0, max: range.max)
        case .amount:
            amountConfiguration()
        case .amountMaxRange(let max):
            amountConfiguration(max: max, zeroEnabled: true)
        case .amountWithoutRange:
            amountConfiguration(zeroEnabled: true)
        case .cardNumber:
            cardNumberConfiguration()
        case .cardExpire:
            cardExpireConfiguration()
        case .password:
            passwordConfiguration()
        case .required:
            requireConfiguration()
        case .number:
            numberConfiguration()
        case .regex(let pattern):
            regexConfiguration(pattern: pattern)
        case .minLength(let count):
            minLengthConfiguration(count: count)
        case .default:
            break
        }
    }
    
    private func shortPhoneConfiguration() {
        fieldMask = TFieldPhoneMask()
        phoneContainer.isHidden = false
        settings.keyboardType = .numberPad
        settings.placeholder = .phonePlaceholder
        openPhoneContainer()
        
        rules.append(fieldRules.shortPhoneRule)
    }
    
    private func mobilePhoneConfiguration() {
        fieldMask = TFieldMobilePhoneMask()
        phoneContainer.isHidden = false
        settings.keyboardType = .numberPad
        settings.placeholder = .phonePlaceholder
        openPhoneContainer()
        
        rules.append(fieldRules.shortPhoneRule)
    }
    
    private func numberConfiguration() {
        settings.keyboardType = .phonePad
        
        hidePhoneContainer()
        
        rules.append(fieldRules.requiredRule)
    }
    
    private func regexConfiguration(pattern: String?) {
        hidePhoneContainer()
        rules.append(fieldRules.regexRule(pattern: pattern))
    }
    
    private func minLengthConfiguration(count: Int) {
        hidePhoneContainer()
        rules.append(fieldRules.minLengthRule(count: count))
    }
    
    private func fullPhoneConfiguration() {
        phoneContainer.isHidden = true
        settings.keyboardType = .phonePad
        settings.placeholder = .phonePlaceholder
        hidePhoneContainer()
        rules.append(fieldRules.fullPhoneRule)
    }
    
    private func amountConfiguration(min: Double = 0, max: Double? = nil, zeroEnabled: Bool = false) {
        settings.keyboardType = .numberPad
        settings.placeholder = "5 000"
        fieldMask = TFieldPriceMask()
        rules.append(fieldRules.amountRule(min: min,
                                           max: max,
                                           currency: currency,
                                           zeroEnabled: zeroEnabled))
    }
    
    private func cardNumberConfiguration() {
        settings.keyboardType = .numberPad
        fieldMask = TFieldCardNumberMask()
        rules.append(fieldRules.cardNumberRule)
    }
    
    private func cardExpireConfiguration() {
        settings.keyboardType = .numberPad
        fieldMask = TFieldCardExpireMask()
        rules.append(fieldRules.cardExpireRule)
    }
    
    private func passwordConfiguration() {
        rightImage = .password_closed
        passwordClosed = true
        rightIcon.clicked { [weak self] in
            guard let self = self else { return }
            self.passwordClosed = !self.passwordClosed
        }
        rules.append(fieldRules.passwordRule)
    }
    
    private func requireConfiguration() {
        isRequired = true
        rules.append(fieldRules.requiredRule)
    }
    
    private func updateFieldSize() {
        textFieldContainer.snp.remakeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(widthOffset)
            make.height.equalTo(fieldHeight)
        }
    }
    
    open func openPhoneContainer() {
        phoneContainer.snp.updateConstraints { make in
            make.width.equalTo(phoneSectionWidth)
        }
    }
}
//Validated fields
public extension TField {
    
    @discardableResult
    func isValidated(withMessage: Bool = false, isForced: Bool = false) -> Bool {
        guard !isForced else { return true }
        
        switch settings.validate(with: rules) {
        case .valid:
            if withMessage && !saveStates {
                defaultStyle()
            }
            return true
        case .invalid(let message):
            if withMessage {
                errorStyle(message)
            }
            return false
        }
    }
    
    func currentMeesage() -> String? {
        switch settings.validate(with: rules) {
        case .valid:
            return nil
        case .invalid(let message):
            return message
        }
    }
    
}

public extension TField {
    func hidePhoneContainer() {
        phoneContainer.snp.updateConstraints { make in
            make.width.equalTo(0)
        }
    }
}
