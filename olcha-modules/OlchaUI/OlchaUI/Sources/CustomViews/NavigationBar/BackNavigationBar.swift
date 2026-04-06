//
//  BackNavigationBar.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 06/07/22.
//


import UIKit

public class BackNavigationBar: UIView, BaseNavigationInput {
    public weak var delegate: BaseNavigationOutput?
    
    public let titlesStack = UIStackView()
    public let searchButton = IconButton()
    let clearButton = IButton()
    let navigationIcon = IconButton()
    public let navigationTitle = UILabel()
    public let navigationSubtitle = UILabel()
    public let backButton = IconButton()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initBackNavBar()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initBackNavBar()
    }
    
    private func initBackNavBar() {

        addSubview(backButton)
        addSubview(navigationIcon)
        addSubview(titlesStack)
        addSubview(searchButton)
        
        
        titlesStack.addArrangedSubview(navigationTitle)
        titlesStack.addArrangedSubview(navigationSubtitle)
        
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        searchButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.right.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        titlesStack.snp.makeConstraints { make in
            make.right.equalTo(self.searchButton.snp.left).inset(-8)
            make.centerY.equalToSuperview()
        }
        
        navigationIcon.snp.makeConstraints { make in
            make.height.equalTo(28)
            make.width.equalTo(0)
            make.centerY.equalToSuperview()
            make.left.equalTo(backButton.snp.right).inset(-8)
            make.right.equalTo(navigationTitle.snp.left).inset(-8)
        }
        
        configureBackNavigationBar()
    }
    
    private func configureBackNavigationBar() {
        
        titlesStack.axis = .vertical
        titlesStack.spacing = 0
        
        backButton.setIcon(.left_anchor)
        searchButton.setIcon(.search_bordered)
        
        navigationTitle.style(.medium, 16)
        navigationTitle.textColor = .olchaTextBlack
        searchButton.isHidden = true
        
        navigationSubtitle.style(.medium, 12)
        navigationSubtitle.textColor = .olchaLightTextColornnnnnn
        navigationSubtitle.isHidden = true
        
        
        backButton.clicked { [weak self] in
            guard let self = self else { return }
            self.delegate?.backButtonClicked()
        }
    }
    
    func configureClearNavigationBar() {
        searchButton.removeFromSuperview()
        addSubview(clearButton)
        
        clearButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
        }
        
        clearButton.setTitleColor(.olchaAccentColor, for: .normal)
        
        clearButton.titleLabel?.style(.medium, 16)
    }
    
    func configureReviewMediaNavigationBar(fromReview: Bool = false) {
        backgroundColor = .black
        if fromReview {
            navigationIcon.snp.updateConstraints { make in
                make.width.equalTo(28)
            }
        }
        
        hideSearchButton()
        
        navigationIcon.setIcon(.profile)
        backButton.setIcon(.left_anchor?.withColor(.white))
        navigationTitle.style(.semibold, 14)
        navigationTitle.textColor = .white
        
    }
    
    public func clearNavigationBackground() {
        backgroundColor = .clear
    }
    
    
    func hideSearchButton() {
        searchButton.snp.updateConstraints { make in
            make.width.equalTo(0)
        }
    }
    
    public func setTitle(_ title: String?) {
        navigationTitle.text = title
    }
}
