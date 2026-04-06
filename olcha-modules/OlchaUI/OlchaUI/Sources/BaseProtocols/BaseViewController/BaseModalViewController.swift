//
//  BaseModalViewController.swift
//  OlchaUI
//
//  Created by Elbek Khasanov on 04/02/23.
//

import UIKit
import OlchaResources
import Combine
import IQKeyboardManagerSwift
import ProgressHUD
open class BaseModalViewController: DefaultViewController, ModalPageType {
    
    open var fullBackgroundColor: UIColor? = .olchaWhite {
        didSet {
            container.backgroundColor = fullBackgroundColor
            modalMainContainer.backgroundColor = fullBackgroundColor
            dismissTrackerContainer.backgroundColor = fullBackgroundColor
            bottomEdgeColor = fullBackgroundColor
        }
    }
    open var bottomEdgeColor: UIColor? = .olchaWhite {
        didSet {
            bottomEdgeContainer.backgroundColor = bottomEdgeColor
        }
    }
    public var bag = Set<AnyCancellable>()
    
    public let modalMainContainer = UIView()
    public let modalHeaderTitle = UILabel()
    public let dismissTrackerContainer = UIView()
    private let dismissTracker = UIView()
    private let dismissContainer = UIButton()
    public let bottomEdgeContainer = UIView()
    public lazy var xButton: IconButton = {
        let button = IconButton()
        button.setIcon(.x, isIgnoringEdge: true)
        button.clicked { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
        }
        return button
    }()
    
    public let container = IQPreviousNextView()//IQPreviousNextView
    private let headerHeight: CGFloat = 30
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func baseSetupViews() {
        view.addSubview(dismissContainer)
        view.addSubview(modalMainContainer)
        modalMainContainer.addSubview(container)
        modalMainContainer.addSubview(dismissTrackerContainer)
        modalMainContainer.addSubview(modalHeaderTitle)
        modalMainContainer.addSubview(xButton)
        view.addSubview(bottomEdgeContainer)
        dismissTrackerContainer.addSubview(dismissTracker)
    }
    
    override func baseAutolayout() {
        dismissContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        container.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(UIApplication.shared.bottomInset)
        }
        
        bottomEdgeContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(container.snp.bottom)
            make.bottom.equalToSuperview()
        }
        
        dismissTrackerContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(30)
        }
        
        dismissTracker.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.height.equalTo(4)
            make.width.equalTo(40)
        }
        
        modalHeaderTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.right.equalTo(xButton.snp.left).inset(-8)
            make.top.equalTo(dismissTrackerContainer.snp.bottom)
//            make.height.equalTo(50)
            make.bottom.equalTo(container.snp.top)
        }
    
        modalMainContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            
            make.top.greaterThanOrEqualToSuperview().inset(100)
        }
        
        xButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.width.height.equalTo(24)
            make.centerY.equalTo(modalHeaderTitle.snp.centerY)
            make.bottom.lessThanOrEqualTo(container.snp.top)
        }
    }
    
    override func baseConfigureViews() {
        super.baseConfigureViews()
        modalHeaderTitle.backgroundColor = .clear
        dismissContainer.backgroundColor = .clear
        modalMainContainer.backgroundColor = .olchaWhite
        
        view.backgroundColor = .clear
        
        dismissContainer.setTitle("", for: .normal)
        dismissContainer.addTarget(self, action: #selector(dismiss(_:)), for: .touchUpInside)
        
        container.backgroundColor = .olchaBackgroundColor
        modalMainContainer.backgroundColor = .olchaBackgroundColor
        dismissTrackerContainer.backgroundColor = .olchaBackgroundColor
        
        dismissTracker.backgroundColor = .olchaLightNeutralGray
        dismissTracker.round(2)
        

        dismissTrackerContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        dismissTrackerContainer.round()
        
        modalMainContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        modalMainContainer.round()
        
        modalHeaderTitle.style(.bold, 18)
        modalHeaderTitle.textColor = .olchaTextBlack
        ProgressHUD.animationType = .circleStrokeSpin
        modalHeaderTitle.setContentHuggingPriority(.required, for: .vertical)
//        modalHeaderTitle.setContentCompressionResistancePriority(.defaultLow, for: .ver)
        
        dismissConfiguration()
    }
    
    @objc func dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    public func setContainerHeight(_ height: CGFloat = UIScreen.main.bounds.height) {
        let maxHeight = self.view.frame.height - 150

        modalMainContainer.snp.remakeConstraints { make in
            make.top.greaterThanOrEqualToSuperview().inset(100)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(min(maxHeight, height))
        }
        
    }
    
    public func setHeader(title: String, textAlignment: NSTextAlignment = .left) {
        modalHeaderTitle.text = title
        modalHeaderTitle.textAlignment = .left
    }
    
    
}
