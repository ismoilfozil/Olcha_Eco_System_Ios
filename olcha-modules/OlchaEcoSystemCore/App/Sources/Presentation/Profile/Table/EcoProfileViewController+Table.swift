import UIKit
import OlchaUI
import OlchaUtils

extension EcoProfileViewController: TableDelegates {
  
    public func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].rows.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case .login:
            let cell = tableView.dequeue(EcoProfileLoginTableCell.self, for: indexPath)
            cell.setup()
            cell.enterButton.settings.clicked { [weak self] in
                guard let self = self else { return }
                coordinator?.pushAuth {
                    AuthNotificationManager.shared.postNotification()
                    tableView.reloadData()
                }
            }
            return cell
        default:
            let cell = tableView.dequeue(EcoProfileTableCell.self, for: indexPath)
            let cellData = sections[indexPath.section].rows[indexPath.row]
            cell.setup(with: cellData, isDelete: (cellData as? MainRow) == MainRow.delete)
            let leftInset: CGFloat = cellData.image == nil ? 12 : 48
            cell.separatorInset = UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: 12)
            return cell
        }
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let title = sections[section].title else { return nil }
        let view = EcoProfileSectionHeader()
        view.setup(with: title)
        return view
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].title
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        sections[section].title == nil ? 0 : 36
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = sections[indexPath.section].rows[indexPath.row]
        switch sections[indexPath.section] {
        case .login: break
        case .application:
            guard let row = row as? ApplicationRow else { return }
            switch row {
            case .about:
                coordinator?.pushAbout()
            case .settings:
                coordinator?.pushSettings()
            case .support:
                openURL(Texts.urls.olcha_telegram)
            }
        case .orders:
            guard let row = row as? OrderRow else { return }
            switch row {
            case .favorites:
                coordinator?.clickActionRouter(action: MarketClickAction.favorites)
            case .myOrders:
                coordinator?.clickActionRouter(action: MarketClickAction.orders)
            case .refundAndExchange:
                coordinator?.clickActionRouter(action: MarketClickAction.orderReturn)
            case .ticketsAndTours: 
                showInvalidSnackbar(container)
            }
        case .products:
            guard let row = row as? ProductRow else { return }
            switch row {
            case .comments:
                coordinator?.clickActionRouter(action: MarketClickAction.comments)
            case .compare:
                coordinator?.clickActionRouter(action: MarketClickAction.compare)
            case .myQuestionsAndAnswers:
                coordinator?.clickActionRouter(action: MarketClickAction.questions)
            }
        case .information:
            guard let row = row as? InformationRow else { return }
            switch row {
            case .addresses:
                coordinator?.clickActionRouter(action: MarketClickAction.addresses)
            case .bonusProgram:
                showInvalidSnackbar(container)
            case .installmentData:
                coordinator?.clickActionRouter(action: NasiyaClickAction.profile)
            case .myCards:
                coordinator?.clickActionRouter(action: PayClickAction.cards)
            case .notifications:
                coordinator?.pushNotification()
            case .security:
                coordinator?.pushSafety()
            }
        case .main:
            guard let row = row as? MainRow else { return }
            switch row {
            case .about:
                coordinator?.pushAbout()
            case .help:
                openURL(Texts.urls.olcha_telegram)
            case .settings:
                coordinator?.pushSettings()
            case .logout:
                showLogout { [weak self] in
                    guard let self else { return }
                    logout()
                }
            case .delete:
                showDeleteAccount { [weak self] in
                    guard let self = self else { return }
                    self.profileViewModel.loadUserData()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.showWarning(text: "delete_success_message".localized())
                    }
                }
            }
        }
    }
}
