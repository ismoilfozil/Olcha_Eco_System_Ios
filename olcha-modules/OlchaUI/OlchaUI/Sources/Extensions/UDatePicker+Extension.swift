//
//  UDatePicker+Extension.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 23/09/22.
//

import UIKit

public extension UDatePicker {
    func configure(dateString: String?) {
        
        if let birthdate = dateString {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            if let date = formatter.date(from: birthdate) {
                picker.datePicker.date = date
            }
        }
        #warning("Comment")
//        picker.doneButton.setTitle("save".localized(),
//                                   for: .normal)
        
        picker.doneButton.titleLabel?.style(.medium, 18)
        
        picker.height = (widget: 284.0,
                         picker: 240.0,
                         bar: 44.0)
        
        picker.barView.backgroundColor = .olchaLightNeutralGray
        
        if #available(iOS 13.4, *) {
            picker.datePicker.preferredDatePickerStyle = .wheels
        }
        
        picker.datePicker.backgroundColor = .olchaLightNeutralDarkGray
        
        picker.datePicker.alpha = 1
        picker.alpha = 1
    }
}

