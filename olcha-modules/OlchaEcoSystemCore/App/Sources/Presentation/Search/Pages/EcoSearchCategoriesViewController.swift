import UIKit
import OlchaUI
import OlchaUtils

public class EcoSearchCategoriesViewController: BaseViewController<EmptyNavigationBar> {

    public var categories: [SearchCategoryItem] = []
    public weak var observers: EcoHomeObservers?
    
    private lazy var table: BaseTableView = {
        let table = BaseTableView()
        table.registerClass(forCell: EcoSearchTourTableCell.self)
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

extension EcoSearchCategoriesViewController: TableDelegates {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableWidth = tableView.bounds.width
        let cell = tableView.dequeue(EcoSearchTourTableCell.self, for: indexPath)
        cell.setup(title: categories[indexPath.row].name)
        let isLastCell = (categories.count - 1) == indexPath.row
        cell.configureSeparator(tableWidth: tableWidth, isLastCell: isLastCell)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellData = categories[indexPath.row].click_action
        let action = MarketClickAction.fromRawValue(cellData?.action ?? "", actionId: cellData?.id)
        guard let action else { return }
        observers?.clickActionSubject.send(action)
    }
}
