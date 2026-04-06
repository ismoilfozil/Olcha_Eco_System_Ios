//
//  PaymentsListView.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 04/02/23.
//


import UIKit
import OlchaUI
public class TransactionsListView: BaseView {
    
    private lazy var header: GroupHeaderView = {
        let view = GroupHeaderView()
        view.seeAllHidden = true
        return view
    }()
    
    private lazy var container: UIStackView = {
        let view = UIStackView()
        view.round()
        view.backgroundColor = .olchaWhite
        view.axis = .vertical
        return view
    }()
    
    private lazy var table: ContentSizedTableView = {
        let table = ContentSizedTableView()
        table.configure()
        table.delegate = self
        table.dataSource = self
        table.registerClass(forCell: TransactionRoom.self)
        table.registerClass(forCell: ShowAllRoom.self)
        table.isScrollEnabled = false
        return table
    }()
    
    public var maxCount: Int = 5 {
        didSet {
            updateLayout()
        }
    }
    
    public var actualCount: Int {
        min(items.count, maxCount)
    }
    
    public var listCount: Int {
        items.count
    }
    
    public var items: [TransactionModel] = [] {
        didSet {
            updateLayout()
        }
    }
    
    let rowHeight: CGFloat = UITableView.automaticDimension
    
    public weak var observers: PushPaymentHelper?
    
    public var showAllTransactionsObserver: (() -> Void)?
    
    public override func setupViews() {
        addSubview(header)
        addSubview(container)
        container.addArrangedSubview(table)
    }
    
    public override func autolayout() {
        header.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
        }
        
        container.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).inset(-16)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
        
    }
    
    public override func configureViews() {
        updateLayout()
    }
    
    private func updateLayout() {
        self.isHidden = items.isEmpty
        table.reloadData()
    }
    
    public func showAllTransactions(_ observer: (() -> Void)?) {
        self.showAllTransactionsObserver = observer
    }
    
    public func setupHeader(title: String) {
        header.set(title: title)
    }
    
    public func setup(data: [TransactionModel]) {
        self.items = data
        self.isHidden = data.isEmpty
    }
    
    public override func languageUpdated() {
        table.reloadData()
    }
    
    public func resetData() {
        self.isHidden = false
        self.items = []
    }
}
final class ContentSizedTableView: BaseTableView {
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
