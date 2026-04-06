import UIKit
import OlchaUI
import OlchaUtils

extension LanguageViewController: TableDelegates {
    public var rows: [LanguageRow] {
        [.ru, .oz]
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(LanguageTableCell.self, for: indexPath)
        let rowData = rows[indexPath.row]
        cell.setTitleLabel(rowData.title)
        cell.isChosen = rowData.key == String.getAppLanguage()
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedLang = rows[indexPath.row].key
        String.setAppLanguage(selectedLang)
        LanguageObserver.shared.observer.send()
        tableView.reloadData()
    }
}
