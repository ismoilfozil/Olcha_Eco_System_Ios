//
//  OptionsCell.swift
//  NewOlcha
//
//  Created by Muhammadjon on 2/15/21.
//

import UIKit
import OlchaUI
class OptionsCell: BaseTableCell {
    static let imageSize: CGFloat = 56
    
    static let TAG = "OptionsCell"
    
    private let titleLabel = UILabel()
    
    private let valueLabel = UILabel()
    private let optionsCV = UICollectionView(frame: .zero, collectionViewLayout: .init())
    private let separator = UIView()
    
    
    var collectionViewFlowLayout: UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        
        // edit properties here
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        flowLayout.minimumInteritemSpacing = 16
        // edit properties here
        
        return flowLayout
    }
    
    weak var helper: VariationHelper?
    
    var values: [VariationData] = []
    var variationID: Int?
    var selectedValueID: Int?
    
    var pressed: Bool = false
    
    var maskCombination: [Int: Int] = [:]
    var combinations: [String: Combination] = [:]
    var variations: [GetVariationData] = []
    
    override func setupViews() {
        container.addSubview(titleLabel)
        container.addSubview(valueLabel)
        container.addSubview(optionsCV)
        container.addSubview(separator)
    }
    
    override func autolayout() {
        self.titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(8)
            make.bottom.equalTo(self.optionsCV.snp.top).inset(-16)
        }
        
        self.valueLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.bottom.top.equalTo(self.titleLabel)
            make.left.equalTo(self.titleLabel.snp.right).inset(-8)
        }
        
        self.optionsCV.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.separator.snp.top).inset(-8)
        }
        
        self.separator.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
    }
    
    override func configureViews() {
        self.titleLabel.style(.medium, 14)
        self.titleLabel.textColor = .olchaDarkGray
        self.valueLabel.style(.medium, 14)
        self.valueLabel.textColor = .olchaTextBlack
        self.optionsCV.delegate = self
        self.optionsCV.dataSource = self
        
        self.optionsCV.collectionViewLayout = collectionViewFlowLayout
        self.optionsCV.registerClass(forCell: ProductOptionCell.self)
        self.optionsCV.showsHorizontalScrollIndicator = false
        self.optionsCV.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        self.separator.backgroundColor = .lightGrayBackground
    }
    
    
    
    
    func setDatas(variation: GetVariationData,
                  xSelectedCombination: [Int: Int],
                  resultVariations: [GetVariationData],
                  combinations: [String: Combination]
    ) {
        
        
        self.variations = resultVariations
        self.combinations = combinations
        self.maskCombination = xSelectedCombination
        
        self.titleLabel.text = variation.getName() + ":"
        valueLabel.text = nil
        for defaultVal in variation.data ?? [] {
            if defaultVal.active == true {
                self.valueLabel.text = defaultVal.getFeatureValueName()
            }
        }
        
        
        self.variationID = variation.id
        self.values = variation.data ?? []
        
        self.optionsCV.reloadData()
    }
    
    
    
}

extension OptionsCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        values.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(ProductOptionCell.self, for: indexPath)
        cell.setDatas(data: values[indexPath.row])
        if let id = values[indexPath.row].feature_value_id {
            if let helper = helper {
                let state = helper.getCombination(from: combinations,
                                                  variations: variations,
                                                  currentID: id,
                                                  maskCombinations: maskCombination)
                cell.track(state: state,
                           isActive: values[indexPath.row].active)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let imageRow: Bool = !(values[indexPath.item].images?.isEmpty ?? true)
        if (imageRow) {
            return CGSize(width: OptionsCell.imageSize, height: OptionsCell.imageSize)
        }
        
        let string: String = values[indexPath.row].getFeatureValueName()
        
        let label = UILabel()
        label.style(.medium, 16)
        label.text = string
        label.sizeToFit()
        return CGSize(width: label.frame.size.width + 34, height: label.frame.size.height + 16)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? ProductOptionCell else { return }
        
        guard cell.combinationState != .disabled else { return }
        
        valueLabel.text = values[indexPath.row].getFeatureValueName()
        
        
        for i in 0..<values.count {
            values[i].active = false
            if i == indexPath.row {
                values[i].active = true
            }
        }
        
        helper?.variation(id: self.variationID, valueID: values[indexPath.row].feature_value_id)
        
        self.optionsCV.reloadData()
    }
}


