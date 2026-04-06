//
//  GroupHeaderView.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 03/02/23.
//

import UIKit
import OlchaUI
public class GroupHeaderView: BaseView {
    public var seeAllHidden: Bool = false {
        didSet {
            seeAll.isHidden = seeAllHidden
        }
    }
    
    private var seeAllClicked: (() -> Void)?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 20)
        label.textColor = .olchaTextBlack
        label.numberOfLines = 0
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private lazy var seeAll: IButton = {
        let button = IButton()
        button.seeAllConfigure()
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return button
    }()
    
    public override func setupViews() {
        addSubview(titleLabel)
        addSubview(seeAll)
    }
    
    public override func autolayout() {
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(8)
            make.right.equalTo(seeAll.snp.left).inset(-4)
        }
        
        seeAll.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.top.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        seeAll.clicked { [weak self] in
            guard let self = self else { return }
            self.seeAllClicked?()
        }
    }
    
    public func set(title: String?) {
        seeAll.seeAllConfigure()
        titleLabel.text = title ?? ""
    }
    
    public func seeAllClicked(completion: @escaping(() -> Void) ) {
        self.seeAllClicked = completion
    }
}
