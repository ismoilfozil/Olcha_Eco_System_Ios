//
//  ResetLimitRoom.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 11/05/23.
//

import UIKit
import OlchaUI
class ResetLimitRoom: BaseTableCell {
    
    let limitView: RequestLimitView = {
        let view = RequestLimitView()
        return view
    }()
            
    private var model: InstallmentLimitBalanceData?
    
    override func setupViews() {
        container.addSubview(limitView)
    }
    
    override func autolayout() {
        limitView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureViews() {
    }
    
    func setup(with model: InstallmentLimitBalanceData?) {
        limitView.languageUpdated()
        self.model = model
    }
    
}
