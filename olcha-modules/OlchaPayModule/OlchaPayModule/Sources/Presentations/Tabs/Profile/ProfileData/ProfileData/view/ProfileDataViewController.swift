//
//  ProfileDataViewController.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 06/03/23.
//

import UIKit
import OlchaUI
import Combine
import OlchaAuth

public class ProfileDataViewController: BaseViewController<BackNavigationBar> {
    
    enum Section: Int {
        case photo
        case user
    }
    
    enum UserSectionRows {
        case id
        case phone
        case birthday
        case mail
        case password
    }
    
    private lazy var table: BaseTableView = {
        let table = BaseTableView()
        table.delegate = self
        table.dataSource = self
        table.configure()
        table.registerClass(forCell: ProfileDataRoom.self)
        table.registerClass(forCell: ProfilePhotoRoom.self)
        table.registerClass(forCell: ProfileDataHeaderRoom.self)
        return table
    }()
    
    let sections : [Section] = [
        .photo,
        .user
    ]
    
    let userSectionRows : [UserSectionRows] = [
        .id,
        .phone,
        .birthday,
//        .mail,
        .password
    ]
    
    var datePicker: UDatePicker?
    
    weak var coordinator: ProfileCoordinatorProtocol?
    
    let userUpdateObserver = PassthroughSubject<Bool, Never>()
    
    var user: User? {
        didSet {
            table.reloadData()
        }
    }
    
    let viewModel: ProfileViewModel
    
    public init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setupViews() {
        container.addSubview(table)
    }
    
    public override func autolayout() {
        table.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        
        navigationBar.setTitle("personal_datas".localized())
        
    }
    
    public override func initialRequest() {
        viewModel.loadUserData()
    }
    
    public override func setupObservers() {
        
        handle(viewModel.$user) { [weak self] data in
            guard let self = self else { return }
            self.user = data
        }
        
        userUpdateObserver
            .sink { [weak self] isUpdated in
                guard let self = self, isUpdated else { return }
                self.viewModel.edit(user: self.user)
                self.table.reloadData()
            }.store(in: &bag)
    }
    
}
