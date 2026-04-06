//
//  IconButton.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 30/06/22.
//


import UIKit
import SnapKit

public class IconButton: UIView {
    
    static let BACK_BUTTON_TAG = 12
    
    public let icon = UIImageView()
    public let settings = IButton()
//    private let settingsEnabledView = Button()
    
    public var index = 0
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(icon)
        addSubview(settings)
        icon.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview().inset(4)
        }
        
        settings.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
    }
    
    
    public func setIcon(_ image: UIImage?,
                        edgeSize: CGFloat = 4,
                        isIgnoringEdge: Bool = true
    ) {
        self.icon.image = image
        
        icon.snp.remakeConstraints { make in
            make.left.right.top.bottom.equalToSuperview().inset(edgeSize)
        }
        
        if isIgnoringEdge { ignoreEdge() }
    }
    
    public func ignoreEdge() {
        icon.snp.remakeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
    public func isEnabled(_ isEnabled: Bool) {
        settings.isEnabled = isEnabled
    }

    public func clicked(action: @escaping () -> Void) {
        settings.clicked(action)
    }
    
    public func updateLayout( with size: CGFloat) {
        icon.snp.remakeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.width.height.equalTo(size)
        }
    }
    
}
