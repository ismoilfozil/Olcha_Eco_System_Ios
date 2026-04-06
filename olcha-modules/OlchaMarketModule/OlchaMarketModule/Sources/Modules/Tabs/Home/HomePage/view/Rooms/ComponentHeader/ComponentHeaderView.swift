//
//  ComponentHeaderView.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 05/09/22.
//

import Combine
import UIKit
class ComponentHeaderView: UIView {
    
    enum PromotedRoomType {
        case title(String)
        case timeTitle(String)
        case banner(String?)
    }
    
    private let headerStackView = UIStackView()
    private let titleContainer = UIStackView()
    let roomTitle = UILabel()
    private let timerContainer = UIView()
    private let timer = UILabel()
    private let bannerContainer = UIView()
    let banner = UIImageView()
    private let bannerButton = Button()
    
    weak var headerObserver: PassthroughSubject<ComponentDataModel?, Never>?
    
    var header: ComponentDataModel?
    
    var timerManager: TimerManager?
    
    var style: PromotedRoomView.ProductCellStyle = .white {
        didSet {
            backgroundColor = style.color
        }
    }
    
    private let bannerHeight: CGFloat = 88.0
    public var bottomEdge: CGFloat = 16 {
        didSet {
            updateLayout()
        }
    }
    
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
    
    func setupViews() {
        addSubview(headerStackView)
        headerStackView.addArrangedSubview(bannerContainer)
        headerStackView.addArrangedSubview(titleContainer)
        
        bannerContainer.addSubview(banner)
        bannerContainer.addSubview(bannerButton)
        titleContainer.addArrangedSubview(roomTitle)
        titleContainer.addArrangedSubview(timerContainer)
        timerContainer.addSubview(timer)
        
        
    }
    
    func autolayout() {
        headerStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }
        
        bannerContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(bannerHeight)
        }
        
        bannerButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        banner.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(bannerHeight)
        }
        
        timerContainer.snp.makeConstraints { make in
            make.width.equalTo(83)
            make.height.equalTo(24)
            make.centerY.equalToSuperview()
        }
        
        timer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureViews() {
        banner.contentMode = .scaleToFill
        backgroundColor = .clear
        banner.contentMode = .scaleAspectFill
        banner.round()
        bannerContainer.round()
        roomTitle.style(.semibold, 24)
        roomTitle.textColor = .olchaTextBlack
        roomTitle.numberOfLines = 0
        headerStackView.axis = .vertical
        headerStackView.distribution = .fill
        titleContainer.axis = .horizontal
        titleContainer.alignment = .center
        headerStackView.clipsToBounds = true
        
        bannerButton.clicked { [weak self] in
            guard let self = self else { return }
            self.headerObserver?.send(self.header)
        }
        
        
        timer.style(.regular, 14)
        timer.textColor = .olchaTextBlack
        timer.textAlignment = .center
        
        timerContainer.border(with: .olchaLightNeutralDarkGray)
        timerContainer.round(6)
        timerContainer.backgroundColor = .white
    }
    
    func setup(with model: ComponentModel?) {
        if let header = model?.header {
            self.header = header
            configure(with: .banner(header.getImageUrl()))
        } else {
            configure(with: .title(model?.getName() ?? ""))
        }
    }
    
    func configure( with type: PromotedRoomType) {
        bannerContainer.isHidden = true
        titleContainer.isHidden = true
        switch type {
        case .banner(let url):
            bannerContainer.isHidden = false
            banner.load(from: url, contentMode: .scaleAspectFill)
            return
        case .title(let title):
            timerContainer.isHidden = true
            titleContainer.isHidden = false
            roomTitle.text = title
            return
        case .timeTitle(let title):
            timerContainer.isHidden = false
            timerManager = TimerManager()
            
            titleContainer.isHidden = false
            roomTitle.text = title
            
            startTiming()
            return
        }
    }
    
    private func startTiming() {
        timerManager?.observer = { [weak self] text in
            guard let self = self else { return }
            self.timer.text = text
        }
    }
    
    private func updateLayout() {
        headerStackView.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(bottomEdge)
            make.left.right.equalToSuperview().inset(16)
        }
    }

}
