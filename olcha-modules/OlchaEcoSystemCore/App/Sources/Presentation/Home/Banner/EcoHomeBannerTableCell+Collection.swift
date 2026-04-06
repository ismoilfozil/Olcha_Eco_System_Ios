import UIKit
import OlchaUI
import OlchaUtils
import OlchaCommon

extension EcoHomeBannerTableCell: CollectionDelegates {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = bannerSkeleton?.getCount(sliders.count) ?? 0
        pageControl.numberOfPages = count
        return count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(EcoHomeBannerCollectionCell.self, for: indexPath)
        cell.configure(skeleton: bannerSkeleton)
        guard sliders.isGreater(indexPath) else {
            cell.prepareForReuse()
            return cell
        }
        cell.setup(with: sliders[indexPath.item])
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard sliders.isGreater(indexPath) else { return }
        send(banner: sliders[indexPath.row])
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageFloat: CGFloat = scrollView.contentOffset.x / scrollView.frame.size.width
        currentPage = Int(pageFloat.rounded())
    }
    
    private func send(banner: BannerModel?) {
        guard let action = banner?.getAction() else { return }
        observers?.clickActionSubject.send(action)
    }
}
