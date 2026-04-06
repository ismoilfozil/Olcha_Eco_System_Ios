//
//  File.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 24/09/23.
//

import UIKit
import OlchaUI

public class PDFinvoiceViewController: BaseViewController<BackNavigationBar> {
    
    private let invoiceView = PDFinvoice()
    
    private let transaction: TransactionModel?
    
    public init(transaction: TransactionModel?) {
        self.transaction = transaction
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setupViews() {
        container.addSubview(invoiceView)
    }
    
    public override func autolayout() {
        invoiceView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
    
    public override func configureViews() {
        container.backgroundColor = .olchaLightNeutralGray
        navigationBar.searchButton.isHidden = false
        navigationBar.searchButton.setIcon(.download)
        
        invoiceView.setup(transaction: transaction)
    }
    
    public override func setupObservers() {
        navigationBar.searchButton.clicked { [weak self] in
            guard let self else { return }
            createPdf()
        }
    }
    
    func createPdf() {
        self.showLoader()
        PdfService.shared.createCheck(self.transaction) { data in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.hideLoader()
                self.showShareCheck(data: data)
            }
        }
    }
}
