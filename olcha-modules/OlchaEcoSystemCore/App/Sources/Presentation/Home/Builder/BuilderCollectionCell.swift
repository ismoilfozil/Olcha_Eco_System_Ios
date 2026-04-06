import UIKit

public struct BuilderCollectionModel {
    public var image_url: String
    public var title: String
    public var click_action: String
    public var background_color: String
}

public protocol BuilderCollectionCell: UICollectionViewCell {
    func setup(with data: BuilderSectionItem)
}
