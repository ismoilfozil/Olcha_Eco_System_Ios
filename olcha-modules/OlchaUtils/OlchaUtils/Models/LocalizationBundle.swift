import Foundation

///
/// `For better performance in localization used this LocalizationBundle`
///
public struct LocalizationBundle {
    nonisolated(unsafe) public static var bundles: [BundleType: Bundle] = [:]
        
    public static func setup() {
        guard let language = Language(rawValue: String.getAppLanguage()) else { return }
        let locKey = language.localization_key
        for type in BundleType.allCases {
            guard let bundle = Bundle(identifier: type.identifier) else {
                continue
            }
            guard let path = bundle.path(forResource: locKey, ofType: "lproj") else {
                continue
            }
            LocalizationBundle.bundles[type] = Bundle(path: path)
        }
    }
}
