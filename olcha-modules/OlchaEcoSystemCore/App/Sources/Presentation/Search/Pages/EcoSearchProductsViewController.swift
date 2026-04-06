import UIKit
import OlchaUI
import OlchaUtils

public class EcoSearchProductsViewController: BaseViewController<EmptyNavigationBar> {

    public var products: [SearchProductItem] = []
    public weak var observers: EcoHomeObservers?
    
    private lazy var table: BaseTableView = {
        let table = BaseTableView()
        table.registerClass(forCell: EcoSearchCategoryTableCell.self)
        table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = .lightGrayBackground
        if #available(iOS 15.0, *) {
            table.sectionHeaderTopPadding = 0
        }
        return table
    }()
    
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
    
}

extension EcoSearchProductsViewController: TableDelegates {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableWidth = tableView.bounds.width
        let cell = tableView.dequeue(EcoSearchCategoryTableCell.self, for: indexPath)
        let cellData = products[indexPath.row]
        cell.setup(title: cellData.name, imageUrl: cellData.main_image)
        let isLastCell = (products.count - 1) == indexPath.row
        cell.configureSeparator(tableWidth: tableWidth, isLastCell: isLastCell)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellData = products[indexPath.row].click_action
        let action = MarketClickAction.fromRawValue(cellData?.action ?? "", actionId: cellData?.id)
        guard let action else { return }
        observers?.clickActionSubject.send(action)
    }
    
}
