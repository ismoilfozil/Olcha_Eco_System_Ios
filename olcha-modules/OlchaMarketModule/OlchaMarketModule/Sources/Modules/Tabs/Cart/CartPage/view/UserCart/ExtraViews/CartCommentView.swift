//
//  CartCommentView.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 28/06/24.
//

import UIKit
import OlchaUI

final class CartCommentView: BaseView {
    
    private let leftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .cart_comment?.withColor(.olchaLightTextColornnnnnn ?? .lightGray)
        return imageView
    }()
    
    private let textView: PlaceholderTextView = {
        let textView = PlaceholderTextView()
        textView.placeholder = "cart_comment".localized()
        textView.font = .style(.medium, 14)
        return textView
    }()
    
    private let rightImageView: IconButton = {
        let imageView = IconButton()
        imageView.setIcon(.cart_comment_send, edgeSize: 4, isIgnoringEdge: false)
        return imageView
    }()
    
    private let maxHeight: CGFloat = 150
    private let minHeight: CGFloat = 36
    private let iconSize: CGFloat = 20
    private let margin: CGFloat = 16
    
    var initialComment: String = "" {
        didSet {
            textView.setText(initialComment)
            checkState()
        }
    }
    
    var commentObserver: ((String?) -> Void)?
    
    override func setupViews() {
        addSubview(leftImageView)
        addSubview(textView)
        addSubview(rightImageView)
    }
    
    override func autolayout() {
        leftImageView.snp.makeConstraints { make in
            make.width.height.equalTo(iconSize)
            make.bottom.equalToSuperview().inset(margin + max(0, (minHeight - iconSize)/2))
            make.left.equalToSuperview().inset(12)
        }
        
        textView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(margin)
            make.left.equalTo(leftImageView.snp.right).inset(-14)
            make.right.equalTo(rightImageView.snp.left).inset(-14)
            make.top.equalToSuperview().inset(margin)
            make.height.equalTo(minHeight)
        }
        
        rightImageView.snp.makeConstraints { make in
            make.width.height.equalTo(iconSize + 8)
            make.right.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(margin + max(0, (minHeight - iconSize)/2))
        }
    }
    
    override func configureViews() {
        backgroundColor = .olchaWhite
        
        textView.observeText { [weak self] _ in
            guard let self else { return }
            checkState()
        }
        
        rightImageView.clicked { [weak self] in
            guard let self else { return }
            commentObserver?(textView.getText())
        }
    }
    
    func getComment() -> String {
        textView.getText()
    }
    
    private func checkState() {
        rightImageView.isHidden = textView.getText() == ""
        checkHeight()
    }
    
    private func checkHeight() {
        textView.layoutIfNeeded()
        let height = textView.contentSize.height
        textView.snp.updateConstraints { make in
            make.height.equalTo(min(max(minHeight, height), maxHeight))
        }
    }
    
}


//MARK: - Actions
extension CartCommentView {
    func clearComment() {
        textView.setText("")
    }
    
    func openKeyboard() {
        textView.becomeFirstResponder()
    }
}
