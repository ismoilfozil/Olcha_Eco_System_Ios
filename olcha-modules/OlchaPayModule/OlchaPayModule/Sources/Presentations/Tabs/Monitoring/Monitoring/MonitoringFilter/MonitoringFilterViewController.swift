//
//  MonitoringModalViewController.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 23/02/23.
//

import UIKit
import OlchaUI

import Combine
public protocol SelectableModel: Codable {
    var isSelected: Bool? { get set }
}
public class MonitoringFilterViewController: BaseModalViewController {

    private lazy var fieldsContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var fromFieldContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var toFieldContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var fromFieldResetButton: IconButton = {
        let button = IconButton()
        button.setIcon(.x, isIgnoringEdge: true)
        return button
    }()
    
    private lazy var fromField: TField = {
        let field = TField()
        field.topHint = "date".localized()
        field.enableButton = true
        return field
    }()
    
    private lazy var toFieldResetButton: IconButton = {
        let button = IconButton()
        button.setIcon(.x, isIgnoringEdge: true)
        return button
    }()
    
    private lazy var toField: TField = {
        let field = TField()
        field.topHint = " "
        field.enableButton = true
        return field
    }()
    
    private lazy var table: ContentSizedTableView = {
        let table = ContentSizedTableView()
        table.delegate = self
        table.dataSource = self
        table.registerClass(forCell: SelectableRoom.self)
        table.registerClass(forHeaderFooter: MonitoringFilterHeaderRoom.self)
        table.configure()
        return table
    }()
    
    private let buttonsContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 12
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var acceptButton: OlchaButton = {
        let button = OlchaButton()
        button.setTitle("accept".localized())
        button.configure(type: .pay)
        return button
    }()
    
    private let cancelButton: IButton = {
        let button = IButton()
        button.titleLabel?.style(.medium, 16)
        button.setTitleColor(.olchaTextBlack, for: .normal)
        button.backgroundColor = .lightGray1
        button.setTitle("reset".localized(), for: .normal)
        button.round()
        return button
    }()
    
    private var fromDatePicker: UDatePicker?
    private var toDatePicker: UDatePicker?
    
    public let sections: [Section] = [
        .categories,
        .cards
    ]
    
    weak var coordinator: MonitoringCoordinatorProtocol?
    
    public let viewModel: TransactionViewModel
    
    var categories: [CategoryModel] = []
    
    var cardTypes: [BankCardType] = []
    
    public weak var features: TransactionsFeatures? {
        didSet {
            categories = features?.categories ?? []
            cardTypes = features?.cards ?? []
            table.reloadData()
        }
    }
    
    public weak var bankCard: UserBankCardModel? {
        didSet {
            
        }
    }
    
    public var filters = TransactionsFilters() {
        didSet {

        }
    }
    
    public weak var acceptObserver: PassthroughSubject<TransactionsFilters, Never>?
    
    public init(viewModel: TransactionViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setupViews() {
        container.addSubview(fieldsContainer)
        
        fieldsContainer.addArrangedSubview(fromFieldContainer)
        fromFieldContainer.addSubview(fromField)
        fromFieldContainer.addSubview(fromFieldResetButton)
        fieldsContainer.addArrangedSubview(toFieldContainer)
        toFieldContainer.addSubview(toField)
        toFieldContainer.addSubview(toFieldResetButton)
        container.addSubview(table)
        container.addSubview(buttonsContainer)
        buttonsContainer.addArrangedSubview(acceptButton)
        buttonsContainer.addArrangedSubview(cancelButton)
        table.addSubview(refreshControl)
    }
    
    public override func autolayout() {
        fieldsContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview()
        }
        
        table.snp.makeConstraints { make in
            make.top.equalTo(fieldsContainer.snp.bottom).inset(-8)
            make.left.right.equalToSuperview()
        }
        
        buttonsContainer.snp.makeConstraints { make in
            make.top.equalTo(table.snp.bottom).inset(-16)
            make.left.right.bottom.equalToSuperview().inset(16)
        }
        
        fromField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        toField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        fromFieldResetButton.snp.makeConstraints { make in
            make.right.equalTo(fromField.snp.right).inset(8)
            make.centerY.equalTo(fromField.settings.snp.centerY)
            make.width.height.equalTo(24)
        }
        
        toFieldResetButton.snp.makeConstraints { make in
            make.right.equalTo(toField.snp.right).inset(8)
            make.centerY.equalTo(toField.settings.snp.centerY)
            make.width.height.equalTo(24)
        }
    }
    
    public override func setupObservers() {
        
        fromField.button.clicked { [weak self] in
            guard let self = self else { return }
            
            self.fromDatePicker = self.presentDatePicker(datePicker: self.fromDatePicker,
                                                         minimumDate: filters.getFromMinimumDate(),
                                                         maximumDate: filters.getFromMaximumDate(),
                                                         dateString: filters.from) { date in
                self.fromField.text = date
                self.filters.from = date
            }
        }
        
        toField.button.clicked { [weak self] in
            guard let self = self else { return }
            self.toDatePicker = self.presentDatePicker(datePicker: self.toDatePicker,
                                                       minimumDate: filters.getToMinimumDate(),
                                                       maximumDate: filters.getToMaximumDate(),
                                                       dateString: filters.to) { date in
                self.toField.text = date
                self.filters.to = date
            }
        }
        
        handle(viewModel.$transactionFeatures,
               showLoader: true) { [weak self] data in
            guard let self = self else { return }
            self.features = data
        } failure: { [weak self] error in
            guard let self = self else { return }
            self.showError(text: error?.message)
        }
        
        acceptButton.clicked { [weak self] in
            guard let self = self else { return }
            acceptFilters()
        }
        
        cancelButton.clicked { [weak self] in
            guard let self else { return }
            self.filters = .init()
            acceptFilters()
        }
        
        fromFieldResetButton.clicked { [weak self] in
            guard let self = self else { return }
            self.filters.from = nil
            
            self.fromField.settings.text = ""
        }
        
        toFieldResetButton.clicked { [weak self] in
            guard let self = self else { return }
            self.filters.to = nil
            
            self.toField.settings.text = ""
        }
    }
    
    public override func configureViews() {
        setHeader(title: "filtr".localized())
        
        setContainerHeight(UIScreen.main.bounds.height * 0.6)
        
        fromField.text = filters.from
        toField.text = filters.to
    }
    
    public override func refreshList(_ sender: AnyObject) {
        viewModel.loadTransactionFeatures()
        refreshControl.endRefreshing()
    }
    
    private func acceptFilters() {
        acceptObserver?.send(filters)
        dismiss(animated: true, completion: nil)
    }
    
    public func setupFilters() {
        
    }
}
