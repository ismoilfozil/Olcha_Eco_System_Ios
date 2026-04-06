//
//  BillingPaymentHeaderRoom.swift
//  OlchaBilling
//
//  Created by Elbek Khasanov on 02/08/23.
//

import UIKit
import OlchaUI

public class BillingPaymentHeaderRoom: BaseTableCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.textColor = .olchaLightTextColornnnnnn
        label.numberOfLines = 0
        label.text = "                                                          "
        return label
    }()

    public override func setupViews() {
        container.addSubview(titleLabel)
    }
    
    public override func autolayout() {
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(8)
        }
    }
    
    public override func configureViews() {
        makeSkeleton(views: [
            titleLabel
        ])
    }
    
    public func setup(with data: String?) {
        titleLabel.text = data ?? " - "
    }
    
    public func setHorizontalContentInsets(inset: CGFloat) {
        titleLabel.snp.updateConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(inset)
        }
    }
    
}
