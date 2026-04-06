//
//  QRCameraViewController.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 02/03/23.
//

import UIKit
import OlchaUI
import AVFoundation
import QRScanner
public class QRCameraViewController: BaseViewController<BackNavigationBar>, QRScannerViewDelegate {

    private var scannerView: QRScannerView?
    
    weak var coordinator: PaymentsCoordinatorProtocol?
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    public override func autolayout() {
        container.snp.remakeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(navigationBar.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        setupScanner()
    }
    
    public func qrScannerView(_ qrScannerView: QRScannerView, didFailure error: QRScannerError) {}
    
    public func qrScannerView(_ qrScannerView: QRScannerView, didSuccess code: String) {
        coordinator?.pushQRPayment(url: code)
        scannerView?.stopRunning()
        navigationController?.pop()
    }
    
    func setupScanner() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.scannerView = QRScannerView(frame: self.container.bounds)
            if let scannerView = self.scannerView {
                self.container.addSubview(scannerView)
            }
            
            self.scannerView?.configure(delegate: self, input: .init(isBlurEffectEnabled: false))
            self.scannerView?.startRunning()
        }
        
    }
}
