//
//  NewsPage+Table.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 06/09/22.
//

import UIKit
extension NewsPage: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        
        switch section {
        case .title:
            let cell = tableView.dequeue(NewsTitleRoom.self, for: indexPath)
            cell.setup(with: blog?.getTitle() ?? "")
            return cell
        case .newsData:
            let cell = tableView.dequeue(NewsDataRoom.self, for: indexPath)
            cell.setup(date: blog?.created_at ?? "", count: blog?.view_amount ?? 0)
            return cell
        case .image:
            let cell = tableView.dequeue(NewsImageRoom.self, for: indexPath)
            cell.setup(with: blog?.getImage() ?? "")
            return cell
        case .content:
            let cell = tableView.dequeue(NewsContentRoom.self, for: indexPath)
            cell.setup(with: blog?.getDescription() ?? "")
            return cell
            
        }
    }
}
