//
//  DetailedPaymentViewController.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 23/02/23.
//

import UIKit
import OlchaUI
import OlchaUtils
public class DetailedTransactionViewController: BaseViewController<BackNavigationBar> {
    
    private lazy var table: BaseTableView = {
        let table = BaseTableView()
        table.configure()
        table.delegate = self
        table.dataSource = self
        table.registerClass(forCell: PayedHeaderRoom.self)
        table.registerClass(forCell: FinishActionsRoom.self)
        table.registerClass(forCell: PayedDetailRoom.self)
        return table
    }()
    
    public let sections: [Section] = [
        .header,
        .details,
        .actions
    ]
    
    public weak var coordinator: PaymentsCoordinatorProtocol?
    
    var transaction: TransactionModel?
    
    var fullTransaction: TransactionModel?
    
    var details: [[KeyValueModel]] = []
    
    public let makeTransactionViewModel: MakeTransactionViewModel
    public let transactionViewModel: TransactionViewModel
    
    public init(makeTransactionViewModel: MakeTransactionViewModel,
                transactionViewModel: TransactionViewModel) {
        self.makeTransactionViewModel = makeTransactionViewModel
        self.transactionViewModel = transactionViewModel
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
        navigationBar.setTitle("detalization".localized())
        
        details = [
            
            generateInDetails(),
            
            generateOutDetails()
            
        ]
    }
    
    public override func initialRequest() {
        transactionViewModel.loadTransaction(id: transaction?.id)
    }
    
    public override func setupObservers() {
        handle(transactionViewModel.$transaction,
               showLoader: true,
               success: { [weak self] data in
            guard let self = self else { return }
            self.fullTransaction = data?.transaction
        })
        
        handle(makeTransactionViewModel.$retryTransaction,
               showLoader: true,
               success: { [weak self] data in
            guard let self = self else { return }
            self.showSuccess(text: data?.transactions?.fields?.first?.value)
        })

    }
    
    public func getTransaction(completion: @escaping ((TransactionModel?) -> Void) ) {
        if let fullTransaction = fullTransaction {
            completion(fullTransaction)
        } else {
            transactionViewModel.loadTransaction(id: self.transaction?.id) { [weak self] in
                guard let self = self else { return }
                completion(self.fullTransaction)
            }
        }
    }
    
    private func generateInDetails() -> [KeyValueModel] {
        return [.init(key: "sender_card".localized(),
                      value: transaction?.card_id?.bank_card?.getSpacedPan()),
                
                .init(key: "sender".localized(),
                      value: transaction?.card_id?.bank_card?.full_name),
        ]
    }
    
    private func generateOutDetails() -> [KeyValueModel] {
        return [
            .init(key: "date".localized(),
                  value: transaction?.dateTime()),
            
            .init(key: "cashback".localized(),
                  value: "0".originalPrice),
            
            .init(key: "status".localized(),
                  value: transaction?.getStatus())
        ]
    }
    
}
