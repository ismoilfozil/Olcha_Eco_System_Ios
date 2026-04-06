//
//  File.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 18/10/23.
//

import UIKit
import OlchaUI
class ReturnOrderProductsViewController: OlchaUI.BaseViewController<OlchaUI.BackNavigationBar> {
    
    private lazy var table: UITableView = {
        let table = UITableView()
        
        table.delegate = self
        table.dataSource = self
        table.registerClass(forCell: ReturnOrderProductRoom.self)
        table.configure()
        
        return table
    }()
    
    weak var coordinator: ReturnOrderCoordinatorProtocol?
    
    var input: Input
    
    init(input: Input = .init()) {
        self.input = input
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupViews() {
        container.addSubview(table)
    }
    
    override func autolayout() {
        table.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupData() {
        table.reloadData()
    }
}
