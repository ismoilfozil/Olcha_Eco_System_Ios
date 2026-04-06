//
//  KeyboardFilter.swift
//  Week_help
//
//  Created by Elbek Khasanov on 30/08/22.
//

import UIKit
fileprivate struct LetterItem {
    let title: String
    let isBig: Bool
}

protocol KeyboardFilterDelegate: AnyObject {
    func clicked(letter: String)
}

class KeyboardFilter: UIView {
    
    weak var delegate: KeyboardFilterDelegate?
    
    struct Constants {
        static let width:  CGFloat = UIScreen.main.bounds.width
        static let margin: CGFloat = 16.0
        static let counts: CGFloat = 7
        static let size:   CGFloat = (width - (margin * 2)) / counts
    }
    
    private let container = UIStackView()
    
    private var letters: [[LetterItem]] = [
        
        [.init(title: "all_big".localized(), isBig: true),
         .init(title: "A", isBig: false),
         .init(title: "B", isBig: false),
         .init(title: "C", isBig: false),
         .init(title: "D", isBig: false),
         .init(title: "E", isBig: false)],
        
        [.init(title: "F", isBig: false),
         .init(title: "G", isBig: false),
         .init(title: "H", isBig: false),
         .init(title: "I", isBig: false),
         .init(title: "J", isBig: false),
         .init(title: "K", isBig: false),
         .init(title: "L", isBig: false)],
        
        [.init(title: "M", isBig: false),
         .init(title: "N", isBig: false),
         .init(title: "O", isBig: false),
         .init(title: "P", isBig: false),
         .init(title: "Q", isBig: false),
         .init(title: "R", isBig: false),
         .init(title: "S", isBig: false)],
        
        
        [.init(title: "T", isBig: false),
         .init(title: "U", isBig: false),
         .init(title: "V", isBig: false),
         .init(title: "X", isBig: false),
         .init(title: "Y", isBig: false),
         .init(title: "Z", isBig: false)],
        
        [.init(title: "А - Я", isBig: true),
         .init(title: "0 - 9", isBig: true)]
        
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        baseSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        baseSetup()
    }
    
    private func baseSetup() {
        setupViews()
        autolayout()
        configureViews()
    }
    
    private func setupViews() {
        addSubview(container)
    }
    
    private func autolayout() {
        container.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(Constants.margin)
        }
    }
    
    private func configureViews() {
        container.axis = .vertical
        container.spacing = 4
        container.alignment = .center
        container.subviews.forEach { $0.removeFromSuperview() }
        
        for i in 0..<letters.count {
            let horizontalStackView = getHorizontalStack()
            for k in 0..<letters[i].count {
                let item = letters[i][k]
                let letterItem = getLetterItem(text: item.title,
                                               isBig: item.isBig,
                                               isAccented: (i == 0 && k == 0)
                )
                horizontalStackView.addArrangedSubview(letterItem)
            }
            container.addArrangedSubview(horizontalStackView)
        }
        
    }
    
    private func getHorizontalStack() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        
        return stackView
    }
    
    private func getLetterItem(text: String, isBig: Bool, isAccented: Bool = false) -> UIView {
        let containerView = UIView()
        let contentView = UIView()
        let label = UILabel()
        let button = Button()
        
        label.text = text
        label.textAlignment = .center
        label.style(.medium, 16)
        label.textColor = .olchaTextBlack
        
        contentView.round(8)
        contentView.border(with: .olchaTextBlack, width: 2)
        
        button.backgroundColor = .clear
        
        containerView.addSubview(contentView)
        contentView.addSubview(label)
        containerView.addSubview(button)
        
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
        
        containerView.snp.makeConstraints { make in
            make.width.equalTo(isBig ? (Constants.size * 2) : Constants.size)
            make.height.equalTo(Constants.size)
        }
        
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        button.clicked { [weak self] in
            guard let self = self else { return }
            self.clicked(letter: text)
        }
        
        if isAccented {
            label.textColor = .olchaWhite
            contentView.backgroundColor = .olchaAccentColor
            contentView.border(with: .olchaAccentColor, width: 0)
        }
        
        return containerView
    }
    
    private func clicked( letter: String) {
        delegate?.clicked(letter: letter)
    }
    
}

