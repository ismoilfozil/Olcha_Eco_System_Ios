//
//  SideMenuViewController.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 17/06/23.
//

import UIKit
import OlchaUI
import OlchaAuth
public class SideMenuViewController: BaseViewController<EmptyNavigationBar> {
    
    weak var coordinator: NasiyaMenuCoordinatorProtocol?
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let headerContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .profile_person
        return imageView
    }()
    
    private let phoneLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 18)
        label.textColor = .olchaTextBlack
        label.numberOfLines = 0
        label.text = " - "
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.style(.regular, 14)
        label.textColor = .olchaTextBlack
        label.numberOfLines = 0
        return label
    }()
    
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()
    
    var menuItems: [SideMenuItem] = []
    let menuTypes: [SideMenuType] = [
        .divide,
        .faq,
        .connection,
        .divide,
        .logout

    ]
    
    private var tooltips: [SideMenuViewControllerTooltip] {
        let faqView = containerStackView.arrangedSubviews[1]
        let supportView = containerStackView.arrangedSubviews[2]
        return [.faq(in: faqView), .support(in: supportView)]
    }
    
    private let tooltipManager = TooltipManager()
    
    let viewModel: ProfileViewModel
    
    public init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.backgroundColor = .black.withAlphaComponent(0.4)
        tooltipManager.didViewAppear = true
        guard let topView = view else { return }
        tooltipManager.setup(tooltips: tooltips, darkView: topView)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.backgroundColor = .clear
        tooltipManager.destroy()
    }
    
    public override func setupViews() {
        view.addSubview(backgroundView)
        backgroundView.addSubview(headerContainer)
        headerContainer.addSubview(profileImageView)
        headerContainer.addSubview(phoneLabel)
        headerContainer.addSubview(nameLabel)
        backgroundView.addSubview(containerStackView)
    }
    
    public override func autolayout() {
        backgroundView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.8)
            make.left.top.bottom.equalToSuperview()
        }
        headerContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(56)
            make.bottom.top.left.equalToSuperview()
        }
        
        phoneLabel.snp.makeConstraints { make in
            make.left.equalTo(profileImageView.snp.right).inset(-12)
            make.top.equalTo(profileImageView.snp.top)
            make.right.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(phoneLabel.snp.left)
            make.right.equalTo(phoneLabel.snp.right)
            make.bottom.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    public override func configureViews() {
        view.backgroundColor = .clear
        ignoreNavigationBar = true
        languageUpdated()
    }
    
    public override func setupObservers() {
        
        handle(viewModel.$user, success: { [weak self] data in
            guard let self = self else { return }
            phoneLabel.text = data?.phone?.formatFullPhoneNumber
        })
        
    }
    
    public override func initialRequest() {
        viewModel.loadUserData()
    }
    
    
    public override func languageUpdated() {
        nameLabel.text = "personal_datas".localized()
        createItems()
    }
    
    public func createItems() {
        containerStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        menuItems.removeAll()
        for type in menuTypes {
            if type == .divide {
                let divide = Divide()
                containerStackView.addArrangedSubview(divide)
                divide.snp.makeConstraints { $0.left.right.equalToSuperview() }
            } else {
                
                let item = createItem(type: type)
                containerStackView.addArrangedSubview(item)
                menuItems.append(item)
                item.snp.makeConstraints {
                    $0.left.right.equalToSuperview()
                    $0.height.equalTo(56)
                }
                
            }
        }
    }
    
    private func createItem(type: SideMenuType) -> SideMenuItem {
        let item = SideMenuItem()
        
        item.setup(image: type.icon, title: type.title)
        item.setup(color: type.color)
        item.MENU_TAG = type.rawValue
        
        item.button.clicked { [weak self] in
            guard let self = self else { return }
            buttonObserver(type: type)
        }
        
        return item
    }
    
    private func buttonObserver(type: SideMenuType) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            switch type {
            case .faq:
                coordinator?.pushFAQs()
                break
            case .connection:
                coordinator?.pushConnection()
                break
            case .logout:
                coordinator?.logout()
                break
            default:
                break
            }
        }
        
    }
}
