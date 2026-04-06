//
//  BaseViewController.swift
//  OlchaUI
//
//  Created by Elbek Khasanov on 20/01/23.
//

import UIKit
import OlchaResources
import Combine
import ProgressHUD
import IQKeyboardManagerSwift
import OlchaCore
import OlchaUtils
///
/// - `BaseViewController` to create all view controllers
///
/// - `Navigation` is ``protocol`` to create all viewcontroller navigation bars
///
/// - `BaseNavigationOutput` is protocol to use base ``functions``.  For exmaple `setTitle()`, `backButton` ...
///
open class BaseViewController<Navigation: UIView>: DefaultViewController, BaseNavigationOutput {
    
    public var bag = Set<AnyCancellable>()
    public let navigationBar = Navigation()
    public let container = IQPreviousNextView()
    public let navigationHeight: CGFloat = 60
    
    public let navigationSeparator: Divide = {
        let view = Divide()
        view.isHidden = true
        view.height = 0.5
        return view
    }()
    ///
    /// - ``placeholder`` is used to show when screen data is empty. You can configure its contents with adding ``placeholder.contentView``
    ///
    public let placeholder = EmptyPlaceholder()
    ///
    /// - ``ignoreNavigationBar`` is used to when you do not need navigation bar to screen
    ///
    public var ignoreNavigationBar = false {
        didSet {
            updateLayout()
        }
    }
    
    public var withNavigationSeparator = false {
        didSet {
            navigationSeparator.isHidden = !withNavigationSeparator
        }
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        MainActor.assumeIsolated {
            bag.forEach({ $0.cancel() })
        }
    }
    
    override func baseSetupViews() {
        view.addSubview(container)
        view.addSubview(placeholder)
        view.addSubview(navigationBar)
        view.addSubview(navigationSeparator)
    }
    
    override func baseAutolayout() {
        navigationBar.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(navigationHeight)
        }
        
        container.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        placeholder.snp.makeConstraints { make in
            make.edges.equalTo(container.snp.edges)
        }
        
        navigationSeparator.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(navigationBar.snp.bottom)
        }
    }
    
    private func updateLayout() {
        navigationBar.isHidden = ignoreNavigationBar
        navigationBar.snp.updateConstraints { make in
            make.height.equalTo(ignoreNavigationBar ? 0 : navigationHeight)
        }
    }
    
    override func baseConfigureViews() {
        super.baseConfigureViews()
        view.backgroundColor = .olchaBackgroundColor
        ProgressHUD.animationType = .circleStrokeSpin
        
        if let navigation = navigationBar as? BaseNavigationInput {
            navigation.delegate = self
        }
        
        LanguageObserver.shared.observer.sink { [weak self] in
            guard let self = self else { return }
            LocalizationBundle.setup()
            updateTabNames()
            languageUpdated()
        }.store(in: &bag)
        
        disablePlaceholder()
        languageUpdated()
    }
    ///
    /// - ``updateTabNames()`` for updating tab names when, its changed from settings
    ///
    open func updateTabNames() {}
    ///
    /// - ``languageUpdated()()`` for updating tab names when, its changed from settings
    ///
    open func languageUpdated() {}
    
    public func backButtonClicked() {
        if self.navigationController?.topViewController != self {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
