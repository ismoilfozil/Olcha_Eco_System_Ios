//
//  OrderSuccessAlertView.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 14/10/22.
//

import UIKit
import Lottie
import OlchaUtils
public class OrderSuccessAlertView: UIView {
    
    public enum SuccessType {
        case payment
        case history
        case simple
        
        var buttonTitle: String {
            switch self {
            case .payment:
                return "pay".localized()
            case .history:
                return "to_history".localized()
            case .simple:
                return "good".localized()
            }
        }
    }
    
    private var animationView = AnimationView()
    private let container = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let buttonsStack = UIStackView()
    private let homeButton = IButton()
    private let doneButton = OlchaButton()
    private let xButton = IconButton()
    
    weak var delegate: BaseAlertDelegate?
    
    var currentType: SuccessType = .history {
        didSet {
            typeChanged()
        }
    }
    
    public var homeClickObserver: (() -> Void)?
    public var doneClickObserver: (() -> Void)?
    
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
        container.addSubview(animationView)
        container.addSubview(titleLabel)
        container.addSubview(subtitleLabel)
        container.addSubview(buttonsStack)
        buttonsStack.addArrangedSubview(homeButton)
        buttonsStack.addArrangedSubview(doneButton)
        container.addSubview(xButton)
    }
    
    private func autolayout() {
        container.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        animationView.snp.makeConstraints { make in
            make.width.height.equalTo(180)
            make.top.equalToSuperview().inset(24)
            make.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(animationView.snp.bottom).inset(-16)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-8)
            make.left.right.equalToSuperview().inset(16)
        }
        
        buttonsStack.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).inset(-32)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
        }
        
        doneButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
        homeButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
        xButton.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(12)
            make.width.height.equalTo(24)
        }
    }
    
    private func configureViews() {
        container.backgroundColor = .olchaWhite
        container.round()
        
        titleLabel.style(.bold, 22)
        titleLabel.textColor = .olchaTextBlack
        
        titleLabel.text = "order_success".localized()
        
        titleLabel.textAlignment = .center
        
        subtitleLabel.style(.medium, 14)
        subtitleLabel.textColor = .olchaTextBlack
        subtitleLabel.text = "connect_with_you".localized()
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .center
        
        
        buttonsStack.axis = .vertical
        buttonsStack.distribution = .fill
        buttonsStack.alignment = .center
        
        doneButton.settings.titleLabel?.style(.medium, 16)
        
        homeButton.setTitle("to_home".localized(), for: .normal)
        homeButton.titleLabel?.style(.medium, 16)
        homeButton.setTitleColor(.olchaTextBlack, for: .normal)
        
        
        xButton.setIcon(.x_cancel, edgeSize: 3, isIgnoringEdge: false)
        
        xButton.clicked { [weak self] in
            guard let self = self else { return }
            self.delegate?.dismiss()
        }
        
        doneButton.settings.clicked { [weak self] in
            guard let self = self else { return }
            self.delegate?.dismiss()
            self.doneClickObserver?()
        }
        
        homeButton.clicked { [weak self] in
            guard let self = self else { return }
            self.delegate?.dismiss()
            self.homeClickObserver?()
        }
        
        animationView.setup(bundleIdentifier: BundleType.ui.identifier, name: "success")
    }
    
    private func typeChanged() {
        doneButton.setTitle(currentType.buttonTitle)
        switch currentType {
            case .simple:
            homeButton.isHidden = true
                break
            default:
                break
        }
    }
    

}
