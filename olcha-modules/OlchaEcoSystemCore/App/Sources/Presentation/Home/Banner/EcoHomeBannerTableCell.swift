import UIKit
import OlchaUI
import OlchaCommon

public class EcoHomeBannerTableCell: BaseTableCell {
    
    public weak var observers: EcoHomeObservers?
    
    public var currentPage: Int = 0 {
        didSet {
            pageControl.currentPage = currentPage
        }
    }
    
    public weak var bannerSkeleton: Skeleton?
    public private(set) var sliders: [BannerModel] = []
    
    private lazy var bannerCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.registerClass(forCell: EcoHomeBannerCollectionCell.self)
        collection.isPagingEnabled = true
        collection.showsHorizontalScrollIndicator = false
        collection.contentInsetAdjustmentBehavior = .never
        collection.backgroundColor = .olchaLightGray
        return collection
    }()
        
    public let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .olchaPrimaryColor
        pageControl.pageIndicatorTintColor = .lightGrayBackground
        pageControl.isEnabled = false
        return pageControl
    }()
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        bannerCollection.collectionViewLayout.invalidateLayout()
    }
    
    public override func setupViews() {
        container.addSubview(bannerCollection)
        container.addSubview(pageControl)
    }
    
    public override func autolayout() {
        container.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-25)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(220)
        }
        bannerCollection.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.height.equalToSuperview()
        }
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().offset(-35)
            make.height.equalTo(6)
        }
    }
    
    public override func configureViews() {
        bannerCollection.delegate = self
        bannerCollection.dataSource = self
        clipsToBounds = false
        contentView.clipsToBounds = false
        container.clipsToBounds = false
    }
    
    public func setup(with banners: BannerData?) {
        sliders = banners?.banners ?? []
        bannerCollection.reloadData()
    }
    
}
