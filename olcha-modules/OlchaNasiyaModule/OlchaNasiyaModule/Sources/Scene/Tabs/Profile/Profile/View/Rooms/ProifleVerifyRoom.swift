//
//  ProifleVerifyRoom.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 27/05/23.
//

import UIKit
import OlchaUI
import OlchaUtils
import OlchaVerification
public class ProifleVerifyRoom: BaseTableCell {
    
    public let statusView: VerificationStatusView = {
        let view = VerificationStatusView()
        view.container.removeBorder()
        return view
    }()
    
    public let verifyButton: NasiyaButton = {
        let button = NasiyaButton()
        return button
    }()

    public override func prepareForReuse() {
        super.prepareForReuse()
        statusView.layoutIfNeeded()
    }
    
    public override func setupViews() {
        container.addSubview(statusView)
        container.addSubview(verifyButton)
    }
    
    public override func autolayout() {
        horizontalEdge = 16
        
        
        statusView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        verifyButton.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview().inset(16)
            make.top.equalTo(statusView.snp.bottom).inset(-12)
        }
    }
    
    public override func configureViews() {
        container.backgroundColor = .lightGrayBackground
        container.border()
        container.round()
    }
    
    public func setup(steps: [VerificationStatusStep]?, status: VerificationStatusType?) {
        verifyButton.setTitle("verify".localized())
        statusView.verifiedSteps = steps ?? []
        (status == .blocked) ? verifyButton.disableButton() : verifyButton.enableButton()
    }
    
}
