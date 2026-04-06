//
//  CartImportModalPage.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 03/01/24.
//

import UIKit
import OlchaUI

class CartImportModalPage: BaseModalViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.textColor = .olchaTextBlack
        label.text = "export_products_exist".localized()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var table: BaseTableView = {
        let table = BaseTableView()
        table.delegate = self
        table.dataSource = self
        table.configure()
        table.registerClass(forCell: ImportProductRoom.self)
        return table
    }()
    
    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let cancelButton: IButton = {
        let button = IButton()
        button.backgroundColor = .lightGray1
        button.round()
        button.titleLabel?.style(.medium, 14)
        button.setTitleColor(.olchaTextBlack, for: .normal)
        button.setTitle("cancel".localized(), for: .normal)
        return button
    }()
    
    private let acceptButton: OlchaButton = {
        let button = OlchaButton()
        button.settings.setTitle("confirm".localized(), for: .normal)
        return button
    }()
    
    weak var coordinator: CartCoordinatorProtocol?
    
    var input: Input
    
    var completion: (() -> Void)?
    
    init(input: Input = .init()) {
        self.input = input
        super.init()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupViews() {
        container.addSubview(titleLabel)
        container.addSubview(table)
        container.addSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(cancelButton)
        buttonsStackView.addArrangedSubview(acceptButton)
    }
    
    override func autolayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
        }
        
        table.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).inset(-16)
            make.height.equalTo(400)
            make.bottom.equalTo(buttonsStackView.snp.top).inset(-16)
        }
        
        buttonsStackView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview().inset(16)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
        }
        
        acceptButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
        }
    }
    
    override func configureViews() {
        xButton.isHidden = true
        setHeader(title: "warning".localized() + "!")
    }
    
    override func setupObservers() {
        cancelButton.clicked { [weak self] in
            guard let self else { return }
            dismiss(animated: true)
        }
        
        acceptButton.clicked { [weak self] in
            guard let self else { return }
            dismiss(animated: true) {
                self.completion?()
            }
        }
    }
    
    func setup() {
        table.reloadData()
    }
}
