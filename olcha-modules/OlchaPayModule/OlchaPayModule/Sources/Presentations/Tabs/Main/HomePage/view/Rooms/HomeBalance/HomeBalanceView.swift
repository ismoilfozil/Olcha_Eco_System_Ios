//
//  HomeBalanceRoom.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 01/02/23.
//

import UIKit
import OlchaUI
public class HomeBalanceView: BaseView {
    //MARK: - UI
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.textColor = .olchaWhite
        return label
    }()
    
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.style(.bold, 24)
        label.textColor = .olchaWhite
        return label
    }()
    
    public lazy var dropDownButton: IButton = {
        let button = IButton()
        return button
    }()
    
    private lazy var dropDownIcon: IconButton = {
        let button = IconButton()
        button.setIcon(.arrow_down?.withColor(.olchaWhite))
        return button
    }()
    
    private lazy var hideIcon: IconButton = {
        let button = IconButton()
        button.setIcon(.show_eye?.withColor(.olchaWhite))
        return button
    }()
    
    private var isShown: Bool = true {
        didSet {
            hideIcon.setIcon(isShown ? .show_eye?.withColor(.olchaWhite) : .hide_eye?.withColor(.olchaWhite))
            amountLabel.text = amountText
        }
    }
    
    private var amountText: String {
        isShown ? (totalAmount ?? 0.0).string.originalPrice : "*** *** *** ***"
    }
    
    private var totalAmount: Double? = 0.0 {
        didSet {
            amountLabel.text = amountText
        }
    }
    
    public override func setupViews() {
        addSubview(titleLabel)
        addSubview(amountLabel)
        addSubview(dropDownIcon)
        addSubview(hideIcon)
        addSubview(dropDownButton)
    }
    
    public override func autolayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().inset(16)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).inset(-4)
            make.bottom.equalToSuperview()
            make.height.equalTo(32)
        }
        
        dropDownIcon.snp.makeConstraints { make in
            make.left.equalTo(amountLabel.snp.right).inset(-8)
            make.top.equalTo(amountLabel.snp.top)
            make.right.lessThanOrEqualTo(hideIcon.snp.left).inset(-16)
            make.width.height.equalTo(24)
        }
        
        hideIcon.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.top.equalTo(amountLabel.snp.top)
            make.width.height.equalTo(24)
        }
        
        dropDownButton.snp.makeConstraints { make in
            make.right.equalTo(dropDownIcon.snp.right)
            make.left.equalTo(amountLabel.snp.left)
            make.bottom.equalTo(amountLabel.snp.bottom)
            make.top.equalTo(amountLabel.snp.top)
        }
    }
    
    public override func configureViews() {
        amountLabel.text = amountText
        
        hideIcon.clicked { [weak self] in
            guard let self = self else { return }
            self.isShown = !self.isShown
        }
    }
    
    func setup(totalAmount: Double?) {
        self.totalAmount = totalAmount
    }
    
    public override func languageUpdated() {
        titleLabel.text = "all_balance".localized()
    }
}
