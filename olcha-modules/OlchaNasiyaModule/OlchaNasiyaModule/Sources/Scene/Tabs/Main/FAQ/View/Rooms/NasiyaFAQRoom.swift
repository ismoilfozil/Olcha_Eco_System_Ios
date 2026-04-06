//
//  NasiyaFAQRoom.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 14/05/23.
//

import UIKit
import OlchaCommon
import OlchaUI
public class NasiyaFAQRoom: BaseTableCell {
    
    private let containerStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private let expandeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .circle_arrow_up
        return imageView
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 16)
        label.textColor = .olchaTextBlack
        label.numberOfLines = 0
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.style(.regular, 14)
        label.textColor = .olchaTextBlack
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    public var model: CommonFAQModel?
    
    public override func setupViews() {
        container.addSubview(containerStack)
        container.addSubview(expandeImageView)
        
        containerStack.addArrangedSubview(headerLabel)
        containerStack.addArrangedSubview(contentLabel)
    }
    
    public override func autolayout() {
        expandeImageView.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.left.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(16)
        }
        
        containerStack.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16)
            make.left.equalTo(expandeImageView.snp.right).inset(-12)
            make.bottom.greaterThanOrEqualTo(expandeImageView.snp.bottom)
            make.bottom.equalToSuperview().inset(16)
        }
        
        headerLabel.snp.makeConstraints { make in
            make.right.left.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
    }
    
    public func setup(with data: CommonFAQModel) {
        self.model = data
        headerLabel.text = data.getTitle()
        contentLabel.text = data.getContent()
        animate()
    }
    
    public func animate() {
        let isExpanded = model?.isExpanded ?? false
        contentLabel.isHidden = !isExpanded
        
        expandeImageView.image = isExpanded ? .circle_arrow_up : .circle_arrow_down
        
    }

}
