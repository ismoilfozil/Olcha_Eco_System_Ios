//
//  PincodeDotsView.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 10/02/23.
//

import UIKit
import OlchaUI
public class PincodeDotsView: BaseView {
    
    private let color: UIColor = .olchaAccentColor
    private let size: CGFloat = 20
    public let count: Int = 4
    
    private lazy var dotsContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .fill
        return stackView
    }()
    
    private var dots: [UIView] = []
    
    public override func setupViews() {
        addSubview(dotsContainer)
    }
    
    public override func autolayout() {
        dotsContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        for _ in 0..<count {
            let view = getDot()
            dotsContainer.addArrangedSubview(view)
            dots.append(view)
        }
    }
    
    private func getDot() -> UIView {
        let view = UIView()
        view.backgroundColor = .olchaWhite
        view.round(size / 2)
        view.border(with: color, width: 2)
        view.snp.makeConstraints { $0.width.height.equalTo(size) }
        return view
    }
    
    func changeState(step: Int) {
        for i in 0..<dots.count {
            let dot = dots[i]
            dot.border(with: color, width: 2)
            if i < step {
                dot.backgroundColor = .olchaAccentColor
            } else {
                dot.backgroundColor = .olchaWhite
            }
        }
    }
    
    func successState() {
        dots.forEach {
            $0.border(with: .olchaGreen, width: 2)
            $0.backgroundColor = .olchaGreen
        }
    }
    
    func errorState() {
        self.shake()
    }
    
    func defaultState() {
        dots.forEach {
            $0.border(with: color, width: 2)
            $0.backgroundColor = .white
        }
    }
}
