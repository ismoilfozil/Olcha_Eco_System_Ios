//
//  KeyboardView.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 10/02/23.
//

import UIKit
import OlchaUI
import Combine
import OlchaUtils

public class KeyboardView: BaseView {
    public enum KeyboardItem: Int {
        case zero
        case one
        case two
        case three
        case four
        case five
        case six
        case seven
        case eight
        case nine
        case clear
        case logout
    }
    
    private lazy var mainContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 12
        return view
    }()
    
    private let size: CGFloat = 70
    
    private var items: [[KeyboardItem]] = [
        [.one,
         .two,
         .three],
        [.four,
         .five,
         .six],
        [.seven,
         .eight,
         .nine],
        [.logout,
         .zero,
         .clear]
    ]
    
    public var withLogout: Bool = false {
        didSet {
            configureViews()
        }
    }
    
    public var clickObserver: ((KeyboardItem) -> Void)?
    
    public override func setupViews() {
        addSubview(mainContainer)
    }
    
    public override func autolayout() {
        mainContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        mainContainer.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for i in 0..<items.count {
            let stackView = horizontalStack()
            for k in 0..<items[i].count {
                stackView.addArrangedSubview(createNumber(type: items[i][k]))
            }
            
            mainContainer.addArrangedSubview(stackView)
        }
    }
    
    private func createNumber(type: KeyboardItem) -> UIView {
        let view = UIView()
        view.backgroundColor = .olchaLightNeutralGray
        view.round(size / 2)
        view.snp.makeConstraints { $0.width.height.equalTo(size) }
        
        
        var button: IButton?
        
        switch type {
            
        case .logout:
            view.backgroundColor = .clear
            if withLogout {
                let logoutIcon = IconButton()
                logoutIcon.setIcon(.logout)
                logoutIcon.updateLayout(with: 26)
                view.addSubview(logoutIcon)
                logoutIcon.snp.makeConstraints { $0.edges.equalToSuperview() }
                button = logoutIcon.settings
            }
            
            break
        case .clear:
            let clearIcon = IconButton()
            clearIcon.setIcon(.clear)
            clearIcon.updateLayout(with: 26)
            view.addSubview(clearIcon)
            clearIcon.snp.makeConstraints { $0.edges.equalToSuperview() }
            button = clearIcon.settings
            view.backgroundColor = .clear
            break
        default:
            let numberButton = IButton()
            numberButton.titleLabel?.style(.semibold, 30)
            numberButton.setTitleColor(.olchaTextBlack, for: .normal)
            numberButton.setTitle(type.rawValue.string, for: .normal)
            view.addSubview(numberButton)
            numberButton.snp.makeConstraints { $0.edges.equalToSuperview() }
            button = numberButton
            break
        }
        
        button?.clicked { [weak self] in
            guard let self = self else { return }
            self.clicked(type: type)
        }
        
        return view
    }
    
    private func horizontalStack() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 24
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        return stackView
    }
    
    private func clicked(type: KeyboardItem) {
        clickObserver?(type)
    }
}
