//
//  CollectionFeaturesView.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 12/07/22.
//

import UIKit
import SwiftUI

class CollectionFeaturesView: UIView {
    
    weak var delegate: FeaturesPageDelegate?
    
    enum Section {
        case tags
        case brands
        case features(index: Int)
    }
    
    
    static func height(isExpanded: Bool = false) -> CGFloat {
        var height: CGFloat = 0.0
        
        height += CollectionFeaturesView.featuresCollectionHeight
        
        if isExpanded {
            height += CollectionFeaturesView.expandedTitleLabelHeight
            height += CollectionFeaturesView.expandedTitleLabelBottomInset
        } else {
            height += CollectionFeaturesView.titleLabelHeight
            height += CollectionFeaturesView.titleLabelBottomInset
        }
        
        return height
    }
    
    static let featuresCollectionHeight: CGFloat = 68.0
    static let titleLabelHeight: CGFloat = 20.0
    static let expandedTitleLabelHeight: CGFloat = 24.0
    static let titleLabelBottomInset: CGFloat = 8
    static let expandedTitleLabelBottomInset: CGFloat = 16.0
    
    
    private let featuresCollectionContainer = UIView()
    private let featuresTitleLabel = UILabel()
    private let featuresCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let featuresShowButton = Button()
    
    var isManufacturers = false
    
    var section: Section = .tags
    
    let manager = CatalogLayoutManager()
    
    weak var filters: ProductListFilters? {
        didSet {
            
            switch section {
            case .tags:
                featuresTitleLabel.text = "tags".localized()
                break
            case .brands:
                featuresTitleLabel.text = "brands".localized()
                break
            case .features(let index):
                featuresTitleLabel.text = filters?.features[index].getName()
                configureFeatures(index: index)
                break
            }
            if filters != nil {
//                updateLayout()
                featuresCollection.reloadData()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        baseSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        baseSetup()
    }
    
    private func baseSetup() {
        setupViews()
        autolayout()
        configureViews()
    }
    
    private func setupViews() {
        addSubview(featuresCollectionContainer)
        featuresCollectionContainer.addSubview(featuresTitleLabel)
        featuresCollectionContainer.addSubview(featuresShowButton)
        featuresCollectionContainer.addSubview(featuresCollection)
    }
    private func autolayout() {
        featuresCollectionContainer.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        featuresTitleLabel.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            make.height.equalTo(CollectionFeaturesView.titleLabelHeight)
            make.bottom.equalTo(featuresCollection.snp.top).inset(-CollectionFeaturesView.titleLabelBottomInset)
        }
        
        featuresShowButton.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalTo(self.featuresTitleLabel.snp.centerY)
        }
        
        featuresCollection.snp.remakeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(CollectionFeaturesView.featuresCollectionHeight)
        }
    }
    private func configureViews() {
        featuresTitleLabel.style(.semibold, 14)
        featuresTitleLabel.textColor = .olchaTextBlack
        
        featuresShowButton.titleLabel?.font = .style(.medium, 14)
        featuresShowButton.setTitleColor(.olchaBlue, for: .normal)
        featuresShowButton.setTitle("all".localized(), for: .normal)
        
        
        featuresTitleLabel.text = ""//to do
        configureCollection()
        
    }
    
    private func configureCollection() {
        featuresCollection.backgroundColor = .olchaBackgroundColor
        featuresCollection.delegate = self
        featuresCollection.dataSource = self
        featuresCollection.registerClass(forCell: FilterItem.self)
        featuresCollection.registerClass(forCell: FilterColorItem.self)
        featuresCollection.backgroundColor = .clear
        
        self.featuresCollection.collectionViewLayout = manager.getLayout(with: .filterList)
        
        
        featuresCollection.isScrollEnabled = false
    }
    
    func expandeTitle() {
        featuresTitleLabel.style(.bold, 18)
        featuresTitleLabel.snp.makeConstraints { make in
            make.height.equalTo(CollectionFeaturesView.expandedTitleLabelHeight)
            make.bottom.equalTo(self.featuresCollection.snp.top).inset(-CollectionFeaturesView.expandedTitleLabelBottomInset)
        }
    }
    
    func setFilters(_ filters: ProductListFilters?,
                    _ section: Section
    ) {
        self.section = section
        self.filters = filters
    }
    
    private func updateLayout() {
        let oldHeight = featuresCollection.bounds.height
        featuresCollection.reloadData()
        featuresCollection.layoutIfNeeded()
        DispatchQueue.main.async {
            let newHeight = min(self.featuresCollection.contentSize.height,
                                CollectionFeaturesView.featuresCollectionHeight)
            if oldHeight != newHeight {
                self.featuresCollection.snp.remakeConstraints { make in
                    make.left.bottom.right.equalToSuperview()
                    make.height.equalTo(newHeight)
                }
                self.delegate?.reloadTable()
            }
            
        }
    }

    private func configureFeatures(index: Int) {
        switch filters?.features[index].getFeatureType() {
        case .colour:
            featuresCollection.isScrollEnabled = true
            featuresCollection.collectionViewLayout = manager.getLayout(with: .colorFilterList)
            break
        case .checkbox:
            featuresCollection.isScrollEnabled = true
            featuresCollection.collectionViewLayout = manager.getLayout(with: .filterList)
            break
        default: break
        }
    }
}
