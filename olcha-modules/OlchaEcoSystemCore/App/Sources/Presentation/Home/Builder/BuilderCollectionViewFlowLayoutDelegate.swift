import UIKit
import OlchaUtils

public class BuilderCollectionViewFlowLayoutDelegate: NSObject, UICollectionViewDelegateFlowLayout {
    public var sectionModel: BuilderSection?
    public var module: OlchaModule?
    public var observers: EcoHomeObservers?
    public weak var collectionDataSource: BuilderCollectionViewDataSource?
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch sectionModel?.cellType {
        case is GridBannerCollectionCell.Type:
            let rowsCount = collectionDataSource?.cellData.count ?? 0
            let isOdd = rowsCount % 2 != 0
            let isLast = (rowsCount - 1) == indexPath.row
            let cellWidth = isOdd && isLast ? collectionView.frame.width - 32 : (collectionView.frame.width / 2) - 20
            return CGSize(width: cellWidth, height: 160)
        case is GridCategoryCollectionCell.Type:
            let cellWidth = (collectionView.frame.width / 3) - (collectionView.horizontalInset / 3) - (16 / 3)
            return CGSize(width: cellWidth, height: 104)
        case is VerticalBannerCollectionCell.Type:
            let cellWidth = collectionView.frame.width - collectionView.horizontalInset
            return CGSize(width: cellWidth, height: 160)
        case is HorizontalCategoryCollectionCell.Type:
            return CGSize(width: 88, height: 136)
        default: return .zero
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cellData = collectionDataSource?.cellData[indexPath.row].data else { return }
        var action: ClickAction?
        switch module {
        case .nasiya:
            action = NasiyaClickAction.fromRawValue(cellData.click_action, actionId: cellData.click_action_id?.int)
        case .pay:
            action = PayClickAction.fromRawValue(cellData.click_action, actionId: cellData.click_action_id?.int)
        case .invest:
            action = InvestClickAction.fromRawValue(cellData.click_action, actionId: cellData.click_action_id?.int)
        case .olcha:
            action = MarketClickAction.fromRawValue(cellData.click_action, actionId: cellData.click_action_id?.int)
        default: 
            action = WebviewClickAction.fromRawValue(cellData.click_action, actionId: nil, alias: cellData.deeplink)
        }
        guard let action else { return }
        observers?.clickActionSubject.send(action)
    }
}
