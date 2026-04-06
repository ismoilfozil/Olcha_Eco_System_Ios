//
//  InstallmentGraphRoom.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 17/05/23.
//

import UIKit
import OlchaUI
public class InstallmentGraphRoom: BaseTableCell {

    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.round()
        stackView.border(with: .lightGrayBackground)
        return stackView
    }()
    
    private lazy var headerContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGrayBackground
        view.round()
        return view
    }()
    
    private let headerStackContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .firstBaseline
        return stackView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.style(.regular, 14)
        label.textColor = .olchaTextBlack
        return label
    }()
    
    private let statusTitleLabel: UILabel = {
        let label = UILabel()
        label.style(.regular, 14)
        label.textAlignment = .right
        return label
    }()
    
    public let expandeIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .arrow_down
        return imageView
    }()
    
    private lazy var table: BaseTableView = {
        let table = BaseTableView()
        table.delegate = self
        table.dataSource = self
        
        table.registerClass(forCell: InstallmentDetailRoom.self)
        table.configure()
        
        table.isHidden = true
        return table
    }()
    
    public let expandeButton: IButton = {
        let button = IButton()
        return button
    }()
    
    public var model: InstallmentGraphMonthModel? {
        didSet {
            monthPayments = model?.getPaymentItems() ?? []
            isExpanded = model?.isExpanded ?? false
        }
    }
    
    fileprivate var monthPayments: [InstallmentPaymentDetailModel] = [] {
        didSet {
            tableReloader()
        }
    }
    
    public var isExpanded: Bool = false {
        didSet {
            table.isHidden = !isExpanded
            expandeIcon.image = isExpanded ? .arrow_down : .arrow_up
        }
    }
    
    public var isExpandable: Bool = false {
        didSet {
            expandeIcon.isHidden = !isExpandable
            expandeButton.isHidden = !isExpandable
        }
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        dateLabel.text = ""
        statusTitleLabel.text = ""
    }
    
    public override func setupViews() {
        container.addSubview(containerStackView)
        containerStackView.addArrangedSubview(headerContainer)
        headerContainer.addSubview(headerStackContainer)
        
        headerStackContainer.addArrangedSubview(dateLabel)
        headerStackContainer.addArrangedSubview(statusTitleLabel)
        headerContainer.addSubview(expandeIcon)
            
        containerStackView.addArrangedSubview(table)
        headerContainer.addSubview(expandeButton)
    }
    
    public override func autolayout() {
        containerStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(6)
        }
        
        headerContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        headerStackContainer.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().inset(16)
            make.right.equalTo(expandeIcon.snp.left).inset(-4)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(16)
        }
        
        statusTitleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(16)
        }
        
        expandeIcon.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(16)
        }
        
        table.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        expandeButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        expandeIcon.isHiddenWhenSkeletonIsActive = true
        makeSkeleton(views: [
            containerStackView,
            headerContainer,
            expandeIcon
        ])
    }
    
    public func setup(with data: InstallmentGraphMonthModel) {
        self.model = data
        dateLabel.text = data.getPaymentDay()
        setup(status: data.getStatus())
        isExpandable = !data.getPaymentItems().isEmpty
    }
    
    private func setup(status: InstallmentGraphMonthModel.Status) {
        statusTitleLabel.text = model?.status_name
        statusTitleLabel.textColor = status.accentColor
    }
    
    private func tableReloader() {
        table.reloadData()
        table.layoutIfNeeded()

        table.snp.remakeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(table.contentSize.height)
        }
        
    }
}

extension InstallmentGraphRoom: TableDelegates {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        monthPayments.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(InstallmentDetailRoom.self, for: indexPath)
        cell.contentColor = .olchaTextBlack
        if monthPayments.isGreater(indexPath) {
            cell.setup(title: monthPayments[indexPath.row].date,
                       content: (monthPayments[indexPath.row].amount ?? 0).string.originalPrice)
        }
        return cell
    }
}
