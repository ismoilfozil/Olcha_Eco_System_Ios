//
//  AdultImage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 18/11/22.
//


import UIKit
import Combine

class AdultCheckViewModel {
    static let shared = AdultCheckViewModel()
    let isAdult = PassthroughSubject<Bool, Never>()
}

class AdultChecker: UIView {
    private var bag = Set<AnyCancellable>()
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
    private let contentStack = UIStackView()
    private let eyeIcon = UIImageView()
    private let titleLabel = UILabel()
    private let showButton = Button()
    
    private var product: ProductModel?
    
    var withTitle: Bool {
        didSet {
            titleLabel.isHidden = !withTitle
        }
    }
    
    
    init(frame: CGRect = .zero, withTitle: Bool = true) {
        self.withTitle = withTitle
        super.init(frame: frame)
        baseSetup()
        
    }
    
    required init?(coder: NSCoder) {
        self.withTitle = true
        super.init(coder: coder)
        baseSetup()
    }
    
    private func baseSetup() {
        setupViews()
        autolayout()
        configureViews()
    }
    
    private func setupViews() {
        addSubview(blurView)
        addSubview(contentStack)
        contentStack.addArrangedSubview(eyeIcon)
        contentStack.addArrangedSubview(titleLabel)
        addSubview(showButton)
    }
    
    private func autolayout() {
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentStack.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(8)
        }
        
        eyeIcon.snp.makeConstraints { make in
            make.width.height.equalTo(20)
        }
        
        
        showButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureViews() {
        
        contentStack.axis = .vertical
        contentStack.spacing = 4
        contentStack.alignment = .center
        eyeIcon.image = .hiddenEye
        
        titleLabel.style(.medium, 12)
        titleLabel.textAlignment = .center
        titleLabel.text = "adult_product".localized()
        titleLabel.numberOfLines = 0
        
        showButton.clicked { [weak self] in
            guard let self = self else { return }
            self.showAlert()
        }
        
        checkState()
        
        AdultCheckViewModel
            .shared
            .isAdult
            .sink { [weak self] isAdult in
                guard let self = self else { return }
                OlchaGlobalDefaults.user.isAdult = isAdult
                self.checkState()
            }.store(in: &bag)
    }
    
    private func showAlert() {
        
        let navigationController = UIApplication.shared.rootNavigationController
        
        navigationController?.topViewController?.showAdult(agreeClicked: {
            AdultCheckViewModel.shared.isAdult.send(true)
        })

    }
    
    private func checkState() {
        let forAdult = (product?.for_adults ?? 0) == 1
        
        let isAdult = OlchaGlobalDefaults.user.isAdult ?? false
        
        if (isAdult == false) && (forAdult == true) {
            self.isHidden = false
            self.isUserInteractionEnabled = true
        } else {
            self.isHidden = true
            self.isUserInteractionEnabled = false
        }
        
    }
    
    func check(_ product: ProductModel?) {
        self.product = product
        checkState()
    }
    

}

