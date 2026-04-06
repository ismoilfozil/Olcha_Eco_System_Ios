//
//  ShowVideoRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 09/11/22.
//

import UIKit
import OlchaUI
class ShowVideoRoom: BaseTableCell {

    let videoButton = LeftIconButton()
    
    override func setupViews() {
        container.addSubview(videoButton)
    }
    
    override func autolayout() {
        videoButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
    }
    
    override func configureViews() {
        videoButton.setIcon(.video_play?.withColor(.olchaAccentColor), iconSize: 24)
        videoButton.setTitle("play_video".localized())
        videoButton.titleLabel.style(.medium, 14)
        videoButton.titleLabel.textColor = .olchaAccentColor
    }
    
}

class ShowVideoRoomView: BaseTableCellView {

    let videoButton = LeftIconButton()
    
    override func setupViews() {
        container.addSubview(videoButton)
    }
    
    override func autolayout() {
        videoButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
    }
    
    override func configureViews() {
        videoButton.setIcon(.video_play?.withColor(.olchaAccentColor), iconSize: 24)
        videoButton.setTitle("play_video".localized())
        videoButton.titleLabel.style(.medium, 14)
        videoButton.titleLabel.textColor = .olchaAccentColor
    }
    
}
