import UIKit
import OlchaUI
import OlchaCore

public class EcoSearchViewController: BaseViewController<SearchNavigationBar> {
    
    private var viewControllers: [UIViewController] = []
    
    private let segmentControl = ScrollableSegmentedControl()
    
    private lazy var pageViewController: UIPageViewController = {
        let pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageVC.delegate = self
        pageVC.dataSource = self
        pageVC.view.isHidden = true
        return pageVC
    }()
    
    private lazy var table: BaseTableView = {
        let table = BaseTableView()
        table.registerClass(forCell: EcoSearchActualTableCell.self)
        table.registerClass(forCell: EcoSearchHistoryTableCell.self)
        table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = .lightGrayBackground
        if #available(iOS 15.0, *) {
            table.sectionHeaderTopPadding = 0
        }
        return table
    }()
    
    public var input: Input
    public var output: Output
    public let viewModel: EcoSearchViewModel
    public weak var coordinator: EcoSearchCoordinatorProtocol?
    public var backButtonHidden = false {
        didSet {
            navigationBar.backButtonHidden = backButtonHidden
        }
    }

    init(
        viewModel: EcoSearchViewModel,
        input: Input = .init(),
        output: Output = .init()
    ) {
        self.viewModel = viewModel
        self.input = input
        self.output = output
        super.init()
        setupSearchObservers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationBar.searchView.textField.becomeFirstResponder()
    }
    
    public override func setupViews() {
        addChild(pageViewController)
        container.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)

        container.addSubview(segmentControl)
        container.addSubview(table)
    }
    
    public override func autolayout() {
        segmentControl.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.width.greaterThanOrEqualToSuperview().priority(.required)
            make.width.equalTo(UIScreen.width).priority(.high)
        }
        table.snp.makeConstraints { make in
            make.top.bottom.horizontalEdges.equalToSuperview()
        }
        pageViewController.view.snp.makeConstraints { make in
            make.top.equalTo(segmentControl.snp.bottom).offset(8)
            make.bottom.horizontalEdges.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        configurePlaceholder()
    }
    
    public override func languageUpdated() {
        navigationBar.searchView.setPlaceholder()
        table.reloadData()
        placeholder.setupTitle("search_empty_placeholder".localized(.olchaEcoSystemCore))
    }
    
    public override func setupObservers() {
        output.observers.clickActionSubject.sink(receiveValue: { [weak self] action in
            guard let self else { return }
            coordinator?.clickActionRouter(action: action)
        }).store(in: &bag)

        segmentControl.segmentSelected = { [weak self] index in
            guard let self, viewModel.searchResults != .loading, index != input.currentPageIndex else { return }
            let direction: UIPageViewController.NavigationDirection = index > input.currentPageIndex ? .forward : .reverse
            pageViewController.setViewControllers([viewControllers[index]], direction: direction, animated: true)
            input.currentPageIndex = index
        }
        viewModel.search()
        handle(viewModel.$searchResults, showLoader: true, success: { [weak self] data in
            guard let self, let data else { return }
            var segmentTitles: [String] = []
            viewControllers.removeAll()
            input.currentPageIndex = 0
            
            if !data.products.isEmpty {
                let products = EcoSearchProductsViewController()
                products.products = data.products
                products.observers = output.observers
                segmentTitles.append("search_segment_products".localized(.olchaEcoSystemCore))
                viewControllers.append(products)
            }
            if !data.categories.isEmpty {
                let categories = EcoSearchCategoriesViewController()
                categories.categories = data.categories
                categories.observers = output.observers
                segmentTitles.append("search_segment_categories".localized(.olchaEcoSystemCore))
                viewControllers.append(categories)
            }
            if !data.manufacturers.isEmpty {
                let brands = EcoSearchBrandsViewController()
                brands.brands = data.manufacturers
                brands.observers = output.observers
                segmentTitles.append("search_segment_brands".localized(.olchaEcoSystemCore))
                viewControllers.append(brands)
            }
            if !data.olcha_pay.isEmpty {
                let payments = EcoSearchPayViewController()
                payments.payments = data.olcha_pay
                payments.observers = output.observers
                segmentTitles.append("search_segment_pay".localized(.olchaEcoSystemCore))
                viewControllers.append(payments)
            }
            table.isHidden = !viewControllers.isEmpty
            pageViewController.view.isHidden = viewControllers.isEmpty
            if !viewControllers.isEmpty {
                let all = EcoSearchAllViewController()
                all.output.brands = data.manufacturers
                all.output.categories = data.categories
                all.output.payments = data.olcha_pay
                all.output.products = data.products
                all.observers = output.observers
                segmentTitles.insert("search_segment_all".localized(.olchaEcoSystemCore), at: 0)
                viewControllers.insert(all, at: 0)
                disablePlaceholder()
                segmentControl.setupSegment(titles: segmentTitles)
                pageViewController.setViewControllers(
                    [viewControllers[input.currentPageIndex]],
                    direction: .forward, animated: false
                )
            } else {
                enablePlaceholder()
            }
        })
    }
    
}

private extension EcoSearchViewController {
    func configurePlaceholder() {
        placeholder.setupImage(.emptySearch)
        placeholder.titleLabel.style(.semibold, 28)
        placeholder.imageView.contentMode = .scaleAspectFit
        placeholder.mainButton.isHidden = true
    }
    
    func setupSearchObservers() {
        let searchField = navigationBar.searchView.textField
        searchField.addTarget(self, action: #selector(textFieldEditing), for: .editingChanged)
        searchField.addTarget(self, action: #selector(textFieldEdited), for: .editingDidEnd)
        searchField.delegate = self
        searchField.returnKeyType = .search
        searchField.autocorrectionType = .no
    }
    
    @objc func textFieldEditing(_ sender: UITextField) {
        guard let text = sender.text else { return }
        viewModel.searchSubject.send(text)
        table.isHidden = !(sender.text?.isEmpty ?? false)
    }
    
    @objc func textFieldEdited(_ sender: UITextField) {
        guard let text = sender.text, text != "" else { return }
        EcoGlobalDefaults.search.add(history: text)
    }
}

extension EcoSearchViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, text != "" else { return true }
        EcoGlobalDefaults.search.add(history: text)
        return true
    }
}

public extension EcoSearchViewController {
    struct Input {
        public var history: [String] {
            EcoGlobalDefaults.search.histories ?? []
        }
        public var currentPageIndex: Int = 0
        
        public init() {}
    }
    
    struct Output {
        public var observers = EcoHomeObservers()
        
        public init() {}
    }
}

extension EcoSearchViewController: UIPageViewControllerDataSource {
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = viewControllers.firstIndex(of: viewController) else {
            return nil
        }
        guard currentIndex > 0 else { return nil }
        return viewControllers[currentIndex - 1]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = viewControllers.firstIndex(of: viewController) else {
            return nil
        }
        guard currentIndex < viewControllers.count - 1 else { return nil }
        return viewControllers[currentIndex + 1]
    }
    
    public func updateSegmentedControl() {
        segmentControl.setSelectedSegmentIndex(input.currentPageIndex, animated: true)
    }
}

extension EcoSearchViewController: UIPageViewControllerDelegate {
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else { return }
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = viewControllers.firstIndex(of: currentViewController) {
            input.currentPageIndex = currentIndex
            updateSegmentedControl()
        }
    }
}
