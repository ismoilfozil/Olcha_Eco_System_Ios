//
//  FinishActionsRoom.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 23/02/23.
//

import UIKit
import OlchaUI
public class FinishActionsRoom: BaseTableCell {

    public let responder = FinishActionsView()
    
    public override func setupViews() {
        container.addSubview(responder)
    }
    
    public override func autolayout() {
        responder.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(40)
        }
    }
    
}
