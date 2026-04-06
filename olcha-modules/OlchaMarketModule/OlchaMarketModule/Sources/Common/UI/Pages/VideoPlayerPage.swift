//
//  VideoPlayerPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 09/11/22.
//

import UIKit
import OlchaUI

import OlchaUtils
class VideoPlayerPage: BaseViewController {
    
    var videoURL: String = ""
    
    private let playerView = YouTubePlayerView()
    
    override func setupViews() {
        container.addSubview(playerView)
    }
    
    override func autolayout() {
        playerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(300)
            make.centerY.equalToSuperview()
        }
    }
    
    override func configureViews() {
        
        playerView.backgroundColor = .black
        view.backgroundColor = .olchaBackgroundColor
        navigation.configure(style: .back)
        let bundle = Bundle(for: YouTubePlayerView.self) 
        playerView.bundle = bundle
        guard let url = URL(string: videoURL) else { return }
        playerView.loadVideoURL(url)
        playerView.play()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        playerView.play()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        playerView.pause()
    }
    
}
