//
//  NavBar.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 29/06/22.
//

import UIKit
import SnapKit
@objc protocol NavBarDelegate: AnyObject {
    @objc func popPage()
}
class OlchaNavigationBar: UIView {
    
    enum NavBarType {
        case main
        case searchAction
        case search
        case back
        case clear
        case product
        case review(fromReview: Bool)
        case center
    }
    
    /// home
    let home = MainNavigationBar()
    /// search
    let searchAction = SearchActionNavigationBar()
    /// search
    let search = SearchNavigationBar()
    /// back
    let back = BackNavigationBar()
    /// clear
    let clear = BackNavigationBar()
    /// review media
    let review = BackNavigationBar()
    /// product
    let product = ProductPageNavigationBar()
    /// center
    let centerTitle = TitleNavigationBar()
    
    weak var delegate: NavBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        baseSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        baseSetup()
    }
    
    private func baseSetup() {
        self.backgroundColor = .olchaBackgroundColor
        
        [product.backButton,
         clear.backButton,
         back.backButton,
         review.backButton,
         centerTitle.backButton,
         search.backButton
        ].forEach { [weak self] button in
            guard let self = self else { return }
            button.clicked {
                self.delegate?.popPage()
            }
        }
   }
    
    func configure(style: NavBarType) {
        switch style {
        case .main:
            setup(navigation: home)
        case .searchAction:
            setup(navigation: searchAction)
        case .search:
            setup(navigation: search)
        case .back:
            setup(navigation: back)
        case .clear:
            setup(navigation: clear)
            clear.configureClearNavigationBar()
            break
        case .product:
            setup(navigation: product)
        case .review(let fromReview):
            setup(navigation: review)
            review.configureReviewMediaNavigationBar(fromReview: fromReview)
            break
        case .center:
            setup(navigation: centerTitle)
        }
    }
    
    
    func setTitle(_ title: String) {
        [back.navigationTitle,
         review.navigationTitle,
         centerTitle.navigationTitle
        ].forEach { $0.text = title }
    }
    
    func setSubtitle(_ title: String) {
        if title != "" {
            back.navigationSubtitle.isHidden = false
            back.navigationSubtitle.text = title
        }
    }
    
    func showBackButton() {
        [centerTitle.backButton].forEach {
            $0.isHidden = false
        }
    }
    
    private func setup(navigation: UIView) {
        self.addSubview(navigation)
        navigation.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
}
