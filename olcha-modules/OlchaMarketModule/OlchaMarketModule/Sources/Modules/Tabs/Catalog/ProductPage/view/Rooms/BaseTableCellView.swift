//
//  BaseTableCellView.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 01/11/23.
//

import UIKit
open class BaseTableCellView: UIView {
    
    public let container = UIView()
    
    public var horizontalEdge: CGFloat = 0 {
        didSet {
            updateLayout()
        }
    }
    
    public var verticalEdge: CGFloat = 0 {
        didSet {
            updateLayout()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        baseSetup()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        baseSetup()
    }
    
    
    private func baseSetup() {
        addSubview(container)
        container.snp.makeConstraints { $0.edges.equalToSuperview() }
        setupViews()
        autolayout()
        configureViews()
    }
    open func setupViews() {}
    open func autolayout() {}
    open func configureViews() {}
    open func languageUpdated() {}
    
    private func updateLayout() {
        container.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(horizontalEdge)
            make.top.bottom.equalToSuperview().inset(verticalEdge)
        }
    }
}
