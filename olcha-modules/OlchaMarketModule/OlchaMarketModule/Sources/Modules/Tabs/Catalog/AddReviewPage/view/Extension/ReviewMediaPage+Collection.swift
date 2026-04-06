//
//  ReviewMediaPage+Collection.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 01/08/22.
//
import Zoomy
import UIKit
import OlchaUI
import OlchaUtils
extension ReviewMediaPage: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return files.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = files[indexPath.item]
        let url = URL(string: item.full_path ?? "")
        loadMore(index: indexPath.item)
        if collectionView == paginationCollection {
            let cell = collectionView.dequeue(CorneredImage.self, for: indexPath)
            cell.cornerRadius = 2
            cell.selectedStyle = (indexPath.item == currentFile)
            
            if item.mime_type == MediaPicker.MediaMimeType.video.rawValue {
                if let url = url {
                    cell.setup(image: Funcs.thumbnailForVideoAtURL(url: url))
                }
            } else {
                cell.setup(with: item.full_path)
            }
            
            
            return cell
        } else {
            let cell = collectionView.dequeue(ReviewMediaImage.self, for: indexPath)
            if item.mime_type == MediaPicker.MediaMimeType.video.rawValue {
                if let url = url {
                    let video = Video(data: NSData(contentsOf: url) as Data?, url: url)
                    cell.setup(video: video)
                }
            } else {
                
                cell.setup(with: files[indexPath.item].full_path)
                
                addZoombehavior(for: cell.imageView, in: cell, settings: .backgroundEnabledSettings)
            }
            
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == mediaCollection {
            return collectionView.frame.size
        } else {
            return .zero
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page: Int = .page(offset: scrollView.contentOffset, collection: mediaCollection) ?? 0
        if currentFile != page {
            currentFile = page
            paginationCollection.reloadData()
            paginationCollection.scrollToItem(at: .init(item: page, section: 0), at: [], animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == paginationCollection {
            if currentFile != indexPath.item {
                currentFile = indexPath.item
                
                mediaCollection.scrollToItem(at: .init(item: indexPath.item, section: 0), at: .centeredHorizontally, animated: true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? ReviewMediaImage {
            cell.playVideo()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? ReviewMediaImage {
            cell.stopVideo()
        }
    }
}
