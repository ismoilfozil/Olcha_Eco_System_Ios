//
//  MonitoringTotalHeader.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 22/02/23.
//

import UIKit
import OlchaUI
public class MonitoringTotalHeader: BaseView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.textColor = .olchaLightTextColornnnnnn
        label.text = "spent".localized()
        return label
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .olchaTextBlack
        label.style(.bold, 24)
        label.text = "0".originalPrice
        return label
    }()
    
    public override func setupViews() {
        addSubview(titleLabel)
        addSubview(valueLabel)
    }
    
    public override func configureViews() {
        backgroundColor = .olchaWhite
    }
    
    public override func autolayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }
        
        valueLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-4)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(8)
        }
    }
    
    public func setup(dateFrom: String?, dateTo: String?, amount: Double?) {
        var dateRange: String?
        
        if let dateFrom, let dateTo, dateFrom != "", dateTo != "" {
            dateRange = "(" + dateFrom + " - " + dateTo + ")"
        }
        
        titleLabel.text = "spent".localized() + (dateRange ?? "")
        
        valueLabel.text = amount?.string.originalPrice ?? "0".originalPrice
    }
}
