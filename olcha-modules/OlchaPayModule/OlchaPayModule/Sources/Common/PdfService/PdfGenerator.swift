
import UIKit
extension UIView {
    func toPDF() -> Data {
        let pdfData = NSMutableData()
        let pdfBounds = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        
        UIGraphicsBeginPDFContextToData(pdfData, pdfBounds, nil)
        UIGraphicsBeginPDFPageWithInfo(pdfBounds, nil)
        
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        UIGraphicsEndPDFContext()
        
        return pdfData as Data
    }
}
