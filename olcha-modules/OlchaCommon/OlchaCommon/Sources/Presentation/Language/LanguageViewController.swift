import UIKit
import OlchaUI
import OlchaUtils

public class LanguageViewController: BaseViewController<TitleNavigationBar> {
    
    private lazy var table: BaseTableView = {
        let table = BaseTableView()
        table.delegate = self
        table.dataSource = self
        table.separatorInset = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
        table.registerClass(forCell: LanguageTableCell.self)
        return table
    }()
    
    var tabNames: [String] {
        CommonConfigurator.shared.tabNames
    }
    var bundleType: BundleType {
        CommonConfigurator.shared.bundle
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
        var row = IndexPath(row: 0, section: 0)
        switch Language(rawValue: String.getAppLanguage()) {
        case .oz: row.row = 1
        default: break
        }
        table.selectRow(at: row, animated: true, scrollPosition: .none)
        languageUpdated()
    }
    
    public override func languageUpdated() {
        navigationBar.setTitle("language_heading".localized(.common))
        table.reloadData()
        updateTabNames()
    }
    
    public override func updateTabNames() {
        guard let items = self.tabBarController?.tabBar.items else { return }
        for i in 0..<min(items.count, tabNames.count) {
            items[i].title = tabNames[i].localized(bundleType)
        }
    }
    
}
