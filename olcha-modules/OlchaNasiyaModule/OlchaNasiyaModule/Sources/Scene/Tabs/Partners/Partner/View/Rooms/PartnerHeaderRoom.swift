//
//  PartnerHeaderRoom.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 19/05/23.
//

import UIKit
import OlchaUI
public class PartnerHeaderRoom: BaseView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 24)
        label.textColor = .olchaTextBlack
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var imageContainer: UIView = {
        let view = UIView()
        view.round(10)
        view.backgroundColor = .lightGrayBackground
        return view
    }()
    
    private let partnerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var separator: Divide = {
        let separator = Divide()
        separator.color = .hex("#3C3C43").withAlphaComponent(0.36)
        return separator
    }()
    
    public override func setupViews() {
        addSubview(titleLabel)
        addSubview(imageContainer)
        imageContainer.addSubview(partnerImageView)
        addSubview(separator)
    }
    
    public override func autolayout() {
        titleLabel.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(16)
            make.right.equalTo(imageContainer.snp.left).inset(-16)
            make.bottom.lessThanOrEqualToSuperview().inset(16)
        }
        
        imageContainer.snp.makeConstraints { make in
            make.right.top.equalToSuperview().inset(16)
            make.width.equalTo(116)
            make.height.equalTo(72)
            make.bottom.lessThanOrEqualToSuperview().inset(16)
        }
        
        partnerImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(4)
            make.left.right.equalToSuperview().inset(4)
        }
        
        separator.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    public func setup(with data: PartnerModel?) {
        titleLabel.text = data?.getTitle()
        partnerImageView.load(from: data?.getImageURL())
    }
    
}
