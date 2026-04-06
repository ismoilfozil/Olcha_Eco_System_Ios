//
//  String+Regex+Extension.swift
//  OlchaUtils
//
//  Created by Elbek Khasanov on 15/09/23.
//

import Foundation
public extension String {
    func validateText(pattern: String?) -> Bool {
        guard let pattern else { return true }
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: .anchorsMatchLines)
            let range = NSRange(location: 0, length: self.count)
            if let match = regex.firstMatch(in: self, options: [], range: range) {
                return match.range.location == 0 && match.range.length == self.count
            }
            return false
        } catch {
            print("Invalid regex: \(error.localizedDescription)")
            return false
        }
    }
}
