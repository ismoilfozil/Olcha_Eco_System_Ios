//
//  InvestProfitViewController+History.swift
//  OlchaInvestCore
//
//  Created by Elbek Khasanov on 11/05/24.
//  Copyright © 2024 Olcha. All rights reserved.
//

import UIKit
extension InvestProfitViewController {
    func createHistory() {
        historyStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for historyModel in self.historyModels {
            let view = createHistoryItem(model: historyModel)
            historyStackView.addArrangedSubview(view)
            view.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
            }
        }
    }
    
    private func createHistoryItem(model: InvestProfitHistoryModel) -> UIView {
        let view = InvestProfitHistoryView()
        view.setup(model: model)
        return view
    }
}
