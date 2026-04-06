import UIKit
import OlchaUI

public struct ActualItem: Codable {
    public var image_url: String?
    public var title: String?
    public var click_action: ClickActionDict?
}

public struct ClickActionDict: Codable {
    public var id: String?
    public var action: String?
}

public class EcoSearchActualTableCell: BaseTableCell {
    
    public var currentPage: Int = 0 {
        didSet {
            pageControl.currentPage = currentPage
        }
    }
    
    private var collectionDataSource: [ActualItem] = []
    
    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        return stack
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 18)
        label.textColor = .olchaBlackNeutral
        return label
    }()
    
    private lazy var collection: BaseCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.minimumLineSpacing = Constants.cellSpacing
        layout.scrollDirection = .horizontal
        let collection = BaseCollectionView(frame: .zero, collectionViewLayout: layout)
        collection.registerClass(forCell: EcoSearchActualCollectionCell.self)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        collection.isPagingEnabled = true
        return collection
    }()
    
    public let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .olchaPrimaryColor
        pageControl.pageIndicatorTintColor = .olchaLightPrimaryRed
        pageControl.isEnabled = false
        return pageControl
    }()
    
    public override func setupViews() {
        container.addSubview(contentStack)
        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(collection)
        contentStack.addArrangedSubview(pageControl)
    }
    
    public override func autolayout() {
        contentStack.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(20)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        collection.snp.makeConstraints { make in
            make.height.equalTo(76)
            make.left.right.equalToSuperview()
        }
        pageControl.snp.makeConstraints { make in
            make.height.equalTo(6)
        }
    }
    
    public override func configureViews() {
        container.round(24)
        titleLabel.text = "search_actual_title".localized(.olchaEcoSystemCore)
        collection.reloadData()
    }
    
}

extension EcoSearchActualTableCell: CollectionDelegates {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfPages = collectionDataSource.count.cgfloat / Constants.numberOfColumns
        pageControl.numberOfPages = Int(numberOfPages.rounded(.up))
        pageControl.isHidden = !(pageControl.numberOfPages > 1)
        return collectionDataSource.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(EcoSearchActualCollectionCell.self, for: indexPath)
        cell.setup(with: collectionDataSource[indexPath.item])
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.frame.width - Constants.getSpacingSum) / Constants.numberOfColumns
        return CGSize(width: cellWidth, height: Constants.cellHeight)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let itemsCount = CGFloat(integerLiteral: collectionDataSource.count)
        let spacingSum = Constants.getSpacingSum
        let cellWidth = (collectionView.frame.width - spacingSum) / Constants.numberOfColumns
        let horizontalInset = collectionView.frame.width - (cellWidth * itemsCount.truncatingRemainder(dividingBy: 4))
        let shouldAddRightInset = itemsCount > 4 && itemsCount.truncatingRemainder(dividingBy: 4) != 0
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: shouldAddRightInset ? horizontalInset : .zero)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageFloat: CGFloat = scrollView.contentOffset.x / scrollView.frame.size.width
        currentPage = Int(pageFloat.rounded(.up))
    }
}

public extension EcoSearchActualTableCell {
    struct Constants {
        public static let cellHeight: CGFloat = 74.0
        public static let cellWidth: CGFloat = 88.0
        public static let cellSpacing: CGFloat = 4.0
        public static let numberOfColumns: CGFloat = 4.0
        
        public static var getSpacingSum: CGFloat {
            Constants.cellSpacing * Constants.cellSpacing
        }
    }
}
