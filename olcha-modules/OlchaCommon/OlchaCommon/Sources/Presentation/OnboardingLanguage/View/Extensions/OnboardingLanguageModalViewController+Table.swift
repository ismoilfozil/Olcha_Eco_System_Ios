//
//  OnboardingLanguageModalViewController+Table.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 15/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

extension OnboardingLanguageModalViewController: TableDelegates {
    
    public var rows: [OnboardingLanguageRow] {
        OnboardingConfigurator.languages
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(OnboardingLanguageTableCell.self, for: indexPath)
        let rowData = rows[indexPath.row]
        cell.setup(with: rowData)
        cell.isChosen = (rowData.key == String.getAppLanguage())
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedLang = rows[indexPath.row].key
        String.setAppLanguage(selectedLang)
        LanguageObserver.shared.observer.send()
        tableView.reloadData()
    }
    
}
