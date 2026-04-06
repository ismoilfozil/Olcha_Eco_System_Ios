//
//  CommentRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 04/10/22.
//

import UIKit
import Combine
import OlchaUI
class CommentRoom: BaseTableCell {
    
    private let commentField = TMultiField()
    
    weak var commentObserver: PassthroughSubject<String, Never>?
    
    var initialComment: String? = "" {
        didSet {
            commentField.text = initialComment ?? ""
        }
    }
    
    override func setupViews() {
        container.addSubview(commentField)
    }
    
    override func autolayout() {
        commentField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
            make.height.equalTo(140)
        }
    }
    
    override func configureViews() {
        commentField.settings.observeText { [weak self] text in
            guard let self = self else { return }
            self.commentObserver?.send(text)
        }
    }
    
    func setup() {
        commentField.title = "add_review_to_product".localized()
    }
}

class CommentRoomView: BaseTableCellView {
    
    private let commentField = TMultiField()
    
    weak var commentObserver: PassthroughSubject<String, Never>?
    
    var initialComment: String? = "" {
        didSet {
            commentField.text = initialComment ?? ""
        }
    }
    
    override func setupViews() {
        container.addSubview(commentField)
    }
    
    override func autolayout() {
        commentField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
            make.height.equalTo(140)
        }
    }
    
    override func configureViews() {
        commentField.settings.observeText { [weak self] text in
            guard let self = self else { return }
            self.commentObserver?.send(text)
        }
    }
    
    func setup() {
        commentField.title = "add_review_to_product".localized()
    }
}
