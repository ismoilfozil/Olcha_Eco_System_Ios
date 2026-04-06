/// created by Akhrorhuja
import Foundation
public protocol ClickAction {
    var rawValue: String { get }
    var module: OlchaModule? { get }
    static func fromRawValue(_ rawValue: String?, actionId: Int?, alias: String?) -> Self?
}
