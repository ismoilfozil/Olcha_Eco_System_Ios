//
//  ReturnOrderReasonViewController.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 18/10/23.
//

import UIKit
import OlchaUI
class ReturnOrderReasonViewController: OlchaUI.BaseViewController<OlchaUI.BackNavigationBar> {
    
    private let buttonHeight: CGFloat = 40
    
    private let scrollView: IScrollView = {
        let scrollView = IScrollView()
        scrollView.settings.alwaysBounceVertical = true
        scrollView.container.alignment = .center
        scrollView.container.spacing = 16
        return scrollView
    }()
    
    private let productView = ReturnOrderProductView()
    
    private let reasonButton: HButtonIcon = {
        let button = HButtonIcon()
        button.configureSortButton()
        button.setTitle("Test")
        return button
    }()
    
    private let reasonTextField: OlchaUI.TMultiField = {
        let field = OlchaUI.TMultiField()
        return field
    }()
    
    private let addImagesView: AddImagesView = {
        let view = AddImagesView()
        return view
    }()
    
    private let reasonButtonMenu = MenuButton()
    
    private let acceptButton = OlchaButton()
    
    weak var coordinator: ReturnOrderCoordinatorProtocol?
    
    let uploadViewModel = UploadViewModel()
    let viewModel = OrderPageViewModel()
    
    var input: Input
    var output: Output
    
    init(input: Input = .init(),
         output: Output = .init()
    ) {
        self.input = input
        self.output = output
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setupViews() {
        container.addSubview(scrollView)
        scrollView.addArrangedSubview(productView)
        scrollView.addArrangedSubview(reasonButton)
        scrollView.addArrangedSubview(reasonTextField)
        scrollView.addArrangedSubview(addImagesView)
        scrollView.addArrangedSubview(acceptButton)
        
        container.addSubview(reasonButtonMenu)
    }
    
    override func autolayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        productView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
        }
        
        reasonButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(buttonHeight)
        }
        
        reasonButtonMenu.snp.makeConstraints { make in
            make.left.equalTo(reasonButton.snp.left)
            make.top.equalTo(reasonButton.snp.top)
            make.right.equalTo(reasonButton.snp.right)
        }
        
        reasonTextField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(100)
        }
        
        addImagesView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        acceptButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
        }
        
    }
    
    override func configureViews() {
        reasonButtonMenu.items = input.reasons.map { $0.title }
        reasonButtonMenu.height = buttonHeight
        
        addImagesView.presentAddMedia = output.presentAddMedia
        addImagesView.removeMediaObserver = output.removeMediaObserver
        
        reasonUpdated()
    }
    
    override func languageUpdated() {
        reasonTextField.placeholder = "cause".localized()
        acceptButton.setTitle("accept".localized())
        reasonUpdated()
    }
    
    override func setupObservers() {
        reasonButtonMenu.settings.clicked { [weak self] in
            guard let self = self else { return }
            reasonButtonMenu.openMenu = !reasonButtonMenu.openMenu
        }
        
        reasonButtonMenu.selectedIndex = { [weak self] index in
            guard let self = self else { return }
            input.reason = input.reasons[index]
            reasonUpdated()
        }
        
        reasonTextField.settings.observeText { [weak self] _ in
            guard let self else { return }
            checkButtonState()
        }
        
        output.presentAddMedia.sink { [weak self] type in
            guard let self else { return }
            coordinator?.presentMediaType(mediaType: .image, imageObserver: output.selectedImageObserver)
        }.store(in: &bag)
        
        output.selectedImageObserver.sink { [weak self] image in
            guard let self = self else { return }
            self.uploadViewModel.upload(image: image)
        }.store(in: &bag)
        
        uploadViewModel.$image.sink { [weak self] file in
            guard let self, let file else { return }
            input.images.append(file)
            imagesReloader()
        }.store(in: &bag)
        
        uploadViewModel.uploadIndicator.sink { [weak self] isLoading in
            guard let self else { return }
            isLoading ? showLoader() : hideLoader()
        }.store(in: &bag)
        
        output.removeMediaObserver.sink { [weak self] index in
            guard let self, input.images.isGreater(index) else { return }
            input.images.remove(at: index)
            imagesReloader()
        }.store(in: &bag)
        
        handle(viewModel.$orderReturn) { [weak self] data in
            guard let self else { return }
            
            self.coordinator?.finishReturning()
            
        } loading: { [weak self] isLoading in
            guard let self else { return }
            acceptButton.settings.requesting = isLoading
        }
        
        
        acceptButton.clicked { [weak self] in
            guard let self else { return }
            viewModel.returnOrder(
                model: .init(dto: createReturnModel(),
                             orderID: input.order?.id)
            )
        }
        
    }
    
    func setupData() {
        productView.setup(with: input.product)
        imagesReloader()
    }
    
    private func imagesReloader() {
        addImagesView.setup(images: input.images)
        checkButtonState()
    }
    
    private func reasonUpdated() {
        reasonButton.setTitle(input.reason.title)
        reasonTextField.isHidden = input.reason != .other
        checkButtonState()
    }
    
    private func checkButtonState() {
        
        var isValidated = true
        
        if input.reason == .other, reasonTextField.getText().withoutWhiteSpace.isEmpty {
            isValidated = false
        }
        
        if input.images.isEmpty {
            isValidated = false
        }
        
        isValidated ? acceptButton.enableButton() : acceptButton.disableButton()
    }
    
    private func createReturnModel() -> ReturnOrderDTO {
        let reason: String = (input.reason == .other) ? reasonTextField.getText() : input.reason.title
        return .init(files: input.images.compactMap { $0.id },
                     reason: reason,
                     products: [
                        .init(store_id: input.product?.getStoreID(),
                              id: input.product?.id,
                              amount: input.product?.amount)
                     ])
    }
}
