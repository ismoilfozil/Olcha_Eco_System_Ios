//
//  MenuButton.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 10/09/22.
//


import UIKit

public class MenuButton: UIView {
    
    
    private let maxCount: CGFloat = 6

    private let table = BaseTableView()

    public let settings = IButton()

    public let cellHeight: CGFloat = 36
    
    public var height: CGFloat = 0 {
        didSet {
            updateAutolayout()
        }
    }
    
    public var openMenu: Bool = false {
        didSet {
            table.setContentOffset(.zero, animated: false)
            updateAutolayout()
        }
    }
    
    public var items: [String] = []
    
    public var selectedIndex: ((Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        baseSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        baseSetup()
    }
    
    private func baseSetup() {
        setupViews()
        autolayout()
        configureViews()
    }
    
    private func setupViews() {
        
        addSubview(settings)
        addSubview(table)
        
    }

    private func autolayout() {
        
        
        settings.snp.remakeConstraints { make in
            make.top.right.left.equalToSuperview()
            make.height.equalTo(height)
        }
        
        table.snp.remakeConstraints { make in
            let maxTableHeight = cellHeight * maxCount + cellHeight / 2
            let currentHeight = cellHeight * items.count.cgfloat
            let tableHeight = min(currentHeight, maxTableHeight)
            
            make.height.equalTo(openMenu ? tableHeight : 0)
            make.top.equalTo(settings.snp.bottom).inset(-8)
            make.left.right.bottom.equalToSuperview()
        }
    }

    
    private func updateAutolayout() {
        
        table.isHidden = (items.isEmpty && !openMenu)
        
        settings.snp.remakeConstraints { make in
            make.top.right.left.equalToSuperview()
            make.height.equalTo(height)
        }
        
        table.snp.remakeConstraints { make in
            let maxTableHeight = cellHeight * maxCount + cellHeight / 2
            let currentHeight = cellHeight * items.count.cgfloat
            let tableHeight = min(currentHeight, maxTableHeight)
            
            make.height.equalTo(openMenu ? tableHeight : 0)
            make.top.equalTo(settings.snp.bottom).inset(-8)
            make.left.right.bottom.equalToSuperview()
        }
        table.reloadData()
        table.separatorStyle = .none
        table.separatorColor = .clear
    }
    
    private func configureViews() {
        settings.backgroundColor = .clear
        table.delegate = self
        table.dataSource = self
        table.registerClass(forCell: TitleLabelRoom.self)
        table.configure()
        table.darkBorder()
        table.round()
        table.showsVerticalScrollIndicator = false
        openMenu = false
    }
}
