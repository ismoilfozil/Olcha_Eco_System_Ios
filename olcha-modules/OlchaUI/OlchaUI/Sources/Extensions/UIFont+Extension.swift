//
//  UIFont+Extension.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 30/06/22.
//


import UIKit
import OlchaUtils
public extension UIFont {
    
    static func registerAllFonts() {
        registerFont(bundleType: .resources, font: .semibold)
        registerFont(bundleType: .resources, font: .bold)
        registerFont(bundleType: .resources, font: .black)
        registerFont(bundleType: .resources, font: .medium)
        registerFont(bundleType: .resources, font: .regular)
        registerFont(bundleType: .resources, font: .light)
    }
    
    static func style(_ type: UILabel.FontType, _ size: CGFloat) -> UIFont {
        let name = type.fontName
        let font = UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: size)
        
        var descriptor = font.fontDescriptor
        
        let fontFeatures = [
            [UIFontDescriptor.FeatureKey.featureIdentifier: kNumberSpacingType,
             UIFontDescriptor.FeatureKey.typeIdentifier: kProportionalNumbersSelector ],
            
            [UIFontDescriptor.FeatureKey.featureIdentifier: kNumberCaseType,
             UIFontDescriptor.FeatureKey.typeIdentifier: kUpperCaseNumbersSelector],
        ]
        
        descriptor = descriptor.addingAttributes([.featureSettings: fontFeatures])
        return UIFont(descriptor: descriptor, size: size)
    }
    
    @discardableResult
    static func registerFont(bundleType: BundleType, font: UILabel.FontType, fontExtension: String = "ttf") -> Bool {

        guard let fontURL = Bundle(identifier: bundleType.identifier)?.url(forResource: font.fontName, withExtension: fontExtension) else {
                return false
            }

            guard let fontDataProvider = CGDataProvider(url: fontURL as CFURL) else {
                return false
            }

            guard let font = CGFont(fontDataProvider) else {
                return false
            }

            var error: Unmanaged<CFError>?
            let success = CTFontManagerRegisterGraphicsFont(font, &error)
            guard success else {
                print("Error registering font: maybe it was already registered.")
                return false
            }

            return true
        }
}
