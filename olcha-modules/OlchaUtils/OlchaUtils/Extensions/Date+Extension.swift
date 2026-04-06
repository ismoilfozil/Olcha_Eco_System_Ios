//
//  Date+Extension.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 23/09/22.
//

import Foundation
public extension Date {
    
    public static let dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    var string: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
    
    var date_string: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: self)
    }
    
    var currentDate: String {
        let date = date_string
        return date.formatDate((Date.dateFormat, "dd-MM-yyyy"))
    }
}
