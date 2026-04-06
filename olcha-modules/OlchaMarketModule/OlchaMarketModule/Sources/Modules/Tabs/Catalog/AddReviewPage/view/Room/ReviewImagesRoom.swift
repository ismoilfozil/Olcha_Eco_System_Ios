//
//  ReviewImagesRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 02/08/22.
//

import UIKit
import OlchaUI
import Combine
class ReviewImagesRoom: BaseTableCell {
    
    private let imagesTitle = UILabel()
    private let imagesCollection = UICollectionView(frame: .zero, collectionViewLayout: .init())
    private let imagesSubtitle = UILabel()
    private var images: [File] = []
    
    private let maxCount = 5
    
    private let containerInset: CGFloat = 16.0
    private lazy var width = UIScreen.main.bounds.width - containerInset * 2
    
    weak var presentAddMedia: PassthroughSubject<MediaPicker.MediaType, Never>?
    
    
    weak var reviewPageViewModel: ReviewsPageViewModel?
    
    override func setupViews() {
        
        container.addSubview(imagesTitle)
        container.addSubview(imagesCollection)
        container.addSubview(imagesSubtitle)
    }
    
    override func autolayout() {
        horizontalEdge = containerInset
        
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
    
    override func configureViews() {
        imagesTitle.style(.semibold, 18)
        imagesTitle.textColor = .olchaTextBlack
        imagesTitle.text = "add_photo".localized()
        
        imagesSubtitle.textColor = .olchaLightTextColornnnnnn
        imagesSubtitle.style(.medium, 12)
        imagesSubtitle.text = .lang("Осталось 0 из 15",
                                    "",
                                    "")
        
        imagesCollection.isScrollEnabled = false
        imagesCollection.delegate = self
        imagesCollection.dataSource = self
        imagesCollection.backgroundColor = .olchaBackgroundColor
        imagesCollection.registerClass(forCell: UploadMediaCell.self)
        imagesCollection.registerClass(forCell: UploadNewImageCell.self)
        
        let manager = OtherLayoutManager()
        let width = getCellWidth()
        
        imagesCollection.collectionViewLayout = manager.getLayout(with: .vGrid(size: width))
    }
    
    func setup() {
        images = reviewPageViewModel?.images ?? []
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

extension ReviewImagesRoom: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if images.count < maxCount {
            return images.count + 1
        } else {
            return maxCount
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if images.count < maxCount && indexPath.item == images.count {
            let cell = collectionView.dequeue(UploadNewImageCell.self, for: indexPath)
            return cell
        }
        let cell = collectionView.dequeue(UploadMediaCell.self, for: indexPath)
        cell.setup(with: images[indexPath.item].full_path)
        cell.isUploading = false
        cell.removeButton.clicked { [weak self] in
            guard let self = self else { return }
            if (reviewPageViewModel?.images.isGreater(indexPath) ?? false) {
                self.reviewPageViewModel?.images.remove(at: indexPath.item)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if images.count < maxCount && indexPath.item == images.count {
            self.presentAddMedia?.send(.image)
        }
    }
    
    
}
