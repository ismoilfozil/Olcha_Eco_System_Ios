//
//  LoyaltyLevelsPage.swift
//  OlchaCommon
//
//  Created by Elbek Khasanov on 21/07/24.
//

import UIKit
import OlchaUI
public class LoyaltyLevelsPage: BaseViewController<BackNavigationBar> {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 18)
        label.textColor = .olchaTextBlack
        label.numberOfLines = 0
        label.text = "level_and_loyalty_programm".localized()
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.style(.regular, 14)
        label.textColor = .olchaNeutral700
        label.numberOfLines = 0
        label.text = "level_and_loyalty_programm_subtitle".localized()
        return label
    }()
    
    private lazy var table: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.registerClass(forCell: LoyaltyLevelRoom.self)
        table.configure()
        return table
    }()
    
    var levels: [LoyaltyModel] = [
        .init(),
        .init(),
        .init(),
        .init(),
        .init(),
        .init(),
    ]
    
    public override func setupViews() {
        container.addSubview(titleLabel)
        container.addSubview(subtitleLabel)
        container.addSubview(table)
    }
    
    public override func autolayout() {
        titleLabel.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview().inset(16)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).inset(-8)
        }
        
        table.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(subtitleLabel.snp.bottom).inset(-8)
        }
    }
    
    
}
