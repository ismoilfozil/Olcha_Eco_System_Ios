//
//  SettingsViewController.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 23/05/23.
//

import UIKit
import OlchaUI
import OlchaUtils
import OlchaVerification

public class SettingsViewController: BaseViewController<BackNavigationBar> {

    private lazy var table: BaseTableView = {
        let table = BaseTableView()
        table.delegate = self
        table.dataSource = self
        table.configure()
        table.registerClass(forCell: SettingsLanguageRoom.self)
        table.registerClass(forCell: SafetyTitleRoom.self)
        table.registerClass(forCell: SettingsPushRoom.self)
        return table
    }()
    
    private let networkingTitle: UILabel = {
        let label = UILabel()
        label.style(.semibold, 16)
        label.textAlignment = .center
        label.textColor = .olchaTextBlack
        return label
    }()
    
    private let networkingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        return stackView
    }()
    
    public let sections: [Section] = [
        .language,
        .push,
        .offerta,
        .about,
        .clearTooltipCache
    ]
    
    public let networks: [Network] = [
        .facebook,
        .instagram,
        .telegram
    ]
    
    weak var coordinator: ProfileCoordinatorProtocol?
    
    public override func setupViews() {
        container.addSubview(table)
        container.addSubview(networkingStackView)
    }
    
    public override func autolayout() {
        table.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        networkingStackView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(18)
            make.centerX.equalToSuperview()
        }
        createButtons()
    }
    
    public override func configureViews() {
        languageUpdated()
    }
    
    public override func languageUpdated() {
        navigationBar.setTitle("settings".localized())
        networkingTitle.text = "subscribe_us".localized(.olchaNasiyaModule)
        table.reloadData()
    }
    
    public func createButtons() {
        for network in networks {
            let button = IconButton()
            button.setIcon(network.icon,
                           edgeSize: 8,
                           isIgnoringEdge: false)
            button.snp.makeConstraints { $0.width.height.equalTo(48) }
            button.backgroundColor = .olchaPrimaryColor
            button.round()
            button.addShadow(location: .bottom, opacity: 0.3)
            networkingStackView.addArrangedSubview(button)
            
            button.clicked { [weak self] in
                guard let self = self else { return }
                openURL(network.link)
            }
        }
    }
    
    public func clearTooltipCache() {
        let someView = UIView()
        
        MyInstallmentsViewControllerTooltip.filterButton(in: someView).clearCache()
        NasiyaProfileViewControllerTooltip.bankCards(in: someView).clearCache()
        MyInstallmentViewControllerTooltip.detailSegment(in: someView).clearCache()
        SideMenuViewControllerTooltip.faq(in: someView).clearCache()
        PassportsVerificationPageTooltip.passport(in: someView).clearCache()
        NasiyaHomeViewControllerTooltip.menuButton(in: someView).clearCache()
    }

}

extension SettingsViewController {
    public enum Network {
        case facebook
        case instagram
        case telegram
        
        public var icon: UIImage? {
            switch self {
            case .facebook:
                return .facebook
            case .instagram:
                return .instagram
            case .telegram:
                return .telegram
            }
        }
        
        public var link: String {
            switch self {
            case .facebook:
                return Texts.urls.facebook
            case .instagram:
                return Texts.urls.instagram
            case .telegram:
                return Texts.urls.telegram
            }
        }
    }
}
