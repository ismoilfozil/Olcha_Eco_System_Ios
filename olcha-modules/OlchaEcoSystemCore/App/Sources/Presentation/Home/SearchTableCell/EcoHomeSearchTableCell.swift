import UIKit
import OlchaUI

public class EcoHomeSearchTableCell: BaseTableCell {
    
    private let searchBar: SearchView = {
        let search = SearchView()
        search.setPlaceholder("home_search_placeholder".localized(.olchaEcoSystemCore))
        search.setContainerRadius(radius: 18)
        search.textField.isEnabled = false
        return search
    }()
    
    public override func setupViews() {
        container.addSubview(searchBar)
    }
    
    public override func autolayout() {
        verticalEdge = 10
        searchBar.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.left.right.equalToSuperview().inset(16)
            make.verticalEdges.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        container.backgroundColor = .clear
    }
    
    public func setup() {
        searchBar.setPlaceholder("home_search_placeholder".localized(.olchaEcoSystemCore))
    }
    
}
