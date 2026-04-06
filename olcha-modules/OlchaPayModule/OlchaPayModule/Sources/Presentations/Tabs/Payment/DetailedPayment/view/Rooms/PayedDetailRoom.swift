//
//  PayedDetailRoom.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 23/02/23.
//

import UIKit
import OlchaUI
import OlchaUtils
public class PayedDetailRoom: BaseTableCell {

    private let separator = Divide()
    
    private lazy var stackContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    public override func setupViews() {
        container.addSubview(separator)
        container.addSubview(stackContainer)
    }
    
    public override func autolayout() {
        separator.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.left.right.equalToSuperview().inset(16)
        }
        
        stackContainer.snp.makeConstraints { make in
            make.top.equalTo(separator.snp.bottom).inset(-12)
            make.bottom.equalToSuperview().inset(6)
            make.left.right.equalToSuperview().inset(16)
        }
    }
    
    func setup(with details: [KeyValueModel]) {
        generateStackView(details)
    }
    
    private func generateStackView(_ details: [KeyValueModel]) {
        stackContainer.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for detail in details {
            stackContainer.addArrangedSubview(
                getStackView(detail.key, detail.value)
            )
        }
    }
    
    private func getStackView(_ title: String?, _ value: String?) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .firstBaseline
        stackView.addArrangedSubview(getTitleLabel(title))
        stackView.addArrangedSubview(getValueLabel(value))
        return stackView
    }
    
    private func getTitleLabel(_ title: String?) -> UILabel {
        let label = UILabel()
        label.style(.medium, 16)
        label.textColor = .olchaDarkGray
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = title ?? " - "
        return label
    }
    
    private func getValueLabel(_ value: String?) -> UILabel {
        let label = UILabel()
        label.style(.medium, 16)
        label.textColor = .olchaTextBlack
        label.numberOfLines = 0
        label.textAlignment = .right
        label.text = value ?? " - "
        return label
    }
}
