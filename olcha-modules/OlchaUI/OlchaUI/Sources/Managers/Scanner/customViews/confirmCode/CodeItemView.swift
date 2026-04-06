


import UIKit

open class CodeItemView: UIView {

    
    
    @IBOutlet weak var textField: UITextField!
    
    
    @IBOutlet weak var container: UIView!
    
    @IBOutlet weak var underline: UIView!
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        textField.text = ""
        textField.tintColor = .clear
        container.backgroundColor = .lightGray
        textField.backgroundColor = .clear
        textField.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        textField.textColor = .black
        underline.backgroundColor = .black
        isUserInteractionEnabled = false
    }
    
    private func applyBorderedShadow() {
        
        
//        layer.shadowOpacity = 1
//        layer.shadowColor = UIColor(red: 227/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1).cgColor
//        layer.shadowOffset = CGSize(width: 0, height: 1)
//        layer.shadowRadius = 8
//        layer.masksToBounds = false
//        layer.cornerRadius = 4
        
        
    }
    
//    override open func becomeFirstResponder() -> Bool {
//        return textField.becomeFirstResponder()
//    }
//
//    override open func resignFirstResponder() -> Bool {
//        return textField.resignFirstResponder()
//    }
}

