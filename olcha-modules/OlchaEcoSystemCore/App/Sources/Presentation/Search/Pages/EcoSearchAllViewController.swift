import UIKit
import OlchaUI
import OlchaUtils

public extension EcoSearchAllViewController {
    struct Input {
        public init() {}
    }
    
    struct Output {
        public var categories: [SearchCategoryItem] = []
        public var brands: [SearchBrandItem] = []
        public var payments: [SearchPaymentItem] = []
        public var products: [SearchProductItem] = []
        
        public init() {}
    }
}

public class EcoSearchAllViewController: BaseViewController<EmptyNavigationBar> {
    
    public weak var observers: EcoHomeObservers?
    
    private lazy var table: BaseTableView = {
        let table = BaseTableView()
        table.registerClass(forCell: EcoSearchTourTableCell.self)
        table.registerClass(forCell: EcoSearchCategoryTableCell.self)
        table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
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

    public init(
        input: Input = .init(),
        output: Output = .init()
    ) {
        self.input = input
        self.output = output
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setupViews() {
        container.addSubview(table)
    }
    
    public override func autolayout() {
        table.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        ignoreNavigationBar = true
    }
    
    public override func initialRequest() {
        table.reloadData()
    }
    
}

extension EcoSearchAllViewController: TableDelegates {
    
    public var sections: [Section] {
        let mappings: [(output: [Any], section: Section)] = [
            (output.products, .products),
            (output.categories, .categories),
            (output.brands, .brands),
            (output.payments, .payments)
        ]
        
        return mappings.compactMap { $0.output.isEmpty ? nil : $0.section }
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .products: return output.products.count
        case .categories: return output.categories.count
        case .brands: return output.brands.count
        case .payments: return output.payments.count
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableWidth = tableView.bounds.width
        switch sections[indexPath.section] {
        case .products:
            let cell = tableView.dequeue(EcoSearchCategoryTableCell.self, for: indexPath)
            let cellData = output.products[indexPath.row]
            cell.setup(title: cellData.name, imageUrl: cellData.main_image)
            let isLastCell = (output.products.count - 1) == indexPath.row
            cell.configureSeparator(tableWidth: tableWidth, isLastCell: isLastCell)
            return cell
        case .categories:
            let cell = tableView.dequeue(EcoSearchTourTableCell.self, for: indexPath)
            cell.setup(title: output.categories[indexPath.row].name)
            return cell
        case .brands:
            let cell = tableView.dequeue(EcoSearchTourTableCell.self, for: indexPath)
            cell.setup(title: output.brands[indexPath.row].name)
            return cell
        case .payments:
            let cell = tableView.dequeue(EcoSearchCategoryTableCell.self, for: indexPath)
            let cellData = output.payments[indexPath.row]
            cell.setup(title: cellData.name, imageUrl: cellData.main_image)
            let isLastCell = (output.payments.count - 1) == indexPath.row
            cell.configureSeparator(tableWidth: tableWidth, isLastCell: isLastCell)
            return cell
        }
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = EcoSearchSectionHeaderView()
        switch sections[section] {
        case .products:
            view.setHeader("search_segment_products".localized(.olchaEcoSystemCore))
        case .categories:
            view.setHeader("search_segment_categories".localized(.olchaEcoSystemCore))
        case .brands:
            view.setHeader("search_segment_brands".localized(.olchaEcoSystemCore))
        case .payments:
            view.setHeader("search_segment_pay".localized(.olchaEcoSystemCore))
        }
        return view
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 34
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var action: ClickAction?
        switch sections[indexPath.section] {
        case .products:
            let cellData = output.products[indexPath.row].click_action
            action = MarketClickAction.fromRawValue(cellData?.action ?? "", actionId: cellData?.id)
            
        case .categories:
            let cellData = output.categories[indexPath.row].click_action
            action = MarketClickAction.fromRawValue(cellData?.action ?? "", actionId: cellData?.id)
        case .brands:
            let cellData = output.brands[indexPath.row].click_action
            action = MarketClickAction.fromRawValue(cellData?.action ?? "", actionId: cellData?.id, alias: cellData?.alias)
        case .payments:
            let cellData = output.payments[indexPath.row].click_action
            action = PayClickAction.fromRawValue(cellData?.action ?? "", actionId: cellData?.id)
        }
        guard let action else { return }
        observers?.clickActionSubject.send(action)
    }
    
    public enum Section: Int {
        case products
        case categories
        case brands
        case payments
    }
    
}
