//
//  SearchNavigationBar.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 28/10/22.
//

import SnapKit
import UIKit
import OlchaUI
class SearchNavigationBar: UIView {
    
    let backButton = IconButton()
    let searchView = SearchView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initViews()
    }
    
    private func initViews() {
        addSubview(backButton)
        addSubview(searchView)
        
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        searchView.snp.makeConstraints { make in
            make.left.equalTo(backButton.snp.right).inset(-16)
            make.right.equalToSuperview().inset(16)
            make.height.equalTo(36)
            make.centerY.equalToSuperview()
        }
        
        configureViews()
    }
    
    private func configureViews() {
        backButton.setIcon(.left_anchor)
        searchView.setPlaceholder()
    }
}
