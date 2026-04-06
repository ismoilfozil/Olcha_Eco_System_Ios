//
//  ContactManager.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 09/05/24.
//

import UIKit
import ContactsUI
final class ContactManager: NSObject, CNContactPickerDelegate {
    
    private var completion: ((String) -> Void)?
    private let contactPicker = CNContactPickerViewController()
    
    func getContact(_ vc: UIViewController, completion: ((String) -> Void)?) {
        self.completion = completion
        contactPicker.delegate = self
        contactPicker.displayedPropertyKeys = [CNContactGivenNameKey, CNContactPhoneNumbersKey]
        vc.present(contactPicker, animated: true)
    }
    
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {

        let userPhoneNumbers: [CNLabeledValue<CNPhoneNumber>] = contact.phoneNumbers
        guard let firstPhoneNumber: CNPhoneNumber = userPhoneNumbers.first?.value else {
            completion?("")
            return
        }
        let primaryPhoneNumberStr: String = firstPhoneNumber.stringValue

        completion?(primaryPhoneNumberStr)

    }

    
}
