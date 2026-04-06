//
//  MonitoringFilterHeaderRoom.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 29/03/23.
//

import UIKit
public class MonitoringFilterHeaderRoom: UITableViewHeaderFooterView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 14)
        label.textColor = .olchaDarkNeutralGray
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
        autolayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(titleLabel)
    }
    
    func autolayout() {
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(4)
        }
    }
    
    func setup(title: String?) {
        titleLabel.text = title
    }
}
