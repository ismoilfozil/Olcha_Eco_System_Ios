//
//  RamazanAudioRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 14/03/23.
//

import UIKit
import OlchaUI
class RamazanAudioView: UIView {

    private let containerStackView = UIStackView()
    private let headerContainer = UIView()
    private let titleLabel = UILabel()
    let dropDownIcon = IconButton()
    private let separator = Divide()
    private let contentContainer = UIView()
    private let contentTitleLabel = UILabel()
    
    let audioPlayer = AudioSliderView()
    
    var isExpanded: Bool = true {
        didSet {
            self.contentContainer.isHidden = !self.isExpanded
            self.audioPlayer.isHidden = !self.isExpanded
            self.dropDownIcon.rotate()
            UIView.animate(withDuration: 0.2,
                           delay: 0.0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 1,
                           options: [.curveEaseInOut],
                           animations: {
                
                self.containerStackView.layoutIfNeeded()
            },
                           completion: nil)
            
        }
    }
    
    var model: RamazanAudioModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        baseSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        baseSetup()
    }
    
    private func baseSetup() {
        setupViews()
        autolayout()
        configureViews()
    }
    
    private func setupViews() {
        addSubview(containerStackView)
        containerStackView.addArrangedSubview(headerContainer)
        containerStackView.addArrangedSubview(separator)
        containerStackView.addArrangedSubview(contentContainer)
        containerStackView.addArrangedSubview(audioPlayer)
        
        headerContainer.addSubview(titleLabel)
        headerContainer.addSubview(dropDownIcon)
        
        contentContainer.addSubview(contentTitleLabel)
    }
    
    private func autolayout() {
        containerStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
        }
        
        headerContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(8)
            make.right.equalTo(dropDownIcon.snp.left).inset(-8)
        }
        
        dropDownIcon.snp.makeConstraints { make in
            make.width.height.equalTo(36)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        contentContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        contentTitleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.left.right.equalToSuperview().inset(12)
        }
        
        audioPlayer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
    }
    
    private func configureViews() {
        containerStackView.axis = .vertical
        containerStackView.spacing = 10
        
        titleLabel.style(.medium, 16)
        titleLabel.textColor = .olchaTextBlack
        
        contentContainer.backgroundColor = .olchaLightNeutralGray
        contentContainer.round()
        
        contentTitleLabel.style(.medium, 16)
        contentTitleLabel.textColor = .olchaTextBlack
        contentTitleLabel.numberOfLines = 0
        
        dropDownIcon.setIcon(.down_anchor, edgeSize: 4, isIgnoringEdge: false)
    }
    
    func setup(with data: RamazanAudioModel, currentPath: String) {
        self.model = data
        titleLabel.text = data.title
        contentTitleLabel.text = data.content
        audioPlayer.setup(path: data.audioPath,
                          currentPath: currentPath)
    }
    
}

