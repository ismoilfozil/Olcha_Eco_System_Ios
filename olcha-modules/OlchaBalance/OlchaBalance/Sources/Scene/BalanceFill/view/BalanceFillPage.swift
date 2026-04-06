//
//  BalasnsFillPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 07/11/22.
//

import UIKit
import Combine
import OlchaUtils
import OlchaUI
public class BalanceFillPage: BaseViewController<BackNavigationBar> {
    
    private let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    let nextButton = OlchaButton()
    
    let sections: [Section] = [
        .card,
        .payments
    ]
    
    let observer = Observer()
    
    var payments: [Payments] = []
    
    let paymentHeight: CGFloat = 130
    
    let paymentSystemHeight: CGFloat = 78
    
    let viewModel: BalanceViewModel
    
    public init(viewModel: BalanceViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var coordinator: BalanceCoordinatorProtocol?
    
    public override func setupViews() {
        container.addSubview(collection)
        container.addSubview(nextButton)
    }

    public override func autolayout() {
        collection.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        nextButton.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview().inset(16)
        }
    }
    
    public override func configureViews() {
        navigationBar.setTitle("fill_balans".localized())
        
        collection.delegate = self
        collection.dataSource = self
        collection.registerClass(forCell: PaymentTitleItem.self)
        collection.registerClass(forCell: PaymentIconItem.self)
        collection.isScrollEnabled = false
        collection.contentInset = .init(top: 0, left: 0, bottom: 60, right: 0)
        collection.backgroundColor = .olchaBackgroundColor
        nextButton.setTitle("continue".localized())
        nextButton.disableButton()
        
        if let layout = collection.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 8
            layout.minimumLineSpacing = 0
            collection.collectionViewLayout = layout
        }
    }
    
    public override func initialRequest() {
//        viewModel.loadPaymentTypes()
    }
    
    public override func setupObservers() {
    
        nextButton.settings.clicked { [weak self] in
            guard let self = self else { return }
            switch self.observer.selectedPayment {
                case .card:
                    self.coordinator?.pushBalanceCards()
                    break
                case .payment(let payment):
                    self.coordinator?.pushPaymentFill(payment: payment)
                    break
                case .none: break
            }
        }
        
        handle(viewModel.$payments, success: { [weak self] data in
            guard let self = self else { return }
            self.payments = data ?? []
            self.collection.reloadData()
        })
        
    }
    
}
