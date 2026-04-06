//
//  UIColor+Extension.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 30/06/22.
//

import UIKit
import OlchaUtils
public extension UIColor {
    static func resolve(name: String, route: BundleType = .resources) -> UIColor? {
        return .init(named: name, in: Bundle(identifier: route.identifier), compatibleWith: nil)
    }
    ///#EB1537
    static let olchaAccentColor = resolve(name: "olchaAccentColor") ?? .red ///#EB1537
    
    ///#0e32670a
    static let productAlphaColor: UIColor = .hex("#0e32670a") ///#0e32670a
    
    ///#DA002B
    static let olchaPrimaryColor = resolve(name: "olchaAccentColor") ?? .red ///#DA002B
    
    ///#E0E0E0
    static let olchaGray = resolve(name: "olchaGray")///#E0E0E0
    
    ///#111111
    static let olchaTextBlack = resolve(name: "olchaTextBlack") ?? .black ///#111111
    
    static let olchaWhite = UIColor.white
    
    static let olchaCardWhite = UIColor.white
    
    static let olchaBackgroundColor = UIColor.white
    
    ///#999999
    static let olchaLightTextColornnnnnn = resolve(name: "olchaLightTextColor")///#999999
    
    ///#4D4D4D
    static let olchaNeutral700 = resolve(name: "olchaNeutral700")
    
    ///#FFD740
    static let olchaYellow = resolve(name: "olchaYellow")///#FFD740
    
    ///#FEFE02
    static let olchaLightYellow: UIColor = .hex("#FEFE02")///#FEFE02
    
    ///#F2F2F2
    static let olchaLightNeutralGray = resolve(name: "olchaLightNeutralGray")///#F2F2F2
    
    ///#12BF6C
    static let olchaGreen = resolve(name: "olchaGreen")///#12BF6C
    
    ///#14AE5C
    static let olchaLightGreen = UIColor.hex("#14AE5C")///#14AE5C
    
    static let olchaLightBlue = resolve(name: "olchaLightBlue")///#CED9E5
    
    ///#E8E8E8
    static let olchaLightNeutralDarkGray = resolve(name: "olchaLightNeutralDarkGray")///#E8E8E8
    
    ///#EBEBEB
    static let lightGray1 = UIColor.hex("#EBEBEB")///#EBEBEB
    
    ///#007AFF
    static let olchaBlue = resolve(name: "olchaBlue")///#007AFF
    
    ///#F8F8F8
    static let olchaLightGray = resolve(name: "olchaLightGray")///#F8F8F8
    
    ///#FAFAFA
    static let lightGrayBackground = resolve(name: "lightGrayBackground")///#FAFAFA
    
    ///#FD8200
    static let olchaOrange = resolve(name: "olchaOrange")///#FD8200
    
    ///#818181
    static let olchaDarkGray = resolve(name: "olchaDarkGray")///#818181
    
    ///#E2E2E2
    static let lightGrayBackground1 = resolve(name: "lightGrayBackground1")///#E2E2E2
    
    ///#F9F9F9
    static let grayBackground = resolve(name: "grayBackground")///#F9F9F9
    
    ///#6A6A6A
    static let olchaDarkNeutralGray = resolve(name: "olchaDarkNeutralGray")///#6A6A6A

    
    
    ///#C4C4C4
    static let grayBorder = resolve(name: "grayBorder")///#C4C4C4
    ///#7600EC
    static let olchaPurple = resolve(name: "olchaPurple")///#7600EC
    
    static let olchaBlackNeutral = resolve(name: "olchaBlackNeutral")///#2F2F2F
    
    ///#FFF3E6
    static let olchaLightOrangeGradient = resolve(name: "olchaLightOrangeGradient")
    
    static func hex(_ hexString: String) -> UIColor {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        return .init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
}

public extension UIColor {
    ///#3B82F6
    static let olchaInfoColor = resolve(name: "olchaInfoColor")
    ///#DDFCED
    static let olchaLightGreenGradient = resolve(name: "olchaLightGreenGradient")
    ///#FDE047
    static let bonusProgressColor = resolve(name: "bonus-progress-color")
}
