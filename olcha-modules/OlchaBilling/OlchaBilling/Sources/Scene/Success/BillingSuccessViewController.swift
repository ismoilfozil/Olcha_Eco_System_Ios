//
//  BillingSuccessViewController.swift
//  OlchaBilling
//
//  Created by Elbek Khasanov on 20/06/23.
//


import UIKit
import OlchaUI
import OlchaUtils
import Lottie

public class BillingSuccessViewController: BaseViewController<EmptyNavigationBar> {
    
    private let animationView: AnimationView = {
        let animationView = AnimationView()
        animationView.setup(bundleIdentifier: BundleType.ui.identifier,
                            name: "success")
        return animationView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 20)
        label.numberOfLines = 0
        label.textColor = .olchaTextBlack
        label.textAlignment = .center
        label.text = "pay_success".localized(.billing)
        return label
    }()
    
    private let acceptButton : OlchaButton = {
        let button = OlchaButton()
        button.setTitle("close".localized())
        return button
    }()
    
    weak var coordinator: BillingCoordinatorProtocol?
    
    public override func setupViews() {
        container.addSubview(animationView)
        container.addSubview(titleLabel)
        container.addSubview(acceptButton)
    }
    
    public override func autolayout() {
        animationView.snp.makeConstraints { make in
            make.width.height.equalTo(180)
            make.top.equalToSuperview().inset(150)
            make.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(animationView.snp.bottom).inset(-16)
        }
        
        acceptButton.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview().inset(16)
        }
    }
    
    public override func setupObservers() {
        acceptButton.clicked { [weak self] in
            guard let self = self else { return }
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
}
