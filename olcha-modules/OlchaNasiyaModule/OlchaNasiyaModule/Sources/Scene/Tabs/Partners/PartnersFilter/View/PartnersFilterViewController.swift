//
//  PartnersFilterViewController.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 18/05/23.
//

import UIKit
import OlchaUI

public class PartnersFilterViewController: BaseModalViewController {
    
    private lazy var table: BaseTableView = {
        let table = BaseTableView()
        table.delegate = self
        table.dataSource = self
        table.registerClass(forCell: PartnerFilterRoom.self)
        table.configure()
        
        return table
    }()
    
    let rowHeight: CGFloat = 42
    
    public var input = Input()
    
    weak var coordinator: PartnerCoordinatorProtocol?
    
    var selectedIndex: Int? {
        didSet {
            table.reloadData()
        }
    }
    
    var completion: ((PartnersFilterModel?) -> Void)?
    
    public init(input: Input = .init()) {
        self.input = input
        super.init()
    }
    
    public required init?(coder: NSCoder) {
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
    
    public func fillData() {
        table.reloadData()
        setContainerHeight(rowHeight * input.models.count.cgfloat)
        selectedIndex = input.models.firstIndex(where: { $0.getIsSelected() == true })
    }
}
