//
//  LoyaltyStepView.swift
//  OlchaCommon
//
//  Created by Elbek Khasanov on 11/07/24.
//

import UIKit
import OlchaUI

public enum LoyaltyStep: String {
    
    case familiar
    case confidence
    case our
    case dear
    case family
 
    var image: UIImage? {
        switch self {
        case .familiar:
            return nil
        case .confidence:
            return nil
        case .our:
            return nil
        case .dear:
            return nil
        case .family:
            return nil
        }
    }
    
    var title: String {
        switch self {
        case .familiar:
            return ""
        case .confidence:
            return ""
        case .our:
            return ""
        case .dear:
            return ""
        case .family:
            return ""
        }
    }
}

public class LoyaltyStepView: BaseView {
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 4
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    var steps: [LoyaltyStep] = [
        .familiar,
        .confidence,
        .our,
        .dear,
        .family
    ]
    
    var currentStep: LoyaltyStep = .confidence
    
    public override func setupViews() {
        addSubview(stackView)
    }
    
    public override func autolayout() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        
        createSteps()
    }
    
    private func createSteps() {
        
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for step in steps {
            let stepItem = createStepItem(step: step)
            stackView.addArrangedSubview(stepItem)
            stepItem.snp.makeConstraints { $0.top.bottom.equalToSuperview() }
        }
    }
 
    private func createStepItem(step: LoyaltyStep) -> LoyaltyStepItem {
        let item = LoyaltyStepItem()
        item.setup(step: step, isCurrent: step == currentStep)
        return item
    }
}
