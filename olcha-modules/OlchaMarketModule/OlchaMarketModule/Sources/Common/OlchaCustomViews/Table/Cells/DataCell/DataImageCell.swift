//
//  DataImageCell.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 21/02/24.
//

import UIKit

class DataImageCell: UICollectionViewCell {

    //MARK: - Properties
    public enum Properties {
        static let verticalMargin: CGFloat = 2
        static let horizontalMargin: CGFloat = 2
        static let imageSize: CGFloat = 60
        
        static var cellSize: CGFloat {
            imageSize + horizontalMargin*2
        }
    }
    
    let imageViewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .olchaLightGray
        view.round(8)
        return view
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
//        label.adjustsFontSizeToFitWidth = true
        return imageView
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        imageViewContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageViewContainer)
        imageViewContainer.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
        
        imageViewContainer.snp.makeConstraints { make in
            
            make.width.height.equalTo(Properties.cellSize)
            make.edges.equalToSuperview().inset(Properties.horizontalMargin)
            
        }
        
    }
    
    func configure(_ viewModel: DataCellViewModel){
        self.imageView.load(from: viewModel.stringRepresentation)
//        self.contentView.backgroundColor = .white
    }
}
