//
//  OnboardingViewController.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 10/05/23.
//

import UIKit
import OlchaUI

public class OnboardingViewController: BaseViewController<OnboardingNavigationBar> {
    
    public lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero,
                                          collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.registerClass(forCell: OnboardingImageRoom.self)
        collection.isPagingEnabled = true
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .olchaTextBlack
        label.style(.semibold, 18)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = ""
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .olchaTextBlack
        label.style(.regular, 14)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = ""
        return label
    }()
    
    private let nextButton: IButton = {
        let button = IButton()
        button.backgroundColor = .olchaLightNeutralGray
        button.round()
        button.titleLabel?.style(.semibold, 18)
        button.setTitleColor(.olchaTextBlack, for: .normal)
        return button
    }()
    
    public let leftButton: IconButton = {
        let button = IconButton()
        button.setIcon(.left_anchor?.withColor(.olchaLightTextColornnnnnn ?? .gray), isIgnoringEdge: true)
        return button
    }()
    
    public let rightButton: IconButton = {
        let button = IconButton()
        button.setIcon(.rightIcon?.withColor(.olchaLightTextColornnnnnn ?? .gray), isIgnoringEdge: true)
        return button
    }()
    
    private let pageControlContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.2)
        return view
    }()
    
    public let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .olchaPrimaryColor
        pageControl.pageIndicatorTintColor = .olchaGray
        pageControl.numberOfPages = 5
        return pageControl
    }()
    
    private let nextButtton: OlchaButton = {
        let button = OlchaButton()
        button.isHidden = true
        return button
    }()
    
    public var currentPage: Int = 0 {
        didSet {
            languageUpdated()
            
            leftButton.isHidden = OnboardingConfigurator.isLeftButtonHidden || (currentPage == 0)
            rightButton.isHidden = OnboardingConfigurator.isRightButtonHidden || isLastPage
            nextButton.isHidden = isLastPage
            nextButtton.isHidden = !isLastPage
            
            pageControl.currentPage = currentPage
        }
    }
    
    public let pages = OnboardingConfigurator.pages
    
    public var isLastPage: Bool {
        currentPage == (pages-1)
    }
    
    public var completion: (() -> Void)?
    
    public var coordinator: CommonCoordinatorProtocol?
    
    public override func setupViews() {
        container.addSubview(collection)
        container.addSubview(logoImageView)
        container.addSubview(titleLabel)
        container.addSubview(subtitleLabel)
        container.addSubview(nextButton)
        
        container.addSubview(leftButton)
        container.addSubview(rightButton)
        
        container.addSubview(pageControlContainer)
        pageControlContainer.addSubview(pageControl)
        container.addSubview(nextButtton)
    }
    
    public override func configureViews() {
        subtitleLabel.isHidden = OnboardingConfigurator.isSubtitleHidden
        leftButton.isHidden = OnboardingConfigurator.isLeftButtonHidden
        rightButton.isHidden = OnboardingConfigurator.isRightButtonHidden
        logoImageView.isHidden = OnboardingConfigurator.isLogoHidden
        languageUpdated()
    }
    
    public override func languageUpdated() {
        nextButton.setTitle("next".localized(), for: .normal)
        nextButtton.setTitle("continue".localized())
        titleLabel.text = OnboardingConfigurator.title(index: currentPage)
        subtitleLabel.text = OnboardingConfigurator.subtitle(index: currentPage)
        logoImageView.image = OnboardingConfigurator.logoImage(index: currentPage)
        collection.reloadData()
        navigationBar.languageUpdated()
    }
    
    public override func autolayout() {
        collection.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.6)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(collection.snp.top)
            make.height.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(collection.snp.bottom).inset(-16)
            make.left.right.equalToSuperview().inset(32)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-8)
            make.left.right.equalToSuperview().inset(60)
        }
        
        nextButton.snp.makeConstraints { make in
            make.bottom.right.equalToSuperview().inset(16)
            make.width.equalTo(150)
            make.height.equalTo(48)
        }
        
        leftButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.centerY.equalTo(collection.snp.centerY)
            make.width.height.equalTo(24)
        }
        
        rightButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.centerY.equalTo(collection.snp.centerY)
            make.width.height.equalTo(24)
        }
        
        pageControlContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(collection.snp.bottom)
        }
        
        pageControl.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(10)
            make.left.right.equalToSuperview()
        }
        
        nextButtton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(48)
            make.bottom.equalTo(nextButton.snp.bottom)
        }
    }
    
    public override func setupObservers() {
        navigationBar.languageButtonObserver { [weak self] in
            guard let self else { return }
            coordinator?.presentLanguageOnboarding()
        }
        
        rightButton.clicked { [weak self] in
            guard let self = self else { return }
            currentPage = min(pages - 1 , currentPage + 1)
            pageUpdated(forced: true)
        }
        
        leftButton.clicked { [weak self] in
            guard let self = self else { return }
            currentPage = max(0, currentPage - 1)
            pageUpdated(forced: true)
        }
        
        nextButton.clicked { [weak self] in
            guard let self = self else { return }
            currentPage = min(pages - 1 , currentPage + 1)
            pageUpdated(forced: true)
        }
        
        navigationBar.skipButton.settings.clicked { [weak self] in
            guard let self = self else { return }
            finishOnboarding()
        }
        
        nextButtton.clicked { [weak self] in
            guard let self = self else { return }
            finishOnboarding()
        }
    }
    
    public override func initialRequest() {
        currentPage = 0
        pageUpdated(forced: false)
    }
    
    private func finishOnboarding() {
        CommonGlobalDefaults.session.isEntered = true
        completion?()
    }
}
