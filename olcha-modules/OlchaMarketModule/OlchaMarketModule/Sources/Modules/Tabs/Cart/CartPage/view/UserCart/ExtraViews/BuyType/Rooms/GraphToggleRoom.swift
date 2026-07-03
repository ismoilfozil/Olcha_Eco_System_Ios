//
//  GraphToggleRoom.swift
//  OlchaMarketModule
//

import UIKit
import OlchaUI

class GraphToggleRoom: BaseTableCell {

    var onTap: (() -> Void)?

    var isExpanded: Bool = false {
        didSet { updateTitle() }
    }

    private let toggleButton = UIButton(type: .system)

    override func setupViews() {
        container.addSubview(toggleButton)
    }

    override func autolayout() {
        toggleButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(8)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
    }

    override func configureViews() {
        toggleButton.setTitleColor(.olchaTextBlack, for: .normal)
        toggleButton.titleLabel?.font = UIFont.style(.medium, 15)
        toggleButton.layer.cornerRadius = 12
        toggleButton.layer.borderWidth = 1
        toggleButton.layer.borderColor = UIColor.olchaLightNeutralGray?.cgColor ?? UIColor.lightGray.cgColor
        toggleButton.backgroundColor = .olchaWhite
        toggleButton.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        updateTitle()
    }

    private func updateTitle() {
        let arrow = isExpanded ? "▲" : "▼"
        let text = isExpanded ? "hide_graph".localized() : "payment_graph".localized()
        toggleButton.setTitle("\(arrow)  \(text)", for: .normal)
    }

    @objc private func tapped() {
        onTap?()
    }
}
