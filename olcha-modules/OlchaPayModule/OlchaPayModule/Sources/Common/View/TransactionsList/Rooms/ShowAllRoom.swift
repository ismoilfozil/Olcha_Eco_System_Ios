//
//  ShowAllRoom.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 05/02/23.
//

import UIKit
import OlchaUI
public class ShowAllRoom: BaseTableCell {

    public lazy var showAllButton: IButton = {
        let button = IButton()
        button.backgroundColor = .olchaWhite
        button.round(8)
        button.border(with: .olchaAccentColor, width: 2)
        button.titleLabel?.style(.medium, 14)
        button.setTitleColor(.olchaAccentColor, for: .normal)
        return button
    }()
    
    public override func setupViews() {
        container.addSubview(showAllButton)
    }
    
    public override func autolayout() {
        showAllButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(8)
            make.height.equalTo(36)
        }
    }
    
    
    public func setup() {
        showAllButton.setTitle("see_all".localized(), for: .normal)
    }
}
