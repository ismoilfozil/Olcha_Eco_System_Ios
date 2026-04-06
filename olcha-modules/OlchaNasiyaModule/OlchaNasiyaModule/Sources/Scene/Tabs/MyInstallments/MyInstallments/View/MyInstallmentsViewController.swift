//
//  MyInstallmentsViewController.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 15/05/23.
//

import UIKit
import OlchaUI
import BetterSegmentedControl
import OlchaUtils
public class MyInstallmentsViewController: BaseViewController<NasiyaNavigationBar> {
    
    private let segmentContainer: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .equalSpacing
        stack.alignment = .center
        return stack
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.textColor = .olchaLightTextColornnnnnn
        label.textAlignment = .left
        return label
    }()
    
    private lazy var filterButton: RightIconButton = {
        let button = RightIconButton()
        button.backgroundColor = .olchaLightNeutralGray
        button.round(18)
        button.buttonTitle.style(.medium, 12)
        button.buttonTitle.textColor = .hex("#2F2F2F")
        return button
    }()
    
    public lazy var table: BaseTableView = {
        let table = BaseTableView()
        table.delegate = self
        table.dataSource = self
        table.registerClass(forCell: InstallmentRoom.self)
        table.configure()
        return table
    }()
    
    var currentStatus: InstallmentStatus = InstallmentStatus.all {
        didSet {
            if currentStatus.key != oldValue.key {
                tableReloader()
            }
        }
    }
    
    private var tooltips: [MyInstallmentsViewControllerTooltip] {
//        if getModels().isEmpty {
//            return [.selectButton(in: placeholder.mainButton)]
//        }
        let firstCell: InstallmentRoom? = table.cell(at: IndexPath(row: 0, section: 0))
        guard let firstCell = firstCell else { return [] }
        return [
            .singleInstallment(in: firstCell.container),
            .filterButton(in: filterButton),
        ]
    }
    
    private let tooltipManager = TooltipManager()
    
    var input = Input()
    var output = Output()
    
    let viewModel: InstallmentViewModel

    weak var coordinator: MyInstallmentsCoordinatorProtocol?
    
    public init(viewModel: InstallmentViewModel,
                input: Input = .init(),
                output: Output = .init()) {
        self.viewModel = viewModel
        self.input = input
        self.output = output
        super.init()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tooltipManager.didViewAppear = true
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tooltipManager.destroy()
    }
    
    public override func setupViews() {
        container.addSubview(segmentContainer)
        segmentContainer.addArrangedSubview(countLabel)
        segmentContainer.addArrangedSubview(filterButton)
        container.addSubview(table)
        table.addSubview(refreshControl)
    }
    
    public override func autolayout() {
        segmentContainer.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview().inset(16)
        }
        
        table.snp.makeConstraints { make in
            make.top.equalTo(segmentContainer.snp.bottom).inset(-4)
            make.left.right.bottom.equalToSuperview()
        }
        
        placeholder.snp.remakeConstraints { make in
            make.top.equalTo(segmentContainer.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        filterButton.snp.makeConstraints { make in
            make.height.equalTo(36)
        }
    }
    
    public override func setupObservers() {
        handle(viewModel.$installments) { [weak self] data in
            guard let self = self else { return }
            
            output.filters.installments.models.append(data?.orders,
                                                      output.filters.installments.paging)
            
            output.filters.set(statuses: data?.allStatuses)
            output.filters.installments.paging.finished(paginator: data?.paginator)
            
            tableReloader()
            
        } failure: { [weak self] error in
            guard let self = self else { return }
            output.filters.installments.paging.errorFinished()
        } loading: { [weak self] isLoading in
            guard let self = self else { return }
            output.filters.installments.paging.isLoading = isLoading
            input.skeleton.initialSkeleton(isAnimating: isLoading, output.filters.installments.paging)
            table.reloadData()
        }
        
        navigationBar.rightButton.clicked { [weak self] in
            guard let self = self else { return }
            coordinator?.pushNotifications()
        }
        
        navigationBar.leftButton.clicked { [weak self] in
            guard let self = self else { return }
            coordinator?.presentMenu()
        }
        
        filterButton.settings.clicked { [weak self] in
            guard let self = self else { return }
            
            showLoader()
            output.filters.getStatuses {
                self.hideLoader()
                self.coordinator?.presentInstallmentStatus(filters: self.output.filters)
            }
        }
        
        output.filters.statusObserver.sink { [weak self] isChanged in
            guard let self = self, isChanged else { return }
            statusChanged()
        }.store(in: &bag)
    }
    
    public override func configureViews() {
        languageUpdated()
    }
    
    public override func languageUpdated() {
        navigationBar.setTitle("my_applications".localized(.olchaNasiyaModule))
        
        placeholder.setupTitle("empty_payments".localized(.olchaNasiyaModule))
        placeholder.titleLabel.style(.semibold, 18)
        placeholder.mainButton.isHidden = true
    
        countLabel.text = "applications".localized(.olchaNasiyaModule) + ": \(output.filters.installments.paging.itemsCount)"
        setupSegmentTitles()
        
        languageReset()
    }
    
    
    public func loadMore(_ index: Int) {
        
        guard canLoad(index: index, paging: getPaging(), list: getModels()) else {
            return
        }
        
        table.reloadData()
        viewModel.loadInstallments(filter: output.filters)
    }
    
    private func setupSegmentTitles() {
        filterButton.configure(image: .bottomIcon?.withTintColor(.hex("#2F2F2F")),
                               title: currentStatus.title ?? " - ",
                               size: 20,
                               padding: 12)
    }
    
    public func statusChanged() {
        currentStatus = output.filters.status
        setupSegmentTitles()
        
        statusChangeReset()
    }
    
    public func tableReloader() {
        table.reloadData()
        updateCounter()
        getModels().isEmpty ? enablePlaceholder() : disablePlaceholder()
        guard let topView = topView else { return }
        tooltipManager.setup(tooltips: tooltips, darkView: topView)
    }
    
    public override func refreshList(_ sender: AnyObject) {
        refreshReset()
        refreshControl.endRefreshing()
    }
    
    private func updateCounter() {
        countLabel.text = "applications".localized(.olchaNasiyaModule) + ": \(output.filters.installments.paging.itemsCount)"
    }
    
}

//MARK: - Reset for list
public extension MyInstallmentsViewController {
    
    func languageReset() {
        output.filters.resetStatuses()
        output.filters.reset()
        statusChanged()
        
        resetBaseActions()
    }
 
    func refreshReset() {
        output.filters.reset()
        
        resetBaseActions()
    }
    
    func statusChangeReset() {
        output.filters.reset()
        
        resetBaseActions()
    }
    
    func resetBaseActions() {
        table.reloadData()
        disablePlaceholder()
        updateCounter()
        viewModel.loadInstallments(filter: output.filters, cancel: true)
    }
}
