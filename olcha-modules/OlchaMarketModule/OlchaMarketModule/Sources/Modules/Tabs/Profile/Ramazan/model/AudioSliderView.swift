//
//  AudioSliderView.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 15/03/23.
//

import OlchaUI
import UIKit
import AVFoundation
class AudioSliderView: UIView {
    private let container = UIView()
    private let playButton = IconButton()
    private let slider = UISlider()
    
    private var isPlaying: Bool = false {
        didSet {
            changeState()
        }
    }
    
    private var player: AVPlayer?
    
    private var path: String?
    
    var currentPlayingPath: ((String?) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        autolayout()
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        autolayout()
        configureViews()
    }
    
    private func setupViews() {
        addSubview(container)
        container.addSubview(playButton)
        container.addSubview(slider)
    }
    
    private func autolayout() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        playButton.snp.makeConstraints { make in
            make.width.height.equalTo(36)
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        slider.snp.makeConstraints { make in
            make.left.equalTo(playButton.snp.right).inset(-12)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    
    private func configureViews() {
        slider.tintColor = .olchaAccentColor
        slider.setThumbImage(UIImage(), for: .normal)
        playButton.backgroundColor = .olchaAccentColor
        
        playButton.clicked { [weak self] in
            guard let self = self else { return }
            self.isPlaying = !self.isPlaying
            
            if self.isPlaying {
                self.currentPlayingPath?(self.path)
            }
        }
        playButton.round(18)
        
        playButton.setIcon(.playing?.withColor(.olchaWhite),
                           edgeSize: 6,
                           isIgnoringEdge: false)
    }
    
    private func changeState() {
        playButton.setIcon(isPlaying ? .pausing?.withColor(.olchaWhite) : .playing?.withColor(.olchaWhite),
                           edgeSize: 6,
                           isIgnoringEdge: false)
        if isPlaying {
            player?.play()
        } else {
            player?.pause()
        }
        
    }
    
    func setup(path: String, currentPath: String) {
        self.path = path
        
        guard let bundlePath = Bundle.main.path(forResource: path,
                                                ofType: nil) else {
            return
        }
        
        let url = URL(fileURLWithPath: bundlePath)
        print("check last current path", path, currentPath)
        if player == nil {
            player = AVPlayer(url: url)
            addObserver()
        } else {
            if path != currentPath {
                isPlaying = false
            }
        }
        
    }
    
    private func addObserver() {
        player?.addPeriodicTimeObserver(forInterval: .init(value: 1, timescale: 30), queue: .main, using: { [weak self] time in
            guard let self = self,
                  let duration = self.player?.currentItem?.duration else { return }
            let fraction = CMTimeGetSeconds(time) / CMTimeGetSeconds(duration)
            self.slider.value = Float(fraction)
        })
    }
}
