import UIKit
import OlchaUI
import OlchaUtils

extension EcoHomeAppTableCell: CollectionDelegates {
    
//    public var cellWidth: CGFloat { 48 }
//    
//    public var collectionWidth: CGFloat {
//        let cellCount: CGFloat = 5
//        let cellInset: CGFloat = 16
//        return cellWidth * cellCount + (cellCount - 1) * cellInset
//    }
    
    public var items: [EcoHomeViewController.EcoAppService] {
        [.market, /*.sayohat,*/ /*.nasiya,*/ .invest, .pay, /*.cashback, .tv, .food, .myId, .bus*/]
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(EcoHomeAppCollectionCell.self, for: indexPath)
        let cellData = items[indexPath.item]
        cell.setup(with: cellData, isEnabled: cellData.isEnabled)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columnsCount: CGFloat = 5
        let cellWidth = collectionView.frame.width / columnsCount - (collectionView.horizontalInset / columnsCount)
        return CGSize(width: cellWidth, height: Constants.cellHeight)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        appServiceSubject?.send(items[indexPath.item])
    }
    
    public func getMarketCell() -> EcoHomeAppCollectionCell? {
        guard let index = items.firstIndex(of: .market) else { return nil }
        return collection.cellForItem(at: IndexPath(item: index, section: 0)) as? EcoHomeAppCollectionCell
    }
    
}
