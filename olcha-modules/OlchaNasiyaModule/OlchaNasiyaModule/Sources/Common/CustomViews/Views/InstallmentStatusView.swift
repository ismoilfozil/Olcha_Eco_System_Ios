//
//  InstallmentStatusView.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 11/05/23.
//

import UIKit
import OlchaUI
public class InstallmentStatusView: BaseView {
    private lazy var container: UIView = {
        let view = UIView()
        view.round(6)
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 12)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var dot: UIView = {
        let view = UIView()
        view.backgroundColor = .olchaPrimaryColor
        view.round(dotSize / 2)
        view.isHidden = true
        return view
    }()
    
    private let dotSize: CGFloat = 8
    
    public override func setupViews() {
        addSubview(container)
        container.addSubview(titleLabel)
        addSubview(dot)
    }
    
    public override func autolayout() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(dotSize / 2)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(6)
            make.top.bottom.equalToSuperview().inset(4)
        }
        
        dot.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.width.height.equalTo(dotSize)
        }
    }
    
    public func setup(installment: InstallmentModel?) {
        titleLabel.text = installment?.status_name ?? " - "
        
        container.backgroundColor = installment?.getStatusColor().withAlphaComponent(0.05)
        titleLabel.textColor = installment?.getStatusColor()
        
        dot.isHidden = !(installment?.getStatus() == .active)
    }
}
