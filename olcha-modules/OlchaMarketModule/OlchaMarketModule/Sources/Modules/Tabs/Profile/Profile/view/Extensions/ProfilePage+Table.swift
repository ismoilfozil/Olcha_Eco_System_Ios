//
//  ProfilePage+Table.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 06/09/22.
//
import OlchaAuth
import OlchaUI
import OlchaUI
import UIKit
import OlchaUtils
import OlchaVerification
extension ProfilePage: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        actualSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard actualSections.isGreater(indexPath.section) else { return .init() }
        let section = actualSections[indexPath.section]
        
        if isSeparator(at: indexPath) {
            let cell = tableView.dequeue(FooterItem.self, for: indexPath)
            
            if section == .user || section == .balans || section == .referal {
                cell.responder.withSeparator = false
            } else {
                cell.responder.withSeparator = true
            }
            cell.responder.withEdge = true
            return cell
        }
        
        switch section {
        case .login:
            let cell = tableView.dequeue(EnterLoginRoom.self, for: indexPath)
            cell.setup()
            cell.enterButton.settings.clicked { [weak self] in
                guard let self = self else { return }
                self.coordinator?.pushAuth {} 
            }
            return cell
        case .user:
            let cell = tableView.dequeue(UserRoom.self, for: indexPath)
            cell.configure(skeleton: input.userSkeleton)
            if input.userSkeleton.isAnimating {
                cell.prepareForReuse()
            } else {
                cell.setup(
                    with: input.user?.getFullname() ?? " - ",
                    isVerified: input.isVerified,
                    status: input.verification?.status
                )
                cell.progressView.progress = input.verification?.percentage ?? 0
            }
            return cell
        case .balans:
            let cell = tableView.dequeue(OlchaBalanceRoom.self, for: indexPath)
            cell.skeleton = input.cardSkeleton
            cell.pushFillBalance = pushFillBalance
            cell.setup(with: input.balance, user: input.user, bonus: input.bonus)
            
            switch selectItem {
            case .balance:
                cell.scroll(to: OlchaBalanceItem.self)
            case .bonus:
                cell.scroll(to: OlchaBonusItem.self)
            }
            
            return cell
        case .referal:
            let cell = tableView.dequeue(ReferalRoom.self, for: indexPath)
            cell.setup(with: input.user?.id)
            cell.copyButton.clicked { [weak self] in
                guard let self = self else { return }
                let referal = Funcs.getReferalLink(id: input.user?.id)
                UIPasteboard.general.string = referal
                self.presentShareScreen(text: referal)
            }
            return cell
        case .favourites:
            let cell = tableView.dequeue(ProfileMenuRoom.self, for: indexPath)
            cell.setup(image: section.image, title: section.title)
            cell.menuTitle.textColor = .olchaTextBlack
            cell.setup(badge: CartViewModel.shared.favouritesCount)
            return cell
        default:
            let cell = tableView.dequeue(ProfileMenuRoom.self, for: indexPath)
            cell.setup(image: section.image, title: section.title)
            cell.menuTitle.textColor = (section == .logout || section == .delete) ? .olchaAccentColor : .olchaTextBlack
            cell.setup()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard actualSections.isGreater(indexPath.section) else { return UITableView.automaticDimension }
        let section = actualSections[indexPath.section]
        if isSeparator(at: indexPath) {
            return section.footer
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard actualSections.isGreater(indexPath.section) else { return }
        let section = actualSections[indexPath.section]
        guard !isSeparator(at: indexPath) else { return }
        switch section {
        case .olchaPay:
            ModuleGeneratorHelper.shared.generate(module: .pay, appStarted: nil)
        case .nasiya:
            ModuleGeneratorHelper.shared.generate(module: .nasiya, appStarted: nil)
        case .olchaInvest:
            ModuleGeneratorHelper.shared.generate(module: .invest, appStarted: nil)
        case .user:
            coordinator?.pushProfileDataPage(user: input.user)
        case .ramazan:
            coordinator?.pushRamazanTaqvim()
        case .personalData:
            if let verificationData = input.verification {
                let currentStep = verificationData.getStep()
                let verificationStep: VerificationStatusStep
                
                switch currentStep {
                case 0, 1:
                    verificationStep = .identification
                case 2:
                    verificationStep = .phones
                case 3:
                    verificationStep = .bankCard
                default:
                    verificationStep = .identification
                }
                
                coordinator?.pushVerification(step: verificationStep)
            } else {
                coordinator?.pushVerificationPage1()
            }
        case .oneIdGuide:
            coordinator?.pushOneIdGuide()
        case .myOrders:
            coordinator?.pushMyOrdersPage()
        case .returnOrder:
            coordinator?.pushReturnOrder()
        case .location:
            coordinator?.pushLocationsList()
        case .favourites:
            coordinator?.pushFavourites(animated: true)
        case .compare:
            coordinator?.pushCompare(product: nil)
        case .searchOrder:
            coordinator?.pushSearchOrderPage()
        case .myReviews:
            coordinator?.pushMyReviews(type: .review)
        case .myQuestions:
            coordinator?.pushMyReviews(type: .question)
        case .notifications:
            coordinator?.pushNotifications()
        case .settings:
            coordinator?.pushSettingsPage()
            table.reloadData()
        case .logout:
            showLogout { [weak self] in
                guard let self = self else { return }
                self.tabBarController?.selectedIndex = OlchaTab.home
                OlchaApplicationConfigurator.shared.appCoordinator?.logout()
            }
        case .delete:
            print("calc", AuthGlobalDefaults.notification.fcm_token)
            UIPasteboard.general.string = AuthGlobalDefaults.notification.fcm_token
            showDeleteAccount { [weak self] in
                guard let self = self else { return }
                self.viewModel.loadUserData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.showWarning(text: "delete_success_message".localized())
                }
            }
        default: break
        }
        
    }
    
    private func isSeparator(at indexPath: IndexPath) -> Bool {
        (indexPath.item == 1)
    }

}
