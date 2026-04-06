import UIKit
import OlchaUI

extension EcoSearchViewController: TableDelegates {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .actual: return 0
        case .history: return input.history.count
        default: return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableWidth = tableView.bounds.width
        switch sections[indexPath.section] {
        case .actual:
            let cell = tableView.dequeue(EcoSearchActualTableCell.self, for: indexPath)
            cell.configureSeparator(tableWidth: tableWidth, isLastCell: true)
            return cell
        case .history:
            let cell = tableView.dequeue(EcoSearchHistoryTableCell.self, for: indexPath)
            cell.setup(title: input.history[indexPath.row])
            cell.closeIconObserver = {
                EcoGlobalDefaults.search.remove(index: indexPath.row)
                tableView.reloadSections([indexPath.section], with: .fade)
            }
            let isLastCell = (input.history.count - 1) == indexPath.row
            cell.configureSeparator(tableWidth: tableWidth, isLastCell: isLastCell)
            return cell
        default: return UITableViewCell()
        }
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch sections[section] {
        case .history:
            let view = EcoSearchHistoryHeaderView()
            view.setClearButton {
                EcoGlobalDefaults.search.removeAll()
                tableView.reloadSections([section], with: .fade)
            }
            return view
        default: return nil
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch sections[section] {
        case .actual:
            return 0
        default:
            return 34
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sections[indexPath.section] {
        case .history:
            let searchField = navigationBar.searchView.textField
            searchField.text = input.history[indexPath.row]
            searchField.sendActions(for: .editingChanged)
        default: break
        }
    }
    
}

public extension EcoSearchViewController {
    var sections: [Section] {
        [.history]
    }
    
    enum Section: Int {
        case history
        case products
        case tours
        case markets
        case actual
    }
}
