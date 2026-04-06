//
//  InstallmentDetailRoom.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 17/05/23.
//

import UIKit
import OlchaUI
public class InstallmentDetailRoom: BaseTableCell {
    
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .lastBaseline
        stackView.spacing = 8
        return stackView
    }()
    
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.textColor = .olchaLightTextColornnnnnn
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = " "
        return label
    }()
    
    public let contentLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.textColor = .olchaTextBlack
        label.numberOfLines = 0
        label.textAlignment = .right
        label.text = " "
        return label
    }()
    
    public var titleColor: UIColor? = .olchaLightTextColornnnnnn
    public var contentColor: UIColor? = .olchaLightTextColornnnnnn

    public override func setupViews() {
        container.addSubview(containerStackView)
        containerStackView.addArrangedSubview(titleLabel)
        containerStackView.addArrangedSubview(contentLabel)
    }
    
    public override func autolayout() {
        containerStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(12)
        }
        
    }
    
    public override func configureViews() {
        makeSkeleton(views: [
            containerStackView,
            titleLabel,
            contentLabel,
        ])
    }
    
    public func setup(title: String?, content: String?) {
        titleLabel.attributedText = getTitle(title: title, textColor: titleColor)
        contentLabel.attributedText = getTitle(title: content, textColor: contentColor)
    }
    
    private func getTitle(title: String?, textColor: UIColor?) -> NSMutableAttributedString {
        NSMutableAttributedString(string:  title ?? "",
            attributes: [
                .font: UIFont.style(.medium, 14),
                .backgroundColor: UIColor.olchaBackgroundColor,
                .foregroundColor: textColor
            ]
        )
    }
}
