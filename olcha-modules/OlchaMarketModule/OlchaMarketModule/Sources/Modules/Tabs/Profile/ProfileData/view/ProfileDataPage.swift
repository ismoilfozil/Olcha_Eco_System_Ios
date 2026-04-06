//
//  ProfileDataPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 22/09/22.
//

import UIKit
import Combine
import OlchaAuth

import OlchaBankCards
import OlchaUI
import OlchaVerification
class ProfileDataPage: BaseViewController {

    enum Section: Int {
        case photo
        case user
        case cards
        case password
    }
    
    enum UserSectionRows {
        case id
        case phone
        case birthday
        case mail
        case address
        case extraPhone
        case passport
    }
    
    enum CardSectionRows {
        case emptySpace
        case header
        case emptyBottomSpace
        case separator
    }
    
    let table = BaseTableView()
    
    let sections : [Section] = [
        .photo,
        .user,
        .cards,
        .password
    ]
    
    let userSectionRows : [UserSectionRows] = [
        .id,
        .phone,
        .birthday,
        .mail,
//        .address,
//        .extraPhone,
//        .passport
    ]
    
    private var bag = Set<AnyCancellable>()
    
    private lazy var verificationViewModel: VerificationViewModel = OlchaVerificationDIContainer.shared.resolve()
    private lazy var bankCardViewModel: BankCardViewModel = BankCardsDIContainer.shared.resolve()
    private let viewModel = ProfilePageViewModel()
    
    var cards: [BankCard] = []
    
    var user: User?
    
    var step: VerificationData?
    
    var datePicker: UDatePicker?
    
    weak var coordinator: ProfileCoordinatorProtocol?
    
    let userUpdateObserver = PassthroughSubject<Bool, Never>()
    
    override func setupViews() {
        container.addSubview(table)
    }
    
    override func autolayout() {
        table.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureViews() {
        navigation.configure(style: .back)
        navigation.setTitle("personal_datas".localized())
        table.delegate = self
        table.dataSource = self
        table.configure()
        table.registerClass(forCell: ProfileDataRoom.self)
        table.registerClass(forCell: ProfilePhotoRoom.self)
        table.registerClass(forCell: ProfileDataHeaderRoom.self)
    }
    
    override func initialRequest() {
        bankCardViewModel.loadBankCards()
        verificationViewModel.loadStep()
        viewModel.loadUserData()
    }
    
    override func setupObservers() {
        super.baseSetupObservers(viewModel: viewModel)
        viewModel
            .$user
            .dropFirst()
            .sink { [weak self] data in
                guard let self = self else { return }
                self.user = data
                self.table.reloadData()
            }.store(in: &bag)
        
        handle(bankCardViewModel.$cards, withError: false, success: { [weak self] data in
            guard let self = self else { return }
            self.cards = cards
            self.table.reloadData()
        })
        
        handle(verificationViewModel.$step, withError: false) { [weak self] data in
            guard let self = self else { return }
            self.step = data
            self.table.reloadData()
        }
        
        userUpdateObserver
            .sink { [weak self] isUpdated in
                guard let self = self, isUpdated else { return }
                self.viewModel.updateUser(user: self.user)
                self.table.reloadData()
            }.store(in: &bag)
    }
    
}
