//
//  AddImagesView.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 19/10/23.
//

import OlchaUI
import UIKit
import Combine
public class AddImagesView: BaseView {
    private let container = UIView()
    private let imagesTitle = UILabel()
    private let imagesCollection = UICollectionView(frame: .zero, collectionViewLayout: .init())
    private let imagesSubtitle = UILabel()
    private var images: [File] = []
    
    private let maxCount = 5
    
    private let containerInset: CGFloat = 16
    private lazy var width = UIScreen.main.bounds.width - containerInset * 2
    
    weak var presentAddMedia: PassthroughSubject<MediaPicker.MediaType, Never>?
    weak var removeMediaObserver: PassthroughSubject<Int, Never>?
    
    public override func setupViews() {
        addSubview(container)
        container.addSubview(imagesTitle)
        container.addSubview(imagesCollection)
        container.addSubview(imagesSubtitle)
    }
    
    public override func autolayout() {
        container.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(containerInset)
            make.top.bottom.equalToSuperview()
        }
        
        imagesTitle.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(imagesCollection.snp.top).inset(-8)
        }
        
        imagesCollection.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(0)
        }
        
        imagesSubtitle.snp.makeConstraints { make in
            make.top.equalTo(imagesCollection.snp.bottom).inset(-8)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        imagesTitle.style(.semibold, 16)
        imagesTitle.textColor = .olchaTextBlack
        imagesTitle.text = "add_photo".localized()
        
        imagesSubtitle.textColor = .olchaLightTextColornnnnnn
        imagesSubtitle.style(.medium, 12)
        imagesSubtitle.text = .lang("Осталось 0 из 15",
                                    "",
                                    "")
        
        imagesCollection.isScrollEnabled = true
        imagesCollection.delegate = self
        imagesCollection.dataSource = self
        imagesCollection.backgroundColor = .olchaBackgroundColor
        imagesCollection.registerClass(forCell: UploadMediaCell.self)
        imagesCollection.registerClass(forCell: UploadNewImageCell.self)
        
        let manager = OtherLayoutManager()
        let width = getCellWidth()
        
        imagesCollection.collectionViewLayout = manager.getLayout(with: .vGrid(size: width))
    }
    
    public func setup(images: [File]) {
        self.images = images
        imagesCollection.reloadData()
        
        imagesSubtitle.text = .lang("Осталось \(maxCount-images.count) из \(maxCount)",
                                    "\(maxCount) дан \(maxCount-images.count) та қолди",
                                    "\(maxCount) dan \(maxCount-images.count) ta qoldi")
        
        updateLayout()
    }
    
    private func updateLayout() {
        
        let rowsCount: CGFloat = ((images.count + 1).cgfloat / 4.cgfloat).rounded(.up)
        imagesCollection.snp.updateConstraints { make in
            make.height.equalTo(getCellWidth() * rowsCount)
        }
        
    }
    
    private func getCellWidth() -> CGFloat {
        return width / 4
    }
    
}

extension AddImagesView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if images.count < maxCount {
            return images.count + 1
        } else {
            return maxCount
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if images.count < maxCount && indexPath.item == images.count {
            let cell = collectionView.dequeue(UploadNewImageCell.self, for: indexPath)
            return cell
        }
        let cell = collectionView.dequeue(UploadMediaCell.self, for: indexPath)
        cell.setup(with: images[indexPath.item].full_path)
        
        cell.removeButton.clicked { [weak self] in
            guard let self , images.isGreater(indexPath) else { return }
            removeMediaObserver?.send(indexPath.row)
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if images.count < maxCount && indexPath.item == images.count {
            self.presentAddMedia?.send(.image)
        }
    }
}
