//
//  InstallmentSortModal.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 17/06/23.
//

import OlchaUI
import UIKit
public class InstallmentSortModal: BaseModalViewController {
    
    private lazy var table: DynamicTable = {
        let table = DynamicTable()
        table.delegate = self
        table.dataSource = self
        table.registerClass(forCell: InstallmentStatusRoom.self)
        table.configure()
        return table
    }()
    
    private let acceptButton: NasiyaButton = {
        let button = NasiyaButton()
        button.setTitle("accept".localized())
        return button
    }()
    
    var input: Input
    var output: Output
    
    let cellHeight: CGFloat = 44
    
    public init(input: Input = Input(), output: Output = Output()) {
        self.input = input
        self.output = output
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setupViews() {
        container.addSubview(table)
        container.addSubview(acceptButton)
    }
    
    public override func autolayout() {
        table.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.left.right.equalToSuperview()
        }
        
        acceptButton.snp.makeConstraints { make in
            make.top.equalTo(table.snp.bottom).inset(-16)
            make.left.right.bottom.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
    }
    
    public override func configureViews() {
        setHeader(title: "sort".localized(.olchaNasiyaModule))
    }
    
    public override func setupObservers() {
        acceptButton.clicked { [weak self] in
            guard let self = self else { return }
            output.acceptCopy()
            output.filters?.statusObserver.send(true)
            dismiss(animated: true)
        }
    }
    
    public func setup() {
//        setContainerHeight(cellHeight*(output.copi?.allStatuses.count.cgfloat ?? 0))
    }
}
