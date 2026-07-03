//
//  NasiyaProfileViewController.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 21/05/23.
//

import UIKit
import Combine
import OlchaUI
import OlchaAuth
import OlchaVerification
import OlchaUtils

public class NasiyaProfileViewController: BaseViewController<NasiyaNavigationBar> {

    private lazy var table: BaseTableView = {
        let table = BaseTableView()
        table.delegate = self
        table.dataSource = self
        table.configure()
        table.registerClass(forCell: ProfileMenuRoom.self)
        table.registerClass(forCell: UserRoom.self)
        table.registerClass(forCell: ProifleVerifyRoom.self)
        table.registerClass(forCell: ProfileVerifyStatusRoom.self)
        table.registerClass(forCell: ProfileTimerRoom.self)
        return table
    }()
    
    private var verifiedSections: [Section] {
        var sections: [Section] = []
        
        sections.append(.header)
        sections.append(.passport)
        sections.append(.phoneNumbers)
        sections.append(.bankCards)
        sections.append(.pincode)
        
        return sections
    }
    
    private var notVerifiedSections: [Section] {
        var sections: [Section] = []
        sections.append(contentsOf: [
            .header,
            status == .rejected || status == .none || status == .expired || status == .blocked ? .verification : nil,
            status == .approved ? .pincode : nil,
            status == .requested ? .timer : nil,
        ].compactMap({ $0 }))
        
        return sections
    }
    
    var sections: [Section] {
        return isVerified ? verifiedSections : notVerifiedSections
    }
    
    public var isVerified: Bool {
        (AuthGlobalDefaults.user.isVerified ?? false) && status == .approved
    }
    
    public var status: VerificationStatusType? {
        input.verification?.status
    }
    
    private var tooltips: [NasiyaProfileViewControllerTooltip] {
        var tooltips: [NasiyaProfileViewControllerTooltip] = []
        if !isVerified, let verification: ProifleVerifyRoom = cell(for: .verification) {
            tooltips.append(.verification(in: verification.container))
        } else {
            if let passport: ProfileMenuRoom = cell(for: .passport) {
                tooltips.append(.passport(in: passport.container))
            }
            if let phoneNumbers: ProfileMenuRoom = cell(for: .phoneNumbers) {
                tooltips.append(.phoneNumbers(in: phoneNumbers.container))
            }
            if let bankCards: ProfileMenuRoom = cell(for: .bankCards) {
                tooltips.append(.bankCards(in: bankCards.container))
            }
        }
        if let pincode: ProfileMenuRoom = cell(for: .pincode) {
            tooltips.append(.pincode(in: pincode.container))
        }
        return tooltips
    }
    
    private let tooltipManager = TooltipManager()
    
    weak var coordinator: ProfileCoordinatorProtocol?
    
    let profileViewModel: ProfileViewModel
    let verificationViewModel: VerificationViewModel
    var input: Input
    var shouldOpenProfileDataAfterStepLoad = false
    
    public init(profileViewModel: ProfileViewModel,
                verificationViewModel: VerificationViewModel,
                input: Input = .init()) {
        self.input = input
        self.verificationViewModel = verificationViewModel
        self.profileViewModel = profileViewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tooltipManager.didViewAppear = true
        initialRequest()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tooltipManager.destroy()
    }
    
    public override func setupViews() {
        container.addSubview(table)
        table.addSubview(refreshControl)
    }
    
    public override func autolayout() {
        table.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        languageUpdated()
        navigationBar.rightButton.setIcon(.settings, edgeSize: 8, isIgnoringEdge: false)
    }
    
    public override func languageUpdated() {
        navigationBar.setTitle("profile".localized())
        table.reloadData()
    }
    
    public override func setupObservers() {
        coordinator?.completion = { [weak self] in
            guard let self else { return }
            navigationController?.popToRootViewController(animated: true)
//            let rootVC = UIApplication.shared.keyWindow?.rootViewController
//            rootVC?.showNasiyaAlertView(message: nil, type: .requested) {
//                self.dismiss(animated: false)
//            }
        }
        navigationBar.rightButton.clicked { [weak self] in
            guard let self = self else { return }
            self.coordinator?.pushSettings()
        }

        navigationBar.leftButton.clicked { [weak self] in
            guard let self = self else { return }
            coordinator?.presentMenu()
        }
        profileViewModel.$user
            .combineLatest(verificationViewModel.$step, OlchaVerificationDIContainer.shared.authCreditViewModel().$isVerified)
            .sink(receiveValue: { [weak self] (user, step, verified) in
                guard let self else { return }
                guard !shouldOpenProfileDataAfterStepLoad else {
                    switch step {
                    case .success(let verificationData):
                        shouldOpenProfileDataAfterStepLoad = false
                        openProfileData(with: verificationData)
                    case .failure(let error):
                        shouldOpenProfileDataAfterStepLoad = false
                        showError(text: error?.message)
                    default:
                        break
                    }
                    return
                }

                let isLoading = user == .loading || verified == .loading || step == .loading
                input.user = profileViewModel.userData
                input.verification = step.value
                input.userSkeleton.isAnimating = isLoading
                if !isLoading {
                    guard input.user != nil, input.verification != nil, AuthGlobalDefaults.user.isVerified != nil else { return }
                    table.reloadData(delay: 0.3) {
                        guard let topView = self.topView, !self.tooltipManager.didSetupTooltips else { return }
                        self.tooltipManager.setup(tooltips: self.tooltips, darkView: topView)
                    }
                    showNasiyaAlert(step: step.value)
                }
            }).store(in: &bag)
    }
    
    public override func initialRequest() {
        OlchaVerificationDIContainer.shared.authCreditViewModel().verifyCredit()
        profileViewModel.loadUserData()
        verificationViewModel.loadStep()
    }
    
    public override func refreshList(_ sender: AnyObject) {
        input.reset()
        table.reloadData()
        initialRequest()
        refreshControl.endRefreshing()
    }
}

private extension NasiyaProfileViewController {
    func cell<T: UITableViewCell>(for section: Section) -> T? {
        return table.cell(at: 0, in: sections.firstIndex(of: section).orZero) as? T
    }
    
    func showNasiyaAlert(step: VerificationData?) {
        let completed = VerificationGlobalDefaults.settings.getVerificationType(userId: AuthGlobalDefaults.user.id
        )
        guard completed != step?.status else {
            VerificationGlobalDefaults.settings.setVerificationStatus(userId: AuthGlobalDefaults.user.id, status: step?.status?.rawValue)
            return
        }
        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        switch step?.status {
        case .approved:
            rootVC?.showNasiyaAlertView(message: step?.status_text, type: .success) { [weak self] in
                guard let self else { return }
                self.dismiss(animated: false)
            }
        case .rejected:
            rootVC?.showNasiyaAlertView(message: step?.status_text, type: .reject) { [weak self] in
                guard let self else { return }
                self.dismiss(animated: false)
                self.coordinator?.pushVerificationFlow()
            }
        case .blocked: break
        case .expired: break
        default: break
        }
        VerificationGlobalDefaults.settings.setVerificationStatus(userId: AuthGlobalDefaults.user.id, status: step?.status?.rawValue)
    }
}
