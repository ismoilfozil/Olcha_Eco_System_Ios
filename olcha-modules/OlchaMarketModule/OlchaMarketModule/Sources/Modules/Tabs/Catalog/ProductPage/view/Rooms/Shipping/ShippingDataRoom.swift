//
//  ShippingDataRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 19/07/22.
//

import UIKit
import Combine
import OlchaUI
class ShippingDataRoom: BaseTableCell {
    private let titleLabel = UILabel()
    private let table = UITableView()
    //info
    private let infoContainer = UIView()
    private let infoIcon = UIImageView()
    private let infoTitle = UILabel()
    
  
    weak var mainTableReloader: PassthroughSubject<ProductPage.Sections, Never>?
    
    private var shippingData : [Store] = [] {
        didSet {
            updateLayout()
            if oldValue != shippingData {
                mainTableReloader?.send(.all)
            }
        }
    }
    
    let cellHeight: CGFloat = 60
    
    override func setupViews() {
        
        container.addSubview(titleLabel)
        container.addSubview(table)
//        addSubview(infoContainer)
//        infoContainer.addSubview(infoIcon)
//        infoContainer.addSubview(infoTitle)
    }
    
    override func autolayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
        }
        
        table.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).inset(-16)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
            make.height.equalTo(0)
        }
        
//        infoContainer.snp.makeConstraints { make in
//            make.top.equalTo(self.table.snp.bottom).inset(-16)
//            make.left.right.equalToSuperview().inset(16)
//            make.bottom.equalToSuperview().inset(16)
//        }
        
//        infoIcon.snp.makeConstraints { make in
//            make.left.top.equalToSuperview()
//            make.width.height.equalTo(20)
//        }
//
//        infoTitle.snp.makeConstraints { make in
//            make.right.bottom.equalToSuperview()
//            make.top.bottom.equalToSuperview().inset(2)
//            make.left.equalTo(self.infoIcon.snp.right).inset(-8)
//        }
    }
    
    override func configureViews() {
        backgroundColor = .lightGrayBackground
        infoContainer.backgroundColor = .clear
        table.backgroundColor = .clear
        
        titleLabel.style(.semibold, 24)
        titleLabel.textColor = .olchaTextBlack
        titleLabel.text = "shipping_info".localized()
        titleLabel.numberOfLines = 0
        
        table.delegate = self
        table.dataSource = self
        table.registerClass(forCell: ShippingDataItem.self)
        table.registerClass(forCell: Separator.self)
        
        table.separatorStyle = .none
        table.isScrollEnabled = false
        
//        infoIcon.image = .info?.withTintColor(.olchaOrange ?? .orange, renderingMode: .alwaysOriginal)
//        infoTitle.textColor = .olchaOrange
//        infoTitle.style(.medium, 14)
//        infoTitle.text = "shipping_info".localized()
//        infoTitle.numberOfLines = 0
        
        
    }
    
    private func updateLayout() {
        self.table.reloadData()
        let height = cellHeight * shippingData.count.cgfloat
        let separatorsHeight = 33.0 * (max(0, (shippingData.count - 1))).cgfloat
        self.table.snp.remakeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).inset(-16)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
            make.height.equalTo( height + separatorsHeight )
        }
    }
    
    func setup(with data: [Store]) {
        self.shippingData = data
        titleLabel.text = "shipping_info".localized()
    }
}

extension ShippingDataRoom: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        shippingData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == (shippingData.count - 1) ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeue(ShippingDataItem.self, for: indexPath)
            if indexPath.section == 0 {
                cell.configure(style: .standard)
            }
            cell.setup(with: shippingData[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeue(Separator.self, for: indexPath)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        indexPath.row == 0 ? cellHeight : 33
    }
}

class ShippingDataRoomView: BaseTableCellView {
    private let titleLabel = UILabel()
    private let table = UITableView()
    //info
    private let infoContainer = UIView()
    private let infoIcon = UIImageView()
    private let infoTitle = UILabel()
    
  
    weak var mainTableReloader: PassthroughSubject<ProductPage.Sections, Never>?
    
    private var shippingData : [Store] = [] {
        didSet {
            updateLayout()
            if oldValue != shippingData {
                mainTableReloader?.send(.all)
            }
        }
    }
    
    let cellHeight: CGFloat = 60
    
    override func setupViews() {
        
        container.addSubview(titleLabel)
        container.addSubview(table)
//        addSubview(infoContainer)
//        infoContainer.addSubview(infoIcon)
//        infoContainer.addSubview(infoTitle)
    }
    
    override func autolayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
        }
        
        table.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).inset(-16)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
            make.height.equalTo(0)
        }
        
//        infoContainer.snp.makeConstraints { make in
//            make.top.equalTo(self.table.snp.bottom).inset(-16)
//            make.left.right.equalToSuperview().inset(16)
//            make.bottom.equalToSuperview().inset(16)
//        }
        
//        infoIcon.snp.makeConstraints { make in
//            make.left.top.equalToSuperview()
//            make.width.height.equalTo(20)
//        }
//
//        infoTitle.snp.makeConstraints { make in
//            make.right.bottom.equalToSuperview()
//            make.top.bottom.equalToSuperview().inset(2)
//            make.left.equalTo(self.infoIcon.snp.right).inset(-8)
//        }
    }
    
    override func configureViews() {
        backgroundColor = .lightGrayBackground
        infoContainer.backgroundColor = .clear
        table.backgroundColor = .clear
        
        titleLabel.style(.semibold, 24)
        titleLabel.textColor = .olchaTextBlack
        titleLabel.text = "shipping_info".localized()
        titleLabel.numberOfLines = 0
        
        table.delegate = self
        table.dataSource = self
        table.registerClass(forCell: ShippingDataItem.self)
        table.registerClass(forCell: Separator.self)
        
        table.separatorStyle = .none
        table.isScrollEnabled = false
        
//        infoIcon.image = .info?.withTintColor(.olchaOrange ?? .orange, renderingMode: .alwaysOriginal)
//        infoTitle.textColor = .olchaOrange
//        infoTitle.style(.medium, 14)
//        infoTitle.text = "shipping_info".localized()
//        infoTitle.numberOfLines = 0
        
        
    }
    
    private func updateLayout() {
        self.table.reloadData()
        let height = cellHeight * shippingData.count.cgfloat
        let separatorsHeight = 33.0 * (max(0, (shippingData.count - 1))).cgfloat
        self.table.snp.remakeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).inset(-16)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
            make.height.equalTo( height + separatorsHeight )
        }
    }
    
    func setup(with data: [Store]) {
        self.shippingData = data
        titleLabel.text = "shipping_info".localized()
    }
}

extension ShippingDataRoomView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        shippingData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == (shippingData.count - 1) ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeue(ShippingDataItem.self, for: indexPath)
            if indexPath.section == 0 {
                cell.configure(style: .standard)
            }
            cell.setup(with: shippingData[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeue(Separator.self, for: indexPath)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        indexPath.row == 0 ? cellHeight : 33
    }
}
