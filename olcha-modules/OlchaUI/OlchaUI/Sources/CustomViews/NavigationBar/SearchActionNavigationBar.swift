//
//  SearchNavigationBar.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 06/07/22.
//

import SnapKit
import UIKit
public class SearchActionNavigationBar: UIView, BaseNavigationInput {
    
    public weak var delegate: BaseNavigationOutput?
    
    public let searchView = SearchView()
    let notificationButton = IconButton()
    let searchButton = IButton()
    
    private let notificationSize: CGFloat = 24
    
    public var withNotification: Bool = true {
        didSet {
            notificationButton.snp.updateConstraints { $0.width.equalTo(withNotification ? notificationSize : 0) }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initViews()
    }
    
    private func initViews() {
        addSubview(searchView)
        addSubview(notificationButton)
        addSubview(searchButton)
        
        searchView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.height.equalTo(36)
            make.centerY.equalToSuperview()
        }
        
        notificationButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.width.height.equalTo(notificationSize)
            make.left.equalTo(searchView.snp.right).inset(-8)
            make.centerY.equalToSuperview()
        }
        
        searchButton.snp.makeConstraints { make in
            make.edges.equalTo(searchView.snp.edges)
        }
        
        configureViews()
    }
    
    func disableSearchButton() {
        searchButton.removeFromSuperview()
    }
    
    private func configureViews() {
        searchView.setPlaceholder()
        notificationButton.setIcon(.bellIcon)
    }
}
