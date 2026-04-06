//
//  LimitToaster.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 15/06/23.
//

import UIKit
import OlchaUI
public class LimitToaster: BaseView {
    
    private let shadowContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .olchaWhite
        return view
    }()
    private let container: UIView = {
        let view = UIView()
        
        view.backgroundColor = .olchaWhite
        
        return view
    }()
    
    private let sliderContainer: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .olchaGreen?.withAlphaComponent(0.2)
        return view
    }()
    private let slider: UIView = {
        let view = UIView()
        view.backgroundColor = .olchaGreen

        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 14)
        label.textColor = .olchaTextBlack
        label.numberOfLines = 0
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .olchaLightTextColornnnnnn
        label.numberOfLines = 0
        label.style(.medium, 12)
        return label
    }()
    
    private let xButton: IconButton = {
        let button = IconButton()
        button.setIcon(.x, isIgnoringEdge: true)
        return button
    }()
    
    public override func setupViews() {
        addSubview(shadowContainer)
        shadowContainer.addSubview(container)
        container.addSubview(sliderContainer)
        sliderContainer.addSubview(slider)
        container.addSubview(titleLabel)
        container.addSubview(xButton)
        container.addSubview(contentLabel)
    }
    
    public override func autolayout() {
        shadowContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        sliderContainer.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(6)
        }
        
        slider.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(12)
            make.top.equalToSuperview().inset(16)
        }
        
        xButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.top.equalTo(titleLabel.snp.top)
            make.right.equalToSuperview().inset(16)
            make.left.equalTo(titleLabel.snp.right).inset(-16)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.left)
            make.right.equalTo(titleLabel.snp.right)
            make.top.equalTo(titleLabel.snp.bottom).inset(-4)
            make.bottom.equalToSuperview().inset(12)
        }
    }
    
    public override func configureViews() {
        xButton.clicked { [weak self] in
            guard let self = self else { return }
            finishToaster()
        }
        
        container.round()
        shadowContainer.round()
        shadowContainer.shadowAdd(offset: .init(width: 0, height: 4), color: .lightGray, opacity: 0.7, radius: 16)
    }
    
    public func setup(title: String?, content: String?) {
        titleLabel.text = title ?? " - "
        contentLabel.text = content ?? " - "
        alphaAnimate(isPresenting: true) { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.animateSlider()
            }
        }
        
    }
    
    private func animateSlider() {
        
        slider.snp.remakeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(1)
        }
        
        UIView.animate(withDuration: 5) { [weak self] in
            guard let self = self else { return }
            self.sliderContainer.layoutIfNeeded()
        } completion: { [weak self] finished in
            guard let self = self, finished else { return }
            finishToaster()
        }
        
    }
    
    private func finishToaster() {
        alphaAnimate(isPresenting: false) { [weak self] in
            guard let self = self else { return }
            if superview != nil {
                removeFromSuperview()
            }
        }
    }
    
    private func alphaAnimate(isPresenting: Bool,  completion: @escaping (() -> Void)) {
        alpha = isPresenting ? 0 : 1
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else { return }
            alpha = isPresenting ? 1 : 0
        } completion: { isFinished in
            guard isFinished else { return }
            completion()
        }
    }
}
