//
//  ButtonMenus.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 08/07/22.
//


import UIKit
public protocol ButtonMenusDelegate: AnyObject {
    func selected(sort: SortItem)
}
class ButtonMenus: UIView {
    
    private let container = UIView()
    private let table = UITableView()
    private var data: [SortItem] = []
    
    let cellHeight: CGFloat = 32
    
    weak var delegate: ButtonMenusDelegate?
    
    var selectedSort: SortItem?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        autolayout()
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupViews() {
        self.addSubview(container)
        self.container.addSubview(table)
    }
    
    private func autolayout() {
        self.container.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        self.table.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview().inset(4)
        }
    }
    
    private func configureViews() {
        self.table.delegate = self
        self.table.dataSource = self
        self.table.registerClass(forCell: MenuItemCell.self)
        self.table.separatorStyle = .none
        self.table.separatorColor = .clear
        self.table.backgroundColor = .clear
        self.table.isScrollEnabled = false
        self.container.round(8)
        self.container.backgroundColor = .olchaLightNeutralGray
        self.container.darkBorder()
        container.backgroundColor = .olchaWhite
    }
    
    
    
    func menuItems(_ items: [SortItem], _ selectedSort: SortItem) {
        self.selectedSort = selectedSort
        self.data = items
        self.table.reloadData()
    }
}

extension ButtonMenus: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(MenuItemCell.self, for: indexPath)
        let item = self.data[indexPath.row]
        cell.setup(with: item.text,
                   isSelected: item.key == selectedSort?.key)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        cellHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.delegate?.selected(sort: self.data[indexPath.row])
    }
}
