//
//  String+Extension.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 30/06/22.
//

import UIKit
import SwiftSoup
import OlchaCore

//extension String {
//    public static var utilsLanguage: String? = ""
//    
//    public func localized() -> String {
//        return self.baseLocalized(lang: .utilsLanguage)
//    }
//
//    public static func lang(_ ru: String?, _ uz: String?, _ oz: String?) -> String {
//        return .baseLang(ru, uz, oz, lang: .utilsLanguage)
//    }
//}


public extension String {
    
    
    static let phonePlaceholder = "(       )         -       -"
    
    
    
    
    var digitString: String { filter { ("0"..."9").contains($0) } }
    
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
    
    var int: Int {
        Int(self) ?? 0
    }
    
    var double: Double {
        Double(self) ?? 0.0
    }
    
    var isNumber: Bool {
        let digitsCharacters = CharacterSet(charactersIn: "0123456789")
        return CharacterSet(charactersIn: self).isSubset(of: digitsCharacters)
    }
    
    var withoutSpace: String {
        self.replacingOccurrences(of: " ", with: "")
    }
    
    var striked: NSAttributedString {
        let attributeString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(
            .strikethroughStyle,
            value: NSUnderlineStyle.single.rawValue,
            range:NSMakeRange(0,attributeString.length))
        return attributeString
    }
    
    var htmlTrimmer: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        return self
            .replacingOccurrences(of: "<br />", with: "\n\n")
            .replacingOccurrences(of: "<br/>", with: "\n")
            .replacingOccurrences(of: "<br>", with: "\n")
            .replacingOccurrences(of: "<p>", with: "\n")
            .replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
    var phoneNumber: String {
        self.replacingOccurrences( of:"[^0-9]", with: "", options: .regularExpression)
            .replacingOccurrences(of: " ", with: "")
    }
    
    var formatPhoneNumber: String {
        return .format(with: "(XX) XXX-XX-XX", phone: self)
    }
    
    var formatShortPhoneNumber: String {
        if self.starts(with: "998") {
            if self.count == "998901234567".count {
                return self[3..<self.count].formatPhoneNumber
            }
        } else {
            if self.count == "901234567".count {
                return self.formatPhoneNumber
            }
        }
        return self
    }
    
    var formatFullPhoneNumber: String {
        return .format(with: "+XXX (XX) XXX-XX-XX", phone: self)
    }
    
    var formatPhoneNumberCharacter: String {
        return .formatNumbers(with: "XXX (XX) XXX-XX-XX", phone: self)
    }
    
    var formatMobilePhoneNumber: String {
        
        if !self.starts(with: "+998 ") {
            return "+998 " + self
        }
        
        if !self.starts(with: "+998") {
            return " " + self
        }
        
        if !self.starts(with: "+99") {
            return "8" + self
        }
        
        if !self.starts(with: "+9") {
            return "98" + self
        }
        
        if !self.starts(with: "+") {
            return "998" + self
        }
        
        if !self.starts(with: "") {
            return "+998" + self
        }
        
        return self
    }
    
    var makeReadableCardNumber: String {
        var formattedCardNumber = String()
        for (index, character) in self.enumerated() {
            formattedCardNumber += String(character)
            formattedCardNumber += ([3, 7, 11].contains(index)) ? " " : ""
        }
        return formattedCardNumber
    }
    
    var hideCardNumber: String {
        var formattedCardNumber = String()
        for (index, character) in self.enumerated() {
            if [4,5,6,7,8,9,10,11].contains(index) {
                formattedCardNumber += "*"
            } else {
                formattedCardNumber += String(character)
            }
            
            formattedCardNumber += ([3, 7, 11].contains(index)) ? " " : ""
        }
        return formattedCardNumber
    }
    

    var day_month: String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd-MM-yyyy HH:mm"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd MMM"
        var dateString = ""
        if let date = dateFormatterGet.date(from: self) {
            dateString = dateFormatterPrint.string(from: date)
        }
        
        return dateString
    }
    
    var formated_date: String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        guard let datePart = (self.split(separator: "T").first) else { return " - " }

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd.MM.yyyy"
        var dateString = ""
        if let date = dateFormatterGet.date(from: String(datePart)) {
            dateString = dateFormatterPrint.string(from: date)
        }
        
        return dateString
    }
    
    
    var formated_date_time: String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd-MM-yyyy HH:mm"
        var dateString = ""
        if let date = dateFormatterGet.date(from: self) {
            dateString = dateFormatterPrint.string(from: date)
        }
        
        return dateString
    }
    
    var withoutWhiteSpace: String {
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    var price: String {
        return originalPriceWithoutCurrency + " " + Texts.currency
    }

    var originalPrice: String {
        return originalPriceWithoutCurrency + " " + Texts.currency
    }

    
    var originalPriceDouble: String {
        return priceWithoutCurrencyDouble + " " + Texts.currency
    }
    
    var originalPriceWithoutCurrency: String {
        let priceDouble = Double(self) ?? 0
        return (Formatter.originalWithSeparator.string(for: priceDouble) ?? "")
    }
    
    var priceWithoutCurrency: String {
        let priceInt = Int(self) ?? 0
        return (Formatter.withSeparator.string(for: priceInt) ?? "")
    }
    
    var priceWithoutCurrencyDouble: String {
        let priceDouble = Double(self) ?? 0
        return (Formatter.withSeparator.string(for: priceDouble) ?? "")
    }

    func concat(prefix: String, extras: [String]) -> String {
        var newValue = self
        
        for extra in extras {
            if extra != "" {
                newValue += prefix + extra
            }
        }
        
        return newValue
    }
    
    
    
    
//    func height(width: CGFloat, font: UIFont = .style(.regular, 14)) -> CGFloat {
//        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
//            label.numberOfLines = 0
//            label.text = self
//            label.font = font
//            label.sizeToFit()
//        return label.frame.height
//    }
    
    /// mask example: `+XXX (XX) XXX-XX-XX`
    static func format(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                
                result.append(numbers[index])
                
                index = numbers.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    /// mask example: `+XXX (XX) XXX-XX-XX`
    static func formatNumbers(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: " ", with: "")
        var result = ""
        var index = numbers.startIndex
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                
                result.append(numbers[index])
                
                index = numbers.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    static func random(length: Int = 20) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
    
    func htmlToAttributedString(textColor: UIColor?, font: UIFont?) -> NSMutableAttributedString {
        guard let data = data(using: .utf8) else {
            let atributedString = NSMutableAttributedString(string: "")
            return atributedString
        }
        do {
            let atributedString = try NSAttributedString(data: data,
                                                         options: [.documentType: NSAttributedString.DocumentType.html,
                                                                   .characterEncoding: String.Encoding.utf8.rawValue,
                                                                  ], documentAttributes:
                                                            nil)

            let atributes = [NSAttributedString.Key.font: font,
                             NSAttributedString.Key.foregroundColor: textColor]



            let mutableString: NSMutableAttributedString = NSMutableAttributedString(attributedString: atributedString)
            mutableString.addAttributes(atributes, range: NSRange(location: 0,
                                                                  length: atributedString.length))

            return mutableString
        } catch {
            print("catched_err:\(error)")
            let atributedString = NSAttributedString(string: "")

            let mutableString: NSMutableAttributedString = NSMutableAttributedString(attributedString: atributedString)
            return mutableString
        }
    }
    
    
//    var htmlToAttributedStringWithoutFont: NSMutableAttributedString {
//        guard let data = data(using: .utf8) else {
//            let atributedString = NSMutableAttributedString(string: "")
//            return atributedString
//        }
//        do {
//            let atributedString = try NSAttributedString(data: data,
//                                                         options: [
//                                                            .documentType: NSAttributedString.DocumentType.html,
//                                                            .characterEncoding: String.Encoding.utf8.rawValue,
//                                                                  ],
//                                                         documentAttributes: nil)
//
//            var atributes = [NSAttributedString.Key.font: UIFont.style(.semibold, 16),
//                             NSAttributedString.Key.foregroundColor: UIColor.olchaTextBlack]
//            atributes.removeAll()
//
//
//
//
//            let mutableString: NSMutableAttributedString = NSMutableAttributedString(attributedString: atributedString)
//            mutableString.addAttributes(atributes, range: NSRange(location: 0,
    //                                                                  length: atributedString.length))
    //
    //            return mutableString
    //        } catch {
    //            let atributedString = NSAttributedString(string: "")
    //
    //            let mutableString: NSMutableAttributedString = NSMutableAttributedString(attributedString: atributedString)
    //            return mutableString
    //        }
    //    }
    
    
    //    var htmlToString: String {
    //        return htmlToAttributedString.string ?? ""
    //    }
    
    init?(htmlEncodedString: String) {

        guard let data = htmlEncodedString.data(using: .utf8) else {
            return nil
        }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return nil
        }

        self.init(attributedString.string)
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(count, r.lowerBound)),
                                            upper: min(count, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        let rangeLast: Range<Index> = start..<end
        return String(self[rangeLast])
    }
    
    subscript (r: CountableClosedRange<Int>) -> String {
        let startIndex =  self.index(self.startIndex, offsetBy: r.lowerBound)
        let endIndex = self.index(startIndex, offsetBy: r.upperBound - r.lowerBound)
        return String(self[startIndex...endIndex])
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    func formatDate(_ format: (input: String,output: String)) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = format.input

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = format.output
        var dateString = ""
        if let date = dateFormatterGet.date(from: self) {
            dateString = dateFormatterPrint.string(from: date)
        }
        
        return dateString
    }
    
    func filterOtherTags(removeBR: Bool = true) -> String {
        //        <\/?(?!br>)\w+[^>]*>
        do {
            
            let whiteList = try Whitelist.basic()
            try whiteList.addTags("a",
                                  "p",
                                  "ul",
                                  "li",
                                  "u",
                                  "i",
                                  "b",
                                  "ol",
                                  "br",
                                  "h1",
                                  "h2",
                                  "h3",
                                  "h4",
                                  "h5",
                                  "h6"
            )
            
            try whiteList.addAttributes("a",
                                        "href")
            if removeBR == true {
                try whiteList.removeTags("br")
            }
            try whiteList.removeTags("img")
            let safe : String = try SwiftSoup.clean(self, whiteList) ?? self
            
            return safe
        } catch {
            return self
        }
        
    }
    
    
    var makeReadableExpireDateForCard: String {
        if self.count > 2 {
            let month = self[0..<2]
            let year = self[2..<self.count]

            return month + "/" + year
        } else {
            return self
        }
    }
    
}

public extension String {
    
    fileprivate static let ANYONE_CHAR_UPPER = "X"
    fileprivate static let ONLY_CHAR_UPPER = "C"
    fileprivate static let ONLY_NUMBER_UPPER = "N"
    fileprivate static let ANYONE_CHAR = "x"
    fileprivate static let ONLY_CHAR = "c"
    fileprivate static let ONLY_NUMBER = "n"
    
    func format(_ format: String, oldString: String) -> String {
        let stringUnformated = self.unformat(format, oldString: oldString)
        var newString = String()
        var counter = 0
        if stringUnformated.count == counter {
            return newString
        }
        for i in 0..<format.count {
            var stringToAdd = ""
            let unicharFormatString = format[i]
            let charFormatString = unicharFormatString
            let charFormatStringUpper = unicharFormatString.uppercased()
            let unicharString = stringUnformated[counter]
            let charString = unicharString
            let charStringUpper = unicharString.uppercased()
            if charFormatString == String.ANYONE_CHAR {
                stringToAdd = charString
                counter += 1
            } else if charFormatString == String.ANYONE_CHAR_UPPER {
                stringToAdd = charStringUpper
                counter += 1
            } else if charFormatString == String.ONLY_CHAR_UPPER {
                counter += 1
                if charStringUpper.isChar() {
                    stringToAdd = charStringUpper
                }
            } else if charFormatString == String.ONLY_CHAR {
                counter += 1
                if charString.isChar() {
                    stringToAdd = charString
                }
            } else if charFormatStringUpper == String.ONLY_NUMBER_UPPER {
                counter += 1
                if charString.isNumber {
                    stringToAdd = charString
                }
            } else {
                stringToAdd = charFormatString
            }
            
            newString += stringToAdd
            if counter == stringUnformated.count {
                if i == format.count - 2 {
                    let lastUnicharFormatString = format[i + 1]
                    let lastCharFormatStringUpper = lastUnicharFormatString.uppercased()
                    let lasrCharControl = (!(lastCharFormatStringUpper == String.ONLY_CHAR_UPPER) &&
                                           !(lastCharFormatStringUpper == String.ONLY_NUMBER_UPPER) &&
                                           !(lastCharFormatStringUpper == String.ANYONE_CHAR_UPPER))
                    if lasrCharControl {
                        newString += lastUnicharFormatString
                    }
                }
                break
            }
        }
        return newString
    }
    
    func unformat(_ format: String, oldString: String) -> String {
        var string: String = self
        var undefineChars = [String]()
        for i in 0..<format.count {
            let unicharFormatString = format[i]
            let charFormatString = unicharFormatString
            let charFormatStringUpper = unicharFormatString.uppercased()
            if !(charFormatStringUpper == String.ANYONE_CHAR_UPPER) &&
                !(charFormatStringUpper == String.ONLY_CHAR_UPPER) &&
                !(charFormatStringUpper == String.ONLY_NUMBER_UPPER) {
                var control = false
                for i in 0..<undefineChars.count {
                    if undefineChars[i] == charFormatString {
                        control = true
                    }
                }
                if !control {
                    undefineChars.append(charFormatString)
                }
            }
        }
        if oldString.count - 1 == string.count {
            var changeCharIndex = 0
            for i in 0..<string.count {
                let unicharString = string[i]
                let charString = unicharString
                let unicharString2 = oldString[i]
                let charString2 = unicharString2
                if charString != charString2 {
                    changeCharIndex = i
                    break
                }
            }
            let changedUnicharString = oldString[changeCharIndex]
            let changedCharString = changedUnicharString
            var control = false
            for i in 0..<undefineChars.count {
                if changedCharString == undefineChars[i] {
                    control = true
                    break
                }
            }
            if control {
                var i = changeCharIndex - 1
                while i >= 0 {
                    let findUnicharString = oldString[i]
                    let findCharString = findUnicharString
                    var control2 = false
                    for j in 0..<undefineChars.count {
                        if findCharString == undefineChars[j] {
                            control2 = true
                            break
                        }
                    }
                    if !control2 {
                        string = (oldString as NSString).replacingCharacters(in: NSRange(location: i, length: 1), with: "")
                        break
                    }
                    i -= 1
                }
            }
        }
        for i in 0..<undefineChars.count {
            string = string.replacingOccurrences(of: undefineChars[i], with: "")
        }
        return string
    }
    
    fileprivate func isChar() -> Bool {
        return regexControlString(pattern: "[a-zA-ZğüşöçıİĞÜŞÖÇ]")
    }
    
    
    fileprivate func regexControlString(pattern: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let numberOfMatches = regex.numberOfMatches(in: self, options: [], range: NSRange(location: 0, length: self.count))
            return numberOfMatches == self.count
        } catch {
            return false
        }
    }
    
    var isValidHtmlString: Bool {
        if self.isEmpty {
            return false
        }
        return (self.range(of: "<(\"[^\"]*\"|'[^']*'|[^'\">])*>", options: .regularExpression) != nil)
    }

}
