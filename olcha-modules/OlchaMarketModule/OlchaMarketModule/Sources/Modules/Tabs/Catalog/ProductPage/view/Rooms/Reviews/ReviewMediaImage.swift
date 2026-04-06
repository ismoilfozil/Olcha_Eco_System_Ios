//
//  ReviewMediaImage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 01/08/22.
//

import UIKit
import AVKit
import OlchaUI
import OlchaUtils
class ReviewMediaImage: BaseCollectionCell {

    let imageView = UIImageView()
    
    private let videoContainer = UIView()
    private let videoController = AVPlayerViewController()
    private var player: AVPlayer?
    
    
    
    override func setupViews() {
        container.addSubview(imageView)
        container.addSubview(videoContainer)
        videoContainer.addSubview(videoController.view)
    }
    
    override func autolayout() {
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        videoContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        videoController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    override func configureViews() {
        container.clipsToBounds = true
        container.backgroundColor = .clear
        imageView.backgroundColor = .clear
        
        
        videoContainer.isHidden = true
        imageView.contentMode = .scaleAspectFit
    }
    
    func setup(with data: String?) {
        imageView.load(from: data,
                       imageType: .ignoreResize)
        
    }
    
    func setup(video: Video?) {
        videoContainer.isHidden = false
        if let url = video?.url {
            player = AVPlayer(url: url)
            videoController.player = player
            videoController.videoGravity = .resizeAspect
        }
    }
    

    
    func playVideo() {
        if player != nil {
            player?.play()
        }
    }
    
    func stopVideo() {
        if player != nil {
            player?.pause()
        }
    }
}
