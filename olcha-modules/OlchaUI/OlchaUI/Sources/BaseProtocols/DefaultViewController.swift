//
//  BaseViewController.swift
//  OlchaUI
//
//  Created by Elbek Khasanov on 20/01/23.
//

import UIKit

@MainActor public protocol IndicatorProtocol {
    var count: Int { get set }
}
open class DefaultViewController: UIViewController, UIScrollViewDelegate, IndicatorProtocol {
    
    ///
    /// - ``count`` for counting loaders count
    ///
    public var count: Int = 0
    
    public let refreshControl = UIRefreshControl()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        beforeBaseSetup()
        baseSetupViews()
        baseAutolayout()
        baseConfigureViews()
        
        setupViews()
        autolayout()
        configureViews()
        setupObservers()
        initialRequest()
    }
    
    @objc open func beforeBaseSetup() {}
    
    ///
    /// - ``setupViews()`` you have to `override` this funcs to set views to container
    ///
    @objc open func setupViews() {
        
    }
    ///
    /// - ``autolayout()`` you have to `override` this funcs to set autolayouts
    ///
    @objc open func autolayout() {
        
    }
    ///
    /// - ``configureViews()`` you have to `override` this funcs to configure basic configutations
    ///
    @objc open func configureViews() {
        
    }
    ///
    /// - ``setupObservers()`` you have to `override` this funcs to set observers for networking, for navigating, for actions
    ///
    @objc open func setupObservers() {
        
    }
    ///
    /// - ``initialRequest()`` you have to `override` this funcs to make requests when screen loaded
    ///
    @objc open func initialRequest() {
        
    }
    
    @objc open func setupOptionalObservers() {
        
    }
    
    @objc open func setupOptionalInitialRequests() {
        
    }
    
    @objc open func setupOptionalActions() {
        setupOptionalObservers()
        setupOptionalInitialRequests()
    }
    
    func baseSetupViews() {
        
    }
    
    func baseAutolayout() {
        
    }
    
    func baseConfigureViews() {
        refreshControl.addTarget(self, action: #selector(self.refreshList(_:)), for: .valueChanged)
        refreshControl.tintColor = .olchaAccentColor
    }
    
    @objc open func refreshList(_ sender: AnyObject) {}
    
}
