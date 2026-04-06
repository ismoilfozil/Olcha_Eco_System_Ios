import UIKit
import OlchaUI
import OlchaUtils
import OlchaCommon
import SkeletonView

extension EcoHomeViewController {
    public enum EcoAppService: Int, RowProtocol {
        case market
        case sayohat
        case nasiya
        case invest
        case pay
        case cashback
        case tv
        case food
        case myId
        case bus
        
        public var image: UIImage? {
            switch self {
            case .market: return .marketAppIcon
            case .sayohat: return .sayohatAppIcon
            case .nasiya: return .nasiyaAppIcon
            case .invest: return .investAppIcon
            case .pay: return .payAppIcon
            case .cashback: return .cashBackappIcon
            case .tv: return .tvAppIcon
            case .food: return .foodAppIcon
            case .myId: return .myidAppIcon
            case .bus: return .busAppIcon
            }
        }
        
        public var title: String {
            switch self {
            case .market: return "home_module_market".localized(.olchaEcoSystemCore)
            case .sayohat: return "home_module_sayohat".localized(.olchaEcoSystemCore)
            case .nasiya: return "home_module_nasiya".localized(.olchaEcoSystemCore)
            case .invest: return "home_module_invest".localized(.olchaEcoSystemCore)
            case .pay: return "home_module_pay".localized(.olchaEcoSystemCore)
            case .cashback: return "home_module_cashback".localized(.olchaEcoSystemCore)
            case .tv: return "home_module_tv".localized(.olchaEcoSystemCore)
            case .food: return "home_module_food".localized(.olchaEcoSystemCore)
            case .myId: return "home_module_myId".localized(.olchaEcoSystemCore)
            case .bus: return "home_module_bus".localized(.olchaEcoSystemCore)
            }
        }
        
        public var isEnabled: Bool {
            switch self {
            case .market, .nasiya, .invest, .pay:
                return true
            default:
                return false
            }
        }
    }
}

extension EcoHomeViewController: TableDelegates {
    public var noBuilderSections: [Section] {
        [.search, .apps, /*.nasiyaLimit,*/ .balance, .banner]
    }
    
    public var noBuilderSectionsCount: Int {
        noBuilderSections.count
    }
    
    public var sections: [Section] {
        var sections: [Section] = noBuilderSections
        
        input.builders.forEach { builder in
            switch builder.module {
            case .invest: sections.append(.invest)
            case .market: sections.append(.market)
            case .nasiya: sections.append(.nasiya)
            case .pay: sections.append(.pay)
            case .sayohat: sections.append(.sayohat)
            }
        }
        
        return sections
    }
    
    public enum Section {
        case search, apps, /*nasiyaLimit,*/ balance, banner
        case market, nasiya, sayohat, invest, pay
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard sections.isGreater(indexPath.section) else { return UITableViewCell() }
        switch sections[indexPath.section] {
        case .search:
            let cell = tableView.dequeue(EcoHomeSearchTableCell.self, for: indexPath)
            cell.setup()
            return cell
        case .apps:
            let cell = tableView.dequeue(EcoHomeAppTableCell.self, for: indexPath)
            cell.appServiceSubject = output.observers.appServiceSubject
            return cell
//        case .nasiyaLimit:
//            let cell = tableView.dequeue(EcoHomeNasiyaLimitTableCell.self, for: indexPath)
//            cell.setup()
//            cell.setup(with: input.nasiyaLimit)
//            cell.configure(skeleton: input.nasiyaLimitSkeleton)
//            return cell
        case .balance:
            let cell = tableView.dequeue(EcoHomeBalanceTableCell.self, for: indexPath)
            cell.setup(payBalance: input.payBalance)
            cell.setup(balance: input.balance)
            cell.setup(bonus: input.bonusBalance)
            cell.olchaPayItemClicked {
                ModuleGeneratorHelper.shared.generate(module: .pay, appStarted: nil)
            }
            cell.olchaTotalBalance { [weak self] in
                guard let self else { return }
                output.observers.clickActionSubject.send(MarketClickAction.profileBalance)
            }
            cell.olchaBonusBalance { [weak self] in
                guard let self else { return }
                showInvalidSnackbar(container)
            }
            cell.configure(skeleton: input.balanceSkeleton)
            return cell
        case .banner:
            let cell = tableView.dequeue(EcoHomeBannerTableCell.self, for: indexPath)
            cell.bannerSkeleton = input.bannerSkeleton
            cell.setup(with: input.banners)
            cell.observers = output.observers
            return cell
        case .market:
            let cell = tableView.dequeue(EcoHomeMarketTableCell.self, for: indexPath)
            cell.setup()
            cell.setup(with: input.builders[indexPath.section - noBuilderSectionsCount])
            cell.observers = output.observers
            return cell
        case .nasiya:
            let cell = tableView.dequeue(EcoHomeNasiyaTableCell.self, for: indexPath)
            cell.setup()
            cell.setup(with: input.builders[indexPath.section - noBuilderSectionsCount])
            cell.observers = output.observers
            return cell
        case .sayohat:
            let cell = tableView.dequeue(EcoHomeSayohatTableCell.self, for: indexPath)
            cell.setup()
            cell.setup(with: input.builders[indexPath.section - noBuilderSectionsCount])
            return cell
        case .invest:
            let cell = tableView.dequeue(EcoHomeInvestTableCell.self, for: indexPath)
            cell.setup()
            cell.setup(with: input.builders[indexPath.section - noBuilderSectionsCount])
            cell.observers = output.observers
            return cell
        case .pay:
            let cell = tableView.dequeue(EcoHomePayTableCell.self, for: indexPath)
            cell.setup()
            cell.setup(with: input.builders[indexPath.section - noBuilderSectionsCount])
            cell.observers = output.observers
            return cell
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sections[indexPath.section] {
        case .search:
            coordinator?.pushSearchViewController()
//        case .nasiyaLimit:
//            coordinator?.clickActionRouter(action: NasiyaClickAction.limitCard)
        default: break
        }
    }
}

extension EcoHomeViewController: SkeletonTableViewDataSource {
    public func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        switch sections[indexPath.section] {
        case .search:
            return EcoHomeSearchTableCell.classIdentifier
        case .apps:
            return EcoHomeAppTableCell.classIdentifier
//        case .nasiyaLimit:
//            return EcoHomeNasiyaLimitTableCell.classIdentifier
        case .balance:
            return EcoHomeBalanceTableCell.classIdentifier
        case .banner:
            return EcoHomeBannerTableCell.classIdentifier
        case .market:
            return EcoHomeMarketTableCell.classIdentifier
        case .nasiya:
            return EcoHomeNasiyaTableCell.classIdentifier
        case .sayohat:
            return EcoHomeSayohatTableCell.classIdentifier
        case .invest:
            return EcoHomeInvestTableCell.classIdentifier
        case .pay:
            return EcoHomePayTableCell.classIdentifier
        }
    }
}
