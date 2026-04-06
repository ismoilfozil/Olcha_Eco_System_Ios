//
//  LikeButton.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 20/07/22.
//


import UIKit
protocol LikeSegmentDelegate: AnyObject {
    func selected(type: LikeSegment.Value)
}
class LikeSegment: UIView {
    enum Value {
        case liked
        case disliked
        case none
    }
    
    private let container = UIView()
    
    private let dislikeContainer = UIView()
    private let dislikeCount = UILabel()
    private let dislikeIcon = UIImageView()
    let dislike = Button()
    
    private let likeContainer = UIView()
    private let likeCount = UILabel()
    private let likeIcon = UIImageView()
    let like = Button()
    
    weak var delegate: LikeSegmentDelegate?
    
    var likesCount = 0 {
        didSet {
            if likesCount < 0 { likesCount = 0 }
            self.likeCount.text = likesCount.string
        }
    }
    
    var dislikesCount = 0 {
        didSet {
            if dislikesCount < 0 { dislikesCount = 0 }
            self.dislikeCount.text = dislikesCount.string
        }
    }
    
    var currentType: Value = .none {
        didSet {
            stateChanged()
        }
    }
    
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
        self.addSubview(container)
        self.container.addSubview(dislikeContainer)
        self.container.addSubview(likeContainer)
        
        self.dislikeContainer.addSubview(dislikeIcon)
        self.dislikeContainer.addSubview(dislikeCount)
        self.dislikeContainer.addSubview(dislike)
        
        self.likeContainer.addSubview(likeIcon)
        self.likeContainer.addSubview(likeCount)
        self.likeContainer.addSubview(like)
    }
    
    private func autolayout() {
        self.container.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        self.dislikeContainer.snp.makeConstraints { make in
            make.top.bottom.right.equalToSuperview()
            make.width.greaterThanOrEqualTo(60)
        }
        
        self.likeContainer.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
            make.right.equalTo(self.dislikeContainer.snp.left).inset(-8)
            make.width.greaterThanOrEqualTo(60)
        }
        
        self.likeIcon.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(8)
            make.top.bottom.equalToSuperview().inset(4)
            make.width.height.equalTo(20)
        }
        
        self.likeCount.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(self.likeIcon.snp.right).inset(-4)
            make.right.equalToSuperview().inset(8)
        }
        
        self.like.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        self.dislikeIcon.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(8)
            make.top.bottom.equalToSuperview().inset(4)
            make.width.height.equalTo(20)
        }
        
        self.dislikeCount.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(self.dislikeIcon.snp.right).inset(-4)
            make.right.equalToSuperview().inset(8)
        }
        
        self.dislike.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
    private func configureViews() {
        self.defaultAppearance()
        
        self.like.clicked { [weak self] in
            guard let self = self else { return }
            self.delegate?.selected(type: .liked)
            switch self.currentType {
            case .liked:
                self.currentType = .none
                self.likesCount -= 1
                break
            case .disliked:
                self.currentType = .liked
                self.likesCount += 1
                self.dislikesCount -= 1
                break
            case .none:
                self.currentType = .liked
                self.likesCount += 1
                break
            }
            
        }
        
        self.dislike.clicked { [weak self] in
            guard let self = self else { return }
            self.delegate?.selected(type: .disliked)
            switch self.currentType {
            case .disliked:
                self.currentType = .none
                self.dislikesCount -= 1
                break
            case .liked:
                self.currentType = .disliked
                self.dislikesCount += 1
                self.likesCount -= 1
                break
            case .none:
                self.currentType = .disliked
                self.dislikesCount += 1
                break
            }
        }
        
        self.likeCount.text = "0"
        self.dislikeCount.text = "0"
    }

    private func stateChanged() {
        self.defaultAppearance()
        
        switch currentType {
        case .liked:
            self.likeContainer.backgroundColor = .olchaGreen
            self.likeCount.textColor = .olchaWhite
            self.likeIcon.image = .like?.withTintColor(.olchaWhite, renderingMode: .alwaysOriginal)
            break
        case .disliked:
            self.dislikeContainer.backgroundColor = .olchaAccentColor
            self.dislikeCount.textColor = .olchaWhite
            self.dislikeIcon.image = .dislike?.withTintColor(.olchaWhite, renderingMode: .alwaysOriginal)
            break
        case .none:
            break
        }
    }
    
    private func defaultAppearance() {
        [self.likeContainer, self.dislikeContainer]
            .forEach{ $0.round(14);
                      $0.backgroundColor = .olchaLightNeutralGray
            }
            
        [self.likeCount, self.dislikeCount]
            .forEach {
                $0.style(.medium, 14);
                $0.textColor = .olchaTextBlack;
                $0.textAlignment = .center
            }
        
        self.likeIcon.image = .like
        self.dislikeIcon.image = .dislike
    }
    
    
    func setup(with data: CommentRating?) {
        self.likesCount = data?.like ?? 0
        self.dislikesCount = data?.dislike ?? 0
        
        if (data?.is_like ?? false) {
            self.currentType = .liked
        }
        
        if (data?.is_dislike ?? false) {
            self.currentType = .disliked
        }
    }
    
}
