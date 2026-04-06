//
//  AddReviewPage+Table.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 02/08/22.
//
import OlchaUI
import UIKit
extension AddReviewPage: UITableViewDelegate, UITableViewDataSource {
    enum Section {
        case rating
        case product
        case productRating
        case shippingRating
        case callRating
        case review
        case anonym
        case images
        case videos
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        getSections().count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 1 {
            let cell = tableView.dequeue(FooterItem.self, for: indexPath)
            cell.responder.withSeparator = false
            return cell
        }
        let section = getSections()[indexPath.section]
        
        switch section {
        case .rating:
            let cell = tableView.dequeue(ReviewIconsRoom.self, for: indexPath)
            cell.observers = observers
            cell.ratingClickedObserver = { [weak self] in
                guard let self = self else { return }
                tableView.reloadData()
                self.observers.checkButtonState.send(true)
            }
            return cell
        case .product:
            let cell = tableView.dequeue(ReviewProductRoom.self, for: indexPath)
            cell.setup(with: product)
            return cell
        case .productRating:
            let cell = tableView.dequeue(ServiceRatingRoom.self, for: indexPath)
            cell.type = .product
            cell.observers = observers
            return cell
        case .shippingRating:
            let cell = tableView.dequeue(ServiceRatingRoom.self, for: indexPath)
            cell.type = .shipping
            cell.observers = observers
            return cell
        case .callRating:
            let cell = tableView.dequeue(ServiceRatingRoom.self, for: indexPath)
            cell.type = .call
            cell.observers = observers
            return cell
        case .review:
            let cell = tableView.dequeue(ReviewFieldRoom.self, for: indexPath)
            cell.observers = observers
            cell.checkValidation()
            return cell
        case .anonym:
            let cell = tableView.dequeue(AnonymReviewRoom.self, for: indexPath)
            cell.checkBox.clicked { [weak self] in
                guard let self = self else { return }
                cell.isAnonym = !cell.isAnonym
                self.observers.isAnonym = cell.isAnonym
            }
            return cell
        case .images:
            let cell = tableView.dequeue(ReviewImagesRoom.self, for: indexPath)
            cell.reviewPageViewModel = viewModel
            cell.presentAddMedia = presentAddMedia
            cell.setup()
            return cell
        case .videos:
            let cell = tableView.dequeue(ReviewVideosRoom.self, for: indexPath)
            cell.reviewPageViewModel = viewModel
            cell.presentAddMedia = presentAddMedia
            cell.playVideo = playVideoObserver
            cell.setup()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
            return 24.0
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func getSections() -> [AddReviewPage.Section] {
        
        switch type {
        case .add:
            return addReviewSections
        case .edit:
            return editReviewSections
        }
        
    }
}
