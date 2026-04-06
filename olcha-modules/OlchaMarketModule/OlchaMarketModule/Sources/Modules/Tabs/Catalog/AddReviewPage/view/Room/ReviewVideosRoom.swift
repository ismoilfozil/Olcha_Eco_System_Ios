//
//  ReviewVideosRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 03/08/22.
//

import UIKit
import Combine
import OlchaUI
import OlchaUtils
class ReviewVideosRoom: BaseTableCell {
    
    private let videosTitle = UILabel()
    private let videosCollection = UICollectionView(frame: .zero, collectionViewLayout: .init())
    private let videosSubtitle = UILabel()
    private var videos: [Video] = []
    
    private let maxCount = 15
    
    private let containerInset: CGFloat = 16.0
    private lazy var width = UIScreen.main.bounds.width - containerInset * 2
    
    weak var presentAddMedia: PassthroughSubject<MediaPicker.MediaType, Never>?
    
    weak var reviewPageViewModel: ReviewsPageViewModel?
    
    weak var playVideo: PassthroughSubject<Video, Never>?
    
    override func setupViews() {
        
        container.addSubview(videosTitle)
        container.addSubview(videosCollection)
        container.addSubview(videosSubtitle)
    }
    
    override func autolayout() {
        horizontalEdge = containerInset
        
        videosTitle.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(videosCollection.snp.top).inset(-8)
        }
        
        videosCollection.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(0)
        }
        
        videosSubtitle.snp.makeConstraints { make in
            make.top.equalTo(videosCollection.snp.bottom).inset(-8)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    override func configureViews() {
        videosTitle.style(.semibold, 18)
        videosTitle.textColor = .olchaTextBlack
        videosTitle.text = "add_video".localized()
        
        videosSubtitle.textColor = .olchaLightTextColornnnnnn
        videosSubtitle.style(.medium, 12)
        videosSubtitle.text = .lang("Осталось 0 из 15",
                                    "",
                                    "")
        
        videosCollection.isScrollEnabled = false
        videosCollection.delegate = self
        videosCollection.dataSource = self
        videosCollection.registerClass(forCell: UploadMediaCell.self)
        videosCollection.registerClass(forCell: UploadNewImageCell.self)
        videosCollection.backgroundColor = .olchaBackgroundColor
        let manager = OtherLayoutManager()
        let width = getCellWidth()
        
        videosCollection.collectionViewLayout = manager.getLayout(with: .vGrid(size: width))
    }
    
    func setup() {
        videos = reviewPageViewModel?.videos ?? []
        videosCollection.reloadData()
        
        videosSubtitle.text = .lang("Осталось \(maxCount-videos.count) из \(maxCount)",
                                    "",
                                    "")
        
        updateLayout()
    }
    
    private func updateLayout() {
        
        let rowsCount: CGFloat = ((videos.count + 1).cgfloat / 4.cgfloat).rounded(.up)
        
        videosCollection.snp.updateConstraints { make in
            make.height.equalTo(getCellWidth() * rowsCount)
        }
        
    }
    
    private func getCellWidth() -> CGFloat {
        return width / 4
    }
    
}

extension ReviewVideosRoom: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if videos.count < maxCount {
            return videos.count + 1
        } else {
            return maxCount
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if videos.count < maxCount && indexPath.item == videos.count {
            let cell = collectionView.dequeue(UploadNewImageCell.self, for: indexPath)
            return cell
        }
        let cell = collectionView.dequeue(UploadMediaCell.self, for: indexPath)
        
        cell.isVideo = true
        if let url = videos[indexPath.item].url {
            let image = Funcs.thumbnailForVideoAtURL(url: url)
            cell.setup(image: image)
        }
        
        cell.removeButton.clicked { [weak self] in
            guard let self = self else { return }
            if (self.reviewPageViewModel?.videos.count ?? 0) > indexPath.item {
                self.reviewPageViewModel?.videos.remove(at: indexPath.item)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if videos.count < maxCount && indexPath.item == videos.count {
            self.presentAddMedia?.send(.video)
        } else {
            self.playVideo?.send(videos[indexPath.item])
        }
    }
}
