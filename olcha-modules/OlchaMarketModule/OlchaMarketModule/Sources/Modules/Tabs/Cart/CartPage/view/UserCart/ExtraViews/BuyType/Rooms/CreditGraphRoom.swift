//
//  CreditGraphRoom.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 21/02/24.
//

import UIKit
import OlchaUI
import Combine
public class CreditGraphRoom: BaseTableCell {
    private var bag = Set<AnyCancellable>()
    lazy var table: SwiftDataTable = makeDataTable()
    let configuration: DataTableConfiguration = {
        var configuration = DataTableConfiguration()
        configuration.shouldShowFooter = false
        configuration.shouldShowSearchSection = false
        configuration.fixedColumns = .init(leftColumns: 1)
        return configuration
    }()
    
    public weak var observers: CartObservers? {
        didSet {
            
        }
    }
    
    var graphObserver: CurrentValueSubject<[String: InstallmentInfo], Never>? {
        didSet {
            configureViews()
        }
    }
    
    var products: [ProductModel] = []
    var creditOrder: CreditOrder?
    private var graph: [String: InstallmentInfo] = [:]
    
    public override func setupViews() {
        container.addSubview(table)
    }
    
    public override func autolayout() {
        table.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
            make.height.equalTo(300)
        }
    }
    
    public override func configureViews() {
        graphObserver?.sink { [weak self] data in
            guard let self else { return }
            self.graph = data
            setup()
        }.store(in: &bag)
    }
    
    func setup() {
        table.set(data: data(),
                  headerTitles: columnHeaders(),
                  options: self.configuration)
        table.reloadEverything()
    }
    
}

extension CreditGraphRoom {
    fileprivate func makeDataTable() -> SwiftDataTable {
        let dataTable = SwiftDataTable(
            data: self.data(),
            headerTitles: self.columnHeaders(),
            options: self.configuration
        )
        
        dataTable.backgroundColor = .olchaWhite
        dataTable.delegate = self
        return dataTable
    }
    
    fileprivate func columnHeaders() -> [String] {
        
        var list: [String] = ["products".localized() + " " + products.count.string]
        list.append("initial_fee".localized())
        for i in 0..<(creditOrder?.creditDatas[.olcha]?.inst_pay_time ?? 0) {
            list.append("\(i+1)" + "month_short".localized())
        }
        
        return list
    }
    
    fileprivate func data() -> [[DataTableValueType]]{
        return getTableData().map {
            $0.compactMap (DataTableValueType.init)
        }
    }
}

extension CreditGraphRoom: SwiftDataTableDelegate {
    fileprivate func getTableData() -> [[Any]] {
        var list: [[Any]] = []
        
        for product in products {
            var productGraphList: [String] = [product.main_image ?? ""]
            
            
            if let graph: InstallmentInfo = graph[product.id?.string ?? ""] {
                productGraphList.append(graph.first_fee.string.originalPriceWithoutCurrency)
                for i in 0..<(creditOrder?.creditDatas[.olcha]?.inst_pay_time ?? 0) {
                    if graph.maxPeriod.int > i {
                        productGraphList.append(graph.paymentPerMonth.string.originalPriceWithoutCurrency)
                    } else {
                        productGraphList.append("0".originalPriceWithoutCurrency)
                    }
                }
            }
            list.append(productGraphList)
        }
        
        return list
    }
}
