//
//  LanguagePage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 20/10/22.
//

import UIKit
import OlchaUI
class LanguagePage: BaseViewController {

    private let table = BaseTableView()
    
    private let languages: [LanguageModel] = [
        .init(key: .ru,
              value: "Русский"),
        .init(key: .oz,
              value: "O’zbekcha")
    ]
    
    override func setupViews() {
        container.addSubview(table)
    }
    
    override func autolayout() {
        table.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureViews() {
        languageUpdated()
        navigation.configure(style: .back)
        
        table.delegate = self
        table.dataSource = self
        table.registerClass(forCell: SelectRoom.self)
        table.configure()
    }
    
    override func languageUpdated() {
        navigation.setTitle("choose_lang".localized())
    }

    
}

extension LanguagePage: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        languages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(SelectRoom.self, for: indexPath)
        cell.setup(with: languages[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        56
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        NotificationHelper.setLangToNotification(languages[indexPath.row].key)
        String.setAppLanguage(languages[indexPath.row].key.rawValue)
        LanguageObserver.shared.observer.send()
        
        tableView.reloadData()
        
    }
}
