import UIKit

public extension UITableViewCell {
    func configureSeparator(tableWidth: CGFloat, isLastCell: Bool, inset: UIEdgeInsets = .init(top: 0, left: 56, bottom: 0, right: 0)) {
        separatorInset = UIEdgeInsets(
            top: inset.top,
            left: isLastCell ? tableWidth : inset.left,
            bottom: inset.bottom,
            right: inset.right
        )
    }
}
