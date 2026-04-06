//
//  ScannerViewController.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 17/02/23.
//

import UIKit
import OlchaUI
import AVFoundation
import Combine
public protocol ScannerManagerDelegate: AnyObject {
    func cardScannered(_ card: CardModel?)
}

public class ScannerManager: ScanDelegate {
    
    weak var delegate: ScannerManagerDelegate?
    
    var navigationController: UINavigationController
    
    weak var card: CardModel?
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func pushScanner(cardModel: CardModel?) {
        self.card = cardModel
        CameraManager.checkPermission { [weak self] isAllowed in
            guard let self = self else { return }
            if isAllowed {
                self.presentScanner()
            } else {
                self.presentDeniedError()
            }
        }
        
    }
    
    private func presentScanner() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
        
        if let viewController = ScanViewController.createViewController(withDelegate: self) {
            
            self.navigationController.present(viewController, animated: true, completion: nil)
        }
//
//        let scannerView = CardScanner.getScanner { [weak self] cardNumber, date, cvv in
//
//            guard let self = self,
//                  let cardNumber = cardNumber,
//                  let date = date,
//                  date.count == 5 else {
//                      return
//                  }
//
//            let card = CardModel()
//            card.expiry = date
//            card.numbers = cardNumber
//            self.delegate?.cardScannered(card)
//
//        }
//        self.navigationController.present(scannerView, animated: true, completion: nil)
            
        }
    }
    
    private func presentDeniedError() {
        self.dismiss()
    }
    
    public func userDidCancel(_ scanViewController: ScanViewController) {
        self.dismiss()
    }
    
    public func userDidScanCard(_ scanViewController: ScanViewController, creditCard: CreditCard) {
        card?.expiry = (creditCard.expiryMonth ?? "") + "/" + (creditCard.expiryYear ?? "")
        card?.numbers = creditCard.number.makeReadableCardNumber
        delegate?.cardScannered(card)
        self.dismiss()
    }
    
    public func userDidSkip(_ scanViewController: ScanViewController) {
        
    }
    
    private func dismiss() {
        self.navigationController.getTopViewController()?.dismiss(animated: true, completion: nil)
    }
}
