//
//  SmallProductCell.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 30/06/22.
//

import UIKit
import SkeletonView
import Combine
import OlchaUI
class ProductCell: BaseCollectionCell {
    
    private var bag = Set<AnyCancellable>()
    var skeletonEnabled: Bool = false
    
    enum CellType {
        case shrink
        case expand
    }
    
    var isCreditItem: Bool = false
    
    public let imageSize: CGFloat = 236
    let soldContainer: SoldContainer = {
        let view = SoldContainer()
        view.backgroundColor = .white.withAlphaComponent(0.5)
        return view
    }()
    //MARK: - UI ELEMENTS
    private let contentContainer: UIView = {
        let view = UIView()
        view.round()
        view.backgroundColor = .olchaWhite
        return view
    }()
    private let imageContainer: UIView = {
        let view = UIView()
        view.round(16)
        return view
    }()
    lazy var imagesCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.registerClass(forCell: ImageItem.self)
        collection.isPagingEnabled = true
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()
    let imagesPageControl: PageControl = {
        let pageControl = PageControl()
        pageControl.setupSized(totalPage: 1)
        return pageControl
    }()
    let discountContainer: UIView = {
        let view = UIView()
        view.round(6)
        view.isHidden = true
        view.backgroundColor = .olchaAccentColor
        return view
    }()
    let discountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .olchaWhite
        label.style(.medium, 10)
        label.textAlignment = .center
        return label
    }()
    let adultChecker = AdultChecker(withTitle: true)
    let productTitleContainer = UIView()
    let productTitle: UITextView = {
        let textView = UITextView()
        textView.font = .style(.medium, 12)
        textView.textContainer.maximumNumberOfLines = 2
        textView.textColor = .olchaTextBlack
        textView.textContainer.lineBreakMode = .byTruncatingTail
        textView.disable()
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        return textView
    }()
    
    let datasContainer = UIView()
    
    let likeButton: IconButton = {
        let button = IconButton()
        button.setIcon(.unliked,
                        isIgnoringEdge: true)
        button.round(11)
        return button
    }()
    
    let compareButton: IconButton = {
        let button = IconButton()
        button.setIcon(.compare_out,
                       isIgnoringEdge: true)
        button.round(11)
        return button
    }()
    
    let giftIcon: IconButton = {
        let button = IconButton()
        button.backgroundColor = .olchaAccentColor
        button.setIcon(.gift?.withColor(.olchaWhite),
                         edgeSize: 2,
                         isIgnoringEdge: false)
        button.round(10)
        button.isHidden = true
        return button
    }()
    
    let productOldPrice: UILabel = {
        let label = UILabel()
        label.style(.medium, 10.0)
        label.textColor = .olchaLightTextColornnnnnn
        return label
    }()
    
    let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        return stackView
    }()
    
    let productPrice: UILabel = {
        let label = UILabel()
        label.style(.bold, 12)
        label.textColor = .olchaTextBlack
        return label
    }()
    
    let productPermonthPriceStack: UIStackView = {
        let stackView = UIStackView()
        stackView.isHidden = true
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 2, left: 4, bottom: 2, right: 4)
        stackView.backgroundColor = .olchaLightYellow
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .leading
        stackView.round(6)
        return stackView
    }()
    
    let productPermonthPrice: Label = {
        let label = Label()
        label.settings.style(.semibold, 10.0)
        label.settings.textColor = .olchaTextBlack
        label.isHidden = true
        label.text = " "
        label.verticalInset = 0
        return label
    }()
    
    let withoutPercentTitle: Label = {
        let label = Label()
        label.backgroundColor = .olchaWhite
        label.round(4)
        label.settings.textColor = .olchaAccentColor
        label.settings.style(.semibold, 10)
        label.horizontalInset = 8
        label.verticalInset = 0
        label.isHidden = true
        label.text = " "
        return label
    }()
    
    let cashback: CashbackView = {
        let view = CashbackView()
        view.isHidden = true
        return view
    }()
    
    let addCartButton: CartButtonProtocol = CircleCartButton()
    
    var cellType: CellType = .shrink
    var favouriteRemoving: (() -> Void)?
    
    //MARK: - PROPERTIES
    private var withSeparator = false
    weak var productHelper: ProductHelper?
    var product: ProductModel?
    var images: [String] = [] {
        didSet {
            imagesPageControl.setupSized(totalPage: images.count)
            imagesCollection.reloadData()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        images = []
    }
    
    private var isLiked: Bool = false {
        didSet {
            likeButton.setIcon(isLiked ? .liked : .unliked,
                               isIgnoringEdge: true)
            product?.is_like = isLiked
        }
    }
    private var isCompared: Bool = false {
        didSet {
            compareButton.setIcon(isCompared ? .compare_out_selected : .compare_out,
                                  isIgnoringEdge: true)
            product?.is_compared = isCompared
        }
    }
    
    func setup(with data: ProductModel?) {
        
        staticTexts()
        product = data
        isLiked = data?.is_like ?? false
        isCompared = data?.is_compared ?? false
        
        images = data?.images ?? []
        
        productTitle.text = data?.getName()
        
        productTitle.sizeToFit()
        productPrice.text = data?.total_price?.price
        
        calculateOldPrice()
        calculateCreditText()
        leftBadgeState()
        checkGiftExisting()
        checkCartButtonStack()
        checkCashback()
        adultChecker.check(data)
    }
    ///needs configure header issue to animate this
    
    
    override func skeletonFinished() {
        if let product = product {
            productTitle.text = product.getName()
            productTitle.sizeToFit()
            productPrice.text = product.total_price?.price
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        productTitleContainer.layoutSkeletonIfNeeded()
//        productTitle.layoutSkeletonIfNeeded()
//        productPrice.layoutSkeletonIfNeeded()
//        productOldPrice.layoutSkeletonIfNeeded()
//        productPermonthPrice.layoutSkeletonIfNeeded()
        
        ///cellni type o'zgarganiga textlar qo'yilmayapti, shunga qaytadan tekshirilgan, to'g'rilanishi kerak
        if contentContainer.bounds.width > (UIScreen.main.bounds.width / 1.3) {
            configure(with: .expand, withSeparator: self.withSeparator)
        } else {
            configure(with: .shrink, withSeparator: self.withSeparator)
        }
    }
    
    
    
    func configure(with type: CellType, withSeparator: Bool = false) {
        
        self.withSeparator = withSeparator
        
        cellType = type
        imagesCollection.collectionViewLayout = getLayout()
        imagesCollection.reloadData()
        type == .shrink ? shrink() : expand()
        
    }
    
    override func setupViews() {
        container.removeFromSuperview()
        addSubview(contentContainer)
        contentContainer.addSubview(imageContainer)
        addSubview(discountContainer)
        discountContainer.addSubview(discountLabel)
        addSubview(giftIcon)
        contentContainer.addSubview(datasContainer)
        contentContainer.addSubview(withoutPercentTitle)
        datasContainer.addSubview(productTitleContainer)
        productTitleContainer.addSubview(productTitle)
        datasContainer.addSubview(priceStackView)
        
        priceStackView.addArrangedSubview(productOldPrice)
        priceStackView.addArrangedSubview(productPrice)
        priceStackView.addArrangedSubview(productPermonthPriceStack)
        priceStackView.addArrangedSubview(cashback)
        
        productPermonthPriceStack.addArrangedSubview(productPermonthPrice)
        
        contentContainer.addSubview(addCartButton)
        imageContainer.addSubview(imagesCollection)
        imageContainer.addSubview(imagesPageControl)
        imageContainer.addSubview(adultChecker)
        contentContainer.addSubview(soldContainer)
        
        addSubview(likeButton)
        addSubview(compareButton)
        enableSeparators(for: contentContainer)
    }
    
    override func configureViews() {
        observers()
        skeletonConfiguration()
    }
    
    override func cellWillAppear() {
        checkCartButtonStack()
    }
    
    private func observers() {
        likeButton.clicked { [weak self] in
            guard let self = self,
                  let id = self.product?.id else { return }
            CartViewModel.shared.addFavourites(product: self.product, isAdding: !self.isLiked)
            self.favouriteRemoving?()
            if !self.isLiked {
                MetricEvents.shared.addToFavourites(self.product)
            }
        }
        
        compareButton.clicked { [weak self] in
            guard let self,
                  let id = product?.id else { return }
            if isCompared {
                CompareViewModel.shared.removeCompare(product: product)
            } else {
                CompareViewModel.shared.addToCompare(product: product)
            }
        }
        
        CartViewModel
            .shared
            .$favouriteChangedID
            .sink { [weak self] productID in
                guard let self = self,
                      let productID = productID else { return }
                if productID == self.product?.id {
                    self.isLiked = !self.isLiked
                }
            }.store(in: &bag)
        
        CompareViewModel
            .shared
            .$compareProduct
            .sink { [weak self] value in
                guard let self, let id = value?.product?.id else { return }
                if id == self.product?.id {
                    self.isCompared = value?.isAdded ?? false
                }
            }.store(in: &bag)
        
        addCartButton
            .countButton
            .$countClicked
            .sink { [weak self] type in
                guard let self = self,
                      self.product?.cart_count != self.addCartButton.count else { return }
                
                MetricEvents.shared.cartEvent(self.product, type: type)
                
                
                CartViewModel.shared.cartChangeCount(productID: self.product?.id,
                                                     storeID: self.product?.getStoreID(),
                                                     quantity: self.addCartButton.count,
                                                     type: type)
                
            }.store(in: &bag)
        
        CartViewModel
            .shared
            .cartItemChanged
            .sink { [weak self] cartItem in
                guard let self = self else { return }
                
                if cartItem?.product_id == self.product?.id && cartItem?.store_id == self.product?.getStoreID() {
                    self.product?.cart_count = cartItem?.quantity ?? 0
                    self.addCartButton.countButton.count = cartItem?.quantity ?? 0
                }
                
            }.store(in: &bag)
        
        addCartButton
            .parentPush
            .sink { [weak self] isPushing in
                guard let self = self, isPushing else { return }
                self.productHelper?.pushParentProduct.send(self.product)
            }.store(in: &bag)
    }
    
    private func skeletonConfiguration() {
        
        makeSkeleton(views: [
            imageContainer,
            productTitle,
            productPermonthPriceStack,
            productOldPrice,
            productPrice,
            addCartButton
        ])
        
        productTitle.skeletonConfiguration(lines: .custom(2),
                                           height: .fixed(18),
                                           space: 4)
        
        productOldPrice.skeletonConfiguration(lines: .custom(1),
                                              lastLinePercentage: 40,
                                              height: .fixed(12),
                                              space: 0)
        
        productPrice.skeletonConfiguration(lines: .custom(1),
                                           lastLinePercentage: 80,
                                           height: .fixed(20),
                                           space: 0)
        
        productPermonthPrice.isHiddenWhenSkeletonIsActive = true
        withoutPercentTitle.isHiddenWhenSkeletonIsActive = true
        productPermonthPriceStack.isHiddenWhenSkeletonIsActive = true
        
    }
    
    func staticTexts() {
        addCartButton.setup()
    }
    
    override func autolayout() {
        
        contentContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        imagesPageControl.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview().inset(6)
//            make.width.equalTo(50)
            make.height.equalTo(12)
        }
        imagesCollection.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        adultChecker.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        productTitleContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(8)
        }
        productTitle.snp.makeConstraints { make in
            make.bottom.left.right.top.equalToSuperview()
        }
        withoutPercentTitle.snp.makeConstraints { make in
            make.height.equalTo(14)
            make.left.equalTo(discountContainer.snp.left)
            make.bottom.equalTo(imagesPageControl.snp.bottom)
        }
        soldContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        shrink()
    }
    
    private func shrink() {
        imageContainer.snp.remakeConstraints { make in
            make.top.equalToSuperview().inset(18)
            make.left.right.equalToSuperview().inset(8)
            make.height.equalTo(imageSize)
        }
        datasContainer.snp.remakeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalTo(addCartButton.snp.left).inset(-2)
            make.top.equalTo(imageContainer.snp.bottom)
            make.bottom.equalToSuperview().inset(-4)
        }
        priceStackView.snp.remakeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.right.equalTo(addCartButton.snp.left).inset(-2)
            make.top.equalTo(productTitleContainer.snp.bottom).inset(-4)
            make.bottom.equalToSuperview().inset(16)
        }
        addCartButton.snp.remakeConstraints { make in
            make.bottom.equalTo(priceStackView.snp.bottom)
            make.right.equalTo(imageContainer.snp.right)
        }
        discountContainer.snp.remakeConstraints { make in
            make.top.equalTo(imageContainer.snp.top).inset(4)
            make.left.equalTo(imageContainer.snp.left).inset(4)
        }
        discountLabel.snp.remakeConstraints { make in
            make.top.bottom.equalToSuperview().inset(2)
            make.left.right.equalToSuperview().inset(8)
        }
        likeButton.snp.remakeConstraints { make in
            make.top.equalTo(imageContainer.snp.top).inset(4)
            make.right.equalTo(imageContainer.snp.right).inset(4)
            make.width.height.equalTo(28)
        }
        compareButton.snp.remakeConstraints { make in
            make.top.equalTo(likeButton.snp.bottom).inset(-12)
            make.right.equalTo(imageContainer.snp.right).inset(4)
            make.width.height.equalTo(28)
        }
        giftIcon.snp.remakeConstraints { make in
            make.width.height.equalTo(20)
            make.bottom.equalTo(imageContainer.snp.bottom).inset(-6)
            make.right.equalTo(imageContainer.snp.right).inset(-6)
        }
//        addCartButton.isHidden = false
        contentContainer.border(with: .clear, width: 0)
        contentContainer.round(0)
    }
    
    private func expand() {
        
        addCartButton.isHidden = true
        imageContainer.snp.remakeConstraints { make in
            make.left.equalToSuperview().inset(12)
            make.top.bottom.equalToSuperview().inset(12)
            make.width.equalTo(imageContainer.snp.height)
            make.centerY.equalToSuperview()
        }
        
        datasContainer.snp.remakeConstraints { make in
            make.left.equalTo(imageContainer.snp.right).inset(-8)
            make.top.right.bottom.equalToSuperview()
        }
        
        priceStackView.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(8)
            make.top.greaterThanOrEqualTo(productTitleContainer.snp.bottom)
            make.bottom.equalToSuperview().inset(12)
        }
        
        addCartButton.snp.remakeConstraints { make in
            make.height.width.equalTo(0)
        }
        
        let iconsEdge: CGFloat = -4
        
        discountContainer.snp.remakeConstraints { make in
            make.top.equalTo(imageContainer.snp.top)
            make.left.equalTo(imageContainer.snp.left)
        }
        
        discountLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(2)
            make.left.right.equalToSuperview().inset(8)
        }
        
        likeButton.snp.remakeConstraints { make in
            make.top.equalTo(imageContainer.snp.top).inset(iconsEdge)
            make.right.equalTo(imageContainer.snp.right).inset(iconsEdge)
            make.width.height.equalTo(22)
        }
        
        compareButton.snp.remakeConstraints { make in
            make.top.equalTo(likeButton.snp.bottom).inset(-12)
            make.right.equalTo(imageContainer.snp.right).inset(iconsEdge)
            make.width.height.equalTo(22)
        }
        
        giftIcon.snp.makeConstraints { make in
            make.width.height.equalTo(28)
            make.bottom.equalTo(imageContainer.snp.bottom).inset(iconsEdge)
            make.right.equalTo(imageContainer.snp.right).inset(iconsEdge)
        }
        
        contentContainer.border(with: .clear, width: 0)
        contentContainer.round()
    }
    
    private func getLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        return layout
    }
}
