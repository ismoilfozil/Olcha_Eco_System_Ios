//
//  VerificationStatus.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 14/09/22.
//


import UIKit
import OlchaUI
import Combine
public enum VerificationStatusStep: String, CaseIterable {
    case identification
    case phones
    case bankCard
    
    public var percentage: Int {
        switch self {
        case .identification:
            return 40
        case .phones:
            return 30
        case .bankCard:
            return 30
        }
    }
    
    public var title: String {
        switch self {
        case .identification:
            return "identification".localized(.verification)
        case .phones:
            return "phone_numbers".localized(.verification)
        case .bankCard:
            return "bank_cards".localized()
        }
    }
    
    public var step: Int {
        switch self {
        case .identification:
            return 1
        case .phones:
            return 2
        case .bankCard:
            return 3
        }
    }
}
public class VerificationStatus: UIView {
    
    public let container = UIView()
    private let titleLabel = UILabel()
    private let statusContainer = UIView()
    private let status = UIView()
    private let statusTitle = UILabel()
    
    private let expandeContainer = UIView()
    private let separator = Divide()
    private let titlesStack = UIStackView()
    
    public var steps: [VerificationStatusStep] = [
        .identification,
        .phones,
        .bankCard
    ]
    
    public let expandeButton = IconButton()
    
    public var isExpanded: Bool = false {
        didSet {
            
            updateLayout()
            
        }
    }
    
    public var step = 0 {
        didSet {
            changeStep()
        }
    }
    
    public var stepObserver: ((VerificationStatusStep) -> Void)?
    
    public var expandeButtonObserver: (() -> Void)?
    
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
        container.addSubview(titleLabel)
        
        container.addSubview(statusTitle)
        container.addSubview(statusContainer)
        container.addSubview(expandeContainer)
        expandeContainer.addSubview(separator)
        statusContainer.addSubview(status)
        expandeContainer.addSubview(titlesStack)
        container.addSubview(expandeButton)
        
        
    }
    
    private func autolayout() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.right.equalTo(expandeButton.snp.left).inset(-8)
            make.top.equalToSuperview().inset(21)
        }
        
        expandeButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.right.top.equalToSuperview().inset(16)

        }
        
        statusTitle.snp.makeConstraints { make in
            make.top.equalTo(expandeButton.snp.bottom).inset(-8)
            make.right.equalToSuperview().inset(16)
//            make.width.equalTo(40)
        }
        
        statusContainer.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.height.equalTo(4)
            make.right.equalTo(statusTitle.snp.left).inset(-8)
            make.centerY.equalTo(statusTitle.snp.centerY)
        }
        
        status.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0)
        }
        
        expandeContainer.snp.makeConstraints { make in
            make.top.equalTo(statusTitle.snp.bottom).inset(-12)
            make.bottom.left.right.equalToSuperview()
        }
        
        separator.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview()
        }
        
        titlesStack.snp.makeConstraints { make in
            make.top.equalTo(separator.snp.bottom).inset(-12)
            make.left.right.bottom.equalToSuperview().inset(16)
        }
        
        updateLayout()
    }
    
    private func configureViews() {

        
        expandeButton.setIcon(.large_shrinked)
        
        titlesStack.axis = .vertical
        titlesStack.spacing = 8
        
        statusContainer.round(2)
        status.round(2)
        statusContainer.backgroundColor = .olchaLightNeutralDarkGray
        status.backgroundColor = .olchaAccentColor
        
        titleLabel.style(.semibold, 14)
        titleLabel.textColor = .olchaTextBlack
        titleLabel.text = "balans_system".localized()
        
        statusTitle.style(.medium, 14)
        statusTitle.textColor = .olchaLightTextColornnnnnn
        statusTitle.text = "0%"
        
        container.round()
        container.border()
        
        expandeButton.clicked { [weak self] in
            guard let self = self else { return }
            self.expandeButtonObserver?()
            self.isExpanded = !self.isExpanded
            self.expandeButton.rotate(degree: .pi)
            UIView.animate(withDuration: self.isExpanded ? 0 : 0.3) {
                self.expandeContainer.layoutIfNeeded()
                self.expandeButton.layoutIfNeeded()
            }

        }
        
        setupTitles()
    }
    
    private func updateLayout() {
        if isExpanded {
            expandeContainer.isHidden = false
            expandeContainer.snp.remakeConstraints { make in
                make.top.equalTo(statusTitle.snp.bottom).inset(-12)
                make.bottom.left.right.equalToSuperview()
            }
        } else {
            expandeContainer.isHidden = true
            expandeContainer.snp.remakeConstraints { make in
                make.height.equalTo(0)
                make.top.equalTo(statusTitle.snp.bottom).inset(-16)
                make.bottom.left.right.equalToSuperview()
            }
        }
    }
    
    private func setupTitles() {
        titlesStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for i in 0..<steps.count {
            let stack = UIView()
            
            
            let title = UILabel()
            title.text = steps[i].title
            title.style(.medium, 14)
            title.textColor = .olchaAccentColor
            title.textAlignment = .left
            
            let button = IButton()
            button.clicked { [weak self] in
                guard let self = self else { return }
                self.stepObserver?(self.steps[i])
            }
            
            let value = UILabel()
            value.textColor = .olchaLightTextColornnnnnn
            value.style(.medium, 14)
            value.text = steps[i].percentage.string + "%"
            value.textAlignment = .right
            
            stack.addSubview(title)
            stack.addSubview(value)
            stack.addSubview(button)
            title.snp.makeConstraints { make in
                make.top.left.bottom.equalToSuperview()
                make.right.equalTo(value.snp.left).inset(-8)
            }
            
            value.snp.makeConstraints { make in
                make.width.equalTo(60)
                make.top.right.bottom.equalToSuperview()
            }
            
            button.snp.makeConstraints { make in
                make.edges.equalTo(title.snp.edges)
            }
            
            titlesStack.addArrangedSubview(stack)
        }
    }
    
    private func changeStep() {
        guard step != 0 else { animateStatus(0); statusTitle.text = 0.string + "%"; return }
        let currentStep = min(max(1, step), 3)
        let percent = steps.map { $0.percentage }[0..<currentStep].reduce(0, +)
        statusTitle.text = percent.string + "%"
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let self = self else { return }
            self.animateStatus(percent)
        }
    }
    
    private func animateStatus(_ percent: Int) {
        
        status.snp.remakeConstraints { make in
            make.top.left.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(percent.cgfloat * 0.01)
        }
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else { return }
            self.statusContainer.layoutIfNeeded()
        }
        
    }
    
    
}
