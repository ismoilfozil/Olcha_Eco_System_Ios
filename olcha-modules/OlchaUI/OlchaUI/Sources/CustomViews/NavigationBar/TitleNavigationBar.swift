//
//  TitleNavigationBar.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 06/09/22.
//

import UIKit
import SnapKit
public class TitleNavigationBar: UIView, BaseNavigationInput {
    
    public let navigationTitle = UILabel()
    public let backButton = IconButton()
    public let searchButton = IconButton()

    public var withSearch : Bool = false {
        didSet {
            searchButton.isHidden = !withSearch
        }
    }
    
    public weak var delegate: BaseNavigationOutput?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initBackNavBar()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initBackNavBar()
    }
    
    private func initBackNavBar() {
        addSubview(navigationTitle)
        addSubview(backButton)
        addSubview(searchButton)
        
        navigationTitle.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.left.equalTo(backButton.snp.right).inset(-8)
        }
        
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        searchButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        searchButton.setIcon(.search_bordered)
        searchButton.isHidden = true
        navigationTitle.textAlignment = .center
        navigationTitle.style(.medium, 16)
        navigationTitle.textColor = .olchaTextBlack

        backButton.setIcon(.left_anchor)
        backButton.clicked { [weak self] in
            guard let self = self else { return }
            self.delegate?.backButtonClicked()
        }
    }
    
    public func setTitle(_ title: String) {
        navigationTitle.text = title
    }
}
