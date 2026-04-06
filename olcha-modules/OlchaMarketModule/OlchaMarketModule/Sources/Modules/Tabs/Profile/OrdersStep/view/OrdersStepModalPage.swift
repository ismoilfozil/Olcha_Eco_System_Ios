//
//  OrdersStepModalPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 19/10/22.
//

import UIKit
import OlchaUI
class OrdersStepModalPage: BaseViewController {
    
    private let table = BaseTableView()
    
    var steps: [OrderStatus] = [] {
        didSet {
            print("check steps count", steps)
            table.reloadData()
        }
    }
    
    override func viewDidLoad() {
        setupModalViews()
        modalAutolayout()
        configureModalViews()
    }
    
    override func setupModalViews() {
        super.setupModalViews()
        modalContainer.addSubview(table)
    }
    
    override func modalAutolayout() {
        super.modalAutolayout()
        table.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureModalViews(header: String = "", textAlignment: NSTextAlignment = .left) {
        super.configureModalViews(header: header, textAlignment: textAlignment)
        dismissConfiguration()
        table.delegate = self
        table.dataSource = self
        table.registerClass(forCell: OrderStepRoom.self)
        table.configure()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setContainerHeight(table.calculateTableViewHeight())
    }
}

