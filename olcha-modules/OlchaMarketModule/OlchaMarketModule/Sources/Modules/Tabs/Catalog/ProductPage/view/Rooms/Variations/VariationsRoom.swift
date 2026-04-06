//
//  VariationsRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 18/07/22.
//

import UIKit
import SwiftyJSON
import SnapKit
import OlchaUI
enum CombinationState {
    case enabled
    case disabled
    case none
}

class VariationsRoom: BaseTableCell {
    private let table = UITableView()
    
    weak var variationHelper: VariationHelper?
    
    override func setupViews() {
        container.addSubview(table)
    }
    
    override func autolayout() {
        table.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
            make.height.equalTo(0)
        }
    }
    
    override func configureViews() {
        table.delegate = self
        table.dataSource = self
        table.registerClass(forCell: OptionsCell.self)
        table.separatorStyle = .none
        table.isScrollEnabled = false
    }
    
    
    func setup(with variationHelper: VariationHelper?) {
        self.variationHelper = variationHelper
        table.reloadData()
        updateLayout()
    }
    
    private func updateLayout() {
        let height = self.variationHelper?.getTableHeight()
        table.snp.remakeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
            if let height = height {
                make.height.equalTo(height)
            }
        }
    }
}

extension VariationsRoom: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return variationHelper?.resultVariations.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OptionsCell.TAG, for: indexPath) as! OptionsCell
        if let variationHelper = variationHelper {
            cell.helper = self.variationHelper
            cell.setDatas(variation: variationHelper.resultVariations[indexPath.row],
                          xSelectedCombination: variationHelper.checkCombination(featureID: variationHelper.resultVariations[indexPath.row].id),
                          resultVariations: variationHelper.resultVariations,
                          combinations: variationHelper.combinations
            )
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let variationHelper = variationHelper else { return VariationHelper.textSize }
        
        let imageRow: Bool = variationHelper.resultVariations[indexPath.row].isImage
        
        if (imageRow) {
            return VariationHelper.imageSize
        }
        return VariationHelper.textSize
    }
}

class VariationsRoomView: BaseTableCellView {
    private let table = UITableView()
    
    weak var variationHelper: VariationHelper?
    
    override func setupViews() {
        container.addSubview(table)
    }
    
    override func autolayout() {
        table.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
            make.height.equalTo(0)
        }
    }
    
    override func configureViews() {
        table.delegate = self
        table.dataSource = self
        table.registerClass(forCell: OptionsCell.self)
        table.separatorStyle = .none
        table.isScrollEnabled = false
    }
    
    
    func setup(with variationHelper: VariationHelper?) {
        self.variationHelper = variationHelper
        table.reloadData()
        updateLayout()
    }
    
    private func updateLayout() {
        let height = self.variationHelper?.getTableHeight()
        table.snp.remakeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
            if let height = height {
                make.height.equalTo(height)
            }
        }
    }
}

extension VariationsRoomView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return variationHelper?.resultVariations.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OptionsCell.TAG, for: indexPath) as! OptionsCell
        if let variationHelper = variationHelper {
            cell.helper = self.variationHelper
            cell.setDatas(variation: variationHelper.resultVariations[indexPath.row],
                          xSelectedCombination: variationHelper.checkCombination(featureID: variationHelper.resultVariations[indexPath.row].id),
                          resultVariations: variationHelper.resultVariations,
                          combinations: variationHelper.combinations
            )
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let variationHelper = variationHelper else { return VariationHelper.textSize }
        
        let imageRow: Bool = variationHelper.resultVariations[indexPath.row].isImage
        
        if (imageRow) {
            return VariationHelper.imageSize
        }
        return VariationHelper.textSize
    }
}
