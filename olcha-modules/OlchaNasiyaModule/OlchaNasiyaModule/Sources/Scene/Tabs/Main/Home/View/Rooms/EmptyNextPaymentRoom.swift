//
//  EmptyNextPaymentRoom.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 11/05/23.
//

import UIKit
import OlchaUI

class EmptyNextPaymentRoom: BaseTableCell {

    private lazy var emptyView: EmptyView = {
        let view = EmptyView()
        return view
    }()
    
    override func setupViews() {
        container.addSubview(emptyView)
    }
    
    override func autolayout() {
        emptyView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    public func setup() {
        emptyView.setup(title: "empty_payments".localized(.olchaNasiyaModule), image: .empty_placeholder)
    }

}
