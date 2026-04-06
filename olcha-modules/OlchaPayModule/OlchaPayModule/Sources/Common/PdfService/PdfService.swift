//
//  PdfService.swift
//  OlchaUtils
//
//  Created by Elbek Khasanov on 30/03/23.
//

import Foundation
import OlchaUI
import SimplePDF
import UIKit
import PDFKit
import OlchaUtils

public class PdfService {
    
    static let shared = PdfService()
    
    private let a4PaperSize = CGSize(width: 595, height: 842)
    private let separatorSpace: CGFloat = 10
    private let separatorHeight: CGFloat = 0.01
    
    /// should receive on main thread
    public func createCheck(_ transaction: TransactionModel? = nil, completion: @escaping((Data?) -> Void) ) {
        DispatchQueue.main.async {
            let pdfView = PDFinvoice(frame: .init(origin: .zero, size: .init(width: 400, height: 800)))
            pdfView.setup(transaction: transaction)
            let pdfData = pdfView.toPDF()
            
            guard let destinationUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last?.appendingPathComponent("olcha-pay-\(UUID()).pdf") else { completion(nil); return }
            
            PDFDocument(data: pdfData)?.write(to: destinationUrl)
            
            completion(pdfData)
        }
//        DispatchQueue.global().async { [weak self] in
//            guard let self = self else { completion(nil); return }
//
//            var check: Data?
//            let pdf: SimplePDF = .init(pageSize: self.a4PaperSize)
//
//            pdf.setContentAlignment(.center)
//            pdf.addLineSpace(30)
//
//            if let img = UIImage.olchaInvoiceIcon {
//                pdf.addImage(img)
//            }
//
//            pdf.addLineSpace(20)
//            pdf.setContentAlignment(.left)
//
//            self.createCustomTable(pdf: pdf,
//                                   title: "sender_card".localized(),
//                                   value: transaction?.card_id?.bank_card?.getSpacedPan() ?? " - ")
//            pdf.addLineSpace(separatorSpace)
//            self.createCustomTable(pdf: pdf,
//                                   title: "sender_name".localized(),
//                                   value: transaction?.card_id?.bank_card?.full_name ?? " - ")
//
//            pdf.addLineSpace(separatorSpace)
//            pdf.addLineSeparator(height: separatorHeight)
//            pdf.addLineSpace(separatorSpace)
//
//            for field in (transaction?.fields ?? []).filter ({ $0.is_money == false }) {
//                self.createCustomTable(pdf: pdf,
//                                       title: field.key ?? " - ",
//                                       value: field.value ?? " - ")
//                pdf.addLineSpace(separatorSpace)
//            }
//
//            self.createCustomTable(pdf: pdf,
//                                   title: "date".localized(),
//                                   value: transaction?.dateTime() ?? " - ")
//
//            pdf.addLineSpace(separatorSpace)
//            pdf.addLineSeparator(height: separatorHeight)
//            pdf.addLineSpace(separatorSpace)
//
//            pdf.addLineSpace(separatorSpace)
//            self.createCustomTable(pdf: pdf,
//                                   title: "status".localized(),
//                                   value: transaction?.getStatus() ?? " - ")
//            pdf.addLineSpace(separatorSpace)
//            self.createCustomTable(pdf: pdf,
//                                   title: "summa".localized(),
//                                   value: transaction?.amount?.string.originalPrice ?? " - ")
//
//            pdf.addLineSpace(separatorSpace)
//            pdf.addLineSeparator(height: separatorHeight)
//            pdf.addLineSpace(separatorSpace)
//
//            pdf.addVerticalSpace(200)
//            pdf.addLineSeparator(height: separatorHeight)
//
//            let fileName = "olcha-pay-\(transaction?.id ?? 0)" + ".pdf"
//
//            var pdfData = pdf.generatePDFdata()
//
//            check = pdfData
//
//            completion(check)
//        }
    }
    
    private func createCustomTable(
        pdf: SimplePDF,
        title: String,
        value: String,
        titleFont: UIFont = .systemFont(ofSize: 10, weight: .regular),
        valueFont: UIFont = .systemFont(ofSize: 10, weight: .medium)
    ) {
            
        pdf.beginHorizontalArrangement()
        pdf.setContentAlignment(.left)
        pdf.addText(title + ":            ", font: titleFont, textColor: .lightGray)
        pdf.setContentAlignment(.right)
        
        pdf.addText(value, font: valueFont, textColor: .black)
        pdf.endHorizontalArrangement()
            
    }
}
