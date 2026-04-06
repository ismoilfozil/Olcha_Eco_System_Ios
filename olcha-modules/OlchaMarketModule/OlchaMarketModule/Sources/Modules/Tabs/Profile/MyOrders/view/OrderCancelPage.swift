//
//  OrderCancelPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 07/12/22.
//

import UIKit
import Combine
import OlchaUI
class OrderCancelPage: BaseViewController {
    
    private var bag = Set<AnyCancellable>()
    let table = BaseTableView()
    let acceptButton = OlchaButton()
    
    enum Item {
        case changed
        case doubled
        case reorder
        case long
        case cheaper
        case other
        
        var title: String {
            switch self {
            case .changed:
                return "changedMind".localized()
            case .doubled:
                return "orderedTwo".localized()
            case .reorder:
                return "orderAgain".localized()
            case .long:
                return "deliveryLong".localized()
            case .cheaper:
                return "foundCheap".localized()
            case .other:
                return "other".localized()
            }
        }
    }
    
    enum Section {
        case statics
        case comment
    }
    
    var sections: [ Section ] = [
        .statics,
        .comment
    ]
    
    var items: [ Item ] = [
        .changed,
        .doubled,
        .reorder,
        .long,
        .cheaper,
        .other
    ]
    
    var selectedItem: Item = .other
    
    let commentObserver = PassthroughSubject<String, Never>()
    
    var causeObserver: ((String) -> Void)?
    
    var comment: String = ""
    
    override func viewDidLoad() {
        
        setupModalViews()
        modalAutolayout()
        configureModalViews(header: "order_cause_title".localized(), textAlignment: .left)
        setupObservers()
    }
    

    override func setupModalViews() {
        super.setupModalViews()
        modalContainer.addSubview(table)
        modalContainer.addSubview(acceptButton)
    }
    
    override func modalAutolayout() {
        super.modalAutolayout()
        setContainerHeight(UIScreen.main.bounds.height * 0.6)
        table.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().inset(24)
            make.bottom.equalTo(acceptButton.snp.top).inset(-16)
        }
        
        acceptButton.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview().inset(16)
        }
    }
    
    override func configureModalViews(header: String = "", textAlignment: NSTextAlignment = .left) {
        super.configureModalViews(header: header, textAlignment: textAlignment)
        
        table.delegate = self
        table.dataSource = self
        table.registerClass(forCell: CancelCauseRoom.self)
        table.registerClass(forCell: CommentRoom.self)
        table.configure()
        
        acceptButton.setTitle("confirm".localized())
        acceptButton.disableButton()
    }

    override func setupObservers() {
        commentObserver.sink { [weak self] text in
            guard let self = self else { return }
            self.comment = text
            self.checkButtonState()
        }.store(in: &bag)
        
        acceptButton.settings.clicked { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true) {
                self.sendCause()
            }
        }
    }
    
    func checkButtonState() {
        if selectedItem == .other {
            (comment.count > 0) ? acceptButton.enableButton() : acceptButton.disableButton()
        } else {
            acceptButton.enableButton()
        }
    }
    
    func sendCause() {
        var cause = selectedItem.title
        if selectedItem == .other {
            cause = comment
        }
        causeObserver?(cause)
    }
}
