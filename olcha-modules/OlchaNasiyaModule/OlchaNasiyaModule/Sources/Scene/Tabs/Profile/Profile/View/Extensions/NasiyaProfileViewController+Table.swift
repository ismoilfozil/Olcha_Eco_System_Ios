//
//  NasiyaProfileViewController+Table.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 21/05/23.
//

import UIKit
import OlchaUI
import OlchaVerification
import OlchaUtils

extension NasiyaProfileViewController: TableDelegates {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard sections.isGreater(indexPath.section) else { return UITableViewCell() }
        guard !isSeparator(indexPath) else {
            let cell = tableView.dequeue(FooterItem.self, for: indexPath)
            cell.responder.height = 16
            cell.responder.withSeparator = false
            return cell
        }
        
        let section = sections[indexPath.section]
        switch section {
        case .header:
            let cell = tableView.dequeue(UserRoom.self, for: indexPath)
            cell.configure(skeleton: input.userSkeleton)
            cell.rightIcon.isHidden = true
            if input.userSkeleton.isAnimating {
                cell.prepareForReuse()
            } else {
                cell.setup(
                    with: input.user?.getFullname() ?? " - ",
                    subtitleText: "ID: \(input.user?.id ?? 0)",
                    isVerified: isVerified,
                    status: input.verification?.status
                )
                cell.progressView.progress = input.verification?.percentage ?? 0
            }
            return cell
        case .verificationStatus:
            let cell = tableView.dequeue(ProfileVerifyStatusRoom.self, for: indexPath)
            cell.setup(status: input.verification?.status)
            return cell
        case .verification:
            let cell = tableView.dequeue(ProifleVerifyRoom.self, for: indexPath)
//            cell.statusView.stepObserver = { [weak self] step in
//                guard let self = self else { return }
//                pushVerification(step: step)
//            }
            cell.container.isHidden = input.userSkeleton.isAnimating
            cell.verifyButton.clicked { [weak self] in
                guard let self = self else { return }
                coordinator?.pushVerificationFlow()
            }
            cell.setup(steps: input.verification?.getSteps(), status: input.verification?.status)
            return cell
        case .timer:
            let cell = tableView.dequeue(ProfileTimerRoom.self, for: indexPath)
            let interval = input.verification?.time_amount ?? 0
            let restTime = VerificationGlobalDefaults.settings.getRestTime(interval: interval)
            cell.timerInterval = interval.int
            cell.setup()
            cell.setElapsedTime(restTime)
            cell.stopObserver = { [weak self] in
                guard let self else { return }
                guard VerificationGlobalDefaults.settings.getRestTime(interval: interval) <= 0 else {
                    return
                }
                OlchaVerificationDIContainer.shared.authCreditViewModel().verifyCredit()
                verificationViewModel.loadStep()
            }
            cell.refreshObserver = { [weak self] in
                guard let self else { return }
                OlchaVerificationDIContainer.shared.authCreditViewModel().verifyCredit()
                verificationViewModel.loadStep()
                tableView.reloadData()
            }
            return cell
        default:
            let cell = tableView.dequeue(ProfileMenuRoom.self, for: indexPath)
            cell.setup(image: section.image, title: section.title)
            return cell
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard sections.isGreater(indexPath.section) else { return }
        tableView.deselectRow(at: indexPath, animated: false)
        switch sections[indexPath.section] {
            
        case .header:
            coordinator?.pushProfileData()
        case .phoneNumbers:
            coordinator?.pushPhones()
        case .bankCards:
            coordinator?.pushBankCards()
        case .passport:
            coordinator?.pushPassportData()
        case .pincode:
            coordinator?.pushSafety()
        case .olcha:
            ModuleGeneratorHelper.shared.generateParent()
        case .ecoSystem:
            ModuleGeneratorHelper.shared.generateParent()
        default:
            break
        }
    }
    
    private func isSeparator(_ indexPath: IndexPath) -> Bool {
        switch sections[indexPath.section] {
        default:
            return indexPath.row == 1
        }
    }
    
    private func pushVerification(step: VerificationStatusStep) {
        switch step {
        case .identification:
            coordinator?.pushPassportData()
        case .phones:
            coordinator?.pushPhones()
        case .bankCard:
            coordinator?.pushBankCards()
        }
    }
}

extension NasiyaProfileViewController {
    public enum Section {
        case header
        case verificationStatus
        case verification
        case timer
        case phoneNumbers
        case bankCards
        case passport
        case pincode
        case olcha
        case ecoSystem
        
        var title: String {
            switch self {
            case .phoneNumbers:
                return "phone_numbers".localized(.olchaNasiyaModule)
            case .bankCards:
                return "attached_cards".localized()
            case .passport:
                return "passport_data".localized(.olchaNasiyaModule)
            case .pincode:
                return "safety".localized()
            case .olcha:
                return "Olcha"
            case .ecoSystem:
                return "Olcha EcoSystem"
            default:
                return ""
            }
        }
        
        var image: UIImage? {
            switch self {
            case .phoneNumbers:
                return .user
            case .bankCards:
                return .cards
            case .passport:
                return .passport_data
            case .pincode:
                return .lock
            case .olcha:
                return .olcha_market
            case .ecoSystem:
                return .olchaIcon
            default:
                return nil
            }
        }
    }
}
