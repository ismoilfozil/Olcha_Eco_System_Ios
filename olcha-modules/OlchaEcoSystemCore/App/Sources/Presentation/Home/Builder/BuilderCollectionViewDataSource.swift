import UIKit

public class BuilderCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    public var cellData: [(cellType: BuilderCollectionCell.Type, data: BuilderSectionItem)] = []

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cellData.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let (cellType, data) = cellData[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.classIdentifier, for: indexPath) as? BuilderCollectionCell
        guard let cell = cell else {
            return UICollectionViewCell()
        }
        cell.setup(with: data)
        return cell
    }
}
