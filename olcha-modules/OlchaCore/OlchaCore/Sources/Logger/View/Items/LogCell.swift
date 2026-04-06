//
//  LogCell.swift
//  OlchaCore
//
//  Created by Elbek Khasanov on 01/05/23.
//

import UIKit

class LogCell: UITableViewCell {

    @IBOutlet weak var apiLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var requestTimeLabel: UILabel!
    @IBOutlet weak var responseTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    func setup(model: LogModel?) {
        apiLabel.text = model?.url ?? ""
        codeLabel.text = "\(model?.code ?? -1)"
        codeLabel.textColor = (model?.code ?? -1) == 200 ? .green : .red
        requestTimeLabel.text = model?.requestTime
        responseTimeLabel.text = model?.responseTime
    }
    
}
