//
//  UserFullLocationPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 10/09/22.
//

import UIKit
import Combine
import OlchaUI
class UserFullLocationPage: BaseViewController, UITextViewDelegate {

    private let scrollView = UIScrollView()
    
    private let scrollContainer = UIView()
    
    private let fieldsStack = UIStackView()
    
    private let regionField = TField()
    private let regionFieldButton = MenuButton()
    
    private let districtField = TField()
    private let districtFieldButton = MenuButton()
    
    private let mainLocationContainer = UIView()
    private let mainLocationHeader = UILabel()
    private let mainLocationTextView = UITextView()
    private let mainLocationCancelButton = IconButton()
    
    private let houseStack = UIStackView()
    
    private let houseNumberField = TField()
    
    private let flatField = TField()
    
    private let podyezdStack = UIStackView()
    
    private let entranceField = TField()
    
    private let floorField = TField()
    
    private let commentField = TField()
    
    private let saveButton = OlchaButton()
    
    private var bag = Set<AnyCancellable>()
    
    private let viewModel = LocationsPageViewModel()
    
    var districts: [District] = [] {
        didSet {
            districtFieldButton.items = districts.compactMap { $0.getName() }
        }
    }
    
    var regions: [District] = [] {
        didSet {
            regionFieldButton.items = regions.map { $0.getName() }
        }
    }
    
    var currentRegion: District? {
        didSet {

            currentDistrict = nil
            districts.removeAll()
            loadDistricts()

            regionField.settings.text = currentRegion?.getName()
            
            checkButtonState()
        }
    }
    
    var currentDistrict: District? {
        didSet {
            
            districtField.settings.text = currentDistrict?.getName()
            
            checkButtonState()
        }
    }
    
    
    var address: UserAddress? {
        didSet {
            mainLocationTextView.text = address?.street
            houseNumberField.settings.text = address?.house_number
            flatField.settings.text = address?.apartment
            entranceField.settings.text = address?.entrance
            floorField.settings.text = address?.floor
            checkButtonState()
        }
    }
    
    weak var coordinator: ProfileCoordinatorProtocol?
    
    public var completion: (() -> Void)?
    
    override func setupViews() {
        super.setupViews()
        container.addSubview(scrollView)
        scrollView.addSubview(scrollContainer)
        
        scrollContainer.addSubview(fieldsStack)
        fieldsStack.addArrangedSubview(regionField)
        fieldsStack.addArrangedSubview(districtField)
        
        fieldsStack.addArrangedSubview(mainLocationHeader)
        fieldsStack.addArrangedSubview(mainLocationContainer)
        
        mainLocationContainer.addSubview(mainLocationTextView)
        mainLocationContainer.addSubview(mainLocationCancelButton)
        
        fieldsStack.addArrangedSubview(houseStack)
        
        houseStack.addArrangedSubview(houseNumberField)
        houseStack.addArrangedSubview(flatField)
        
        fieldsStack.addArrangedSubview(podyezdStack)
        
        podyezdStack.addArrangedSubview(entranceField)
        podyezdStack.addArrangedSubview(floorField)
        
        fieldsStack.addArrangedSubview(commentField)
        
        container.addSubview(saveButton)
        
        container.addSubview(districtFieldButton)
        container.addSubview(regionFieldButton)
    }
    
    override func autolayout() {
        super.autolayout()
        
        scrollView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(saveButton.snp.top).inset(-8)
        }
        
        scrollContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(container.snp.height).priority(.low)
            make.width.equalTo(container.snp.width)
        }
        
        fieldsStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        mainLocationHeader.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        mainLocationContainer.snp.makeConstraints { make in
            make.height.equalTo(72)
        }
        
        mainLocationTextView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(12)
            make.left.equalToSuperview().inset(16)
        }
        
        mainLocationCancelButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(16)
            make.left.equalTo(mainLocationTextView.snp.right).inset(-16)
        }
        
        saveButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(24)
            make.left.right.equalToSuperview().inset(16)
        }
        
        regionFieldButton.snp.makeConstraints { make in
            make.top.right.left.equalTo(regionField)
        }
        
        districtFieldButton.snp.makeConstraints { make in
            make.top.right.left.equalTo(districtField)
        }
        
        scrollContainer.layoutIfNeeded()
        
        regionFieldButton.height = regionField.bounds.height
        
        districtFieldButton.height = districtField.bounds.height
    }
    
    override func configureViews() {
        super.configureViews()
        navigation.configure(style: .back)
        navigation.setTitle("shipping_address".localized())

        mainLocationContainer.round()
        mainLocationContainer.darkBorder()
        
        mainLocationTextView.font = .style(.medium, 16)
        mainLocationTextView.textColor = .olchaTextBlack
        mainLocationTextView.showsVerticalScrollIndicator = false
        
        mainLocationCancelButton.setIcon(.x_cancel)
        
        
        mainLocationHeader.textColor = .olchaLightTextColornnnnnn
        mainLocationHeader.style(.medium, 14)
        mainLocationHeader.numberOfLines = 0
        
        
        fieldsStack.axis = .vertical
        fieldsStack.spacing = 16
        
        [houseStack, podyezdStack].forEach {
            $0.axis = .horizontal
            $0.spacing = 16
            $0.distribution = .fillEqually
        }
        mainLocationHeader.text = "street".localized()
        houseNumberField.topHint = "house_number".localized()
        flatField.topHint = "flat".localized()
        entranceField.topHint = "podyezd".localized()
        floorField.topHint = "floor".localized()
        
        commentField.topHint = "shipping_comment".localized()
        
        saveButton.setTitle("save_next".localized())
        
        regionField.rightImage = .down_anchor_black
        regionField.topHint = "ship_region".localized()
        
        districtField.rightImage = .down_anchor_black
        districtField.topHint = "ship_district".localized()
        
        districtFieldButton.items = []
        regionFieldButton.items = []
        
        fieldsStack.setCustomSpacing(4, after: mainLocationHeader)
    }
    
    override func initialRequest() {
        super.initialRequest()
        viewModel.loadRegions()
        checkButtonState()
    }
    
    override func setupObservers() {
        super.baseSetupObservers(viewModel: viewModel)
        
        mainLocationCancelButton
            .clicked { [weak self] in
                guard let self = self else { return }
                self.mainLocationTextView.text = ""
                self.checkButtonState()
            }
        
        districtFieldButton
            .settings
            .clicked { [weak self] in
                guard let self = self else { return }
                self.regionFieldButton.openMenu = false
                self.districtFieldButton.openMenu = !self.districtFieldButton.openMenu
            }
        
        regionFieldButton
            .settings
            .clicked { [weak self] in
                guard let self = self else { return }
                self.districtFieldButton.openMenu = false
                self.regionFieldButton.openMenu = !self.regionFieldButton.openMenu
            }
        
        districtFieldButton
            .selectedIndex = { [weak self] index in
                guard let self = self, index < self.districts.count else { return }
                self.currentDistrict = self.districts[index]
            }
        
        regionFieldButton
            .selectedIndex = { [weak self] index in
                guard let self = self, index < self.regions.count else { return }
                self.currentRegion = self.regions[index]
            }
        
        viewModel
            .$regions
            .dropFirst()
            .sink { [weak self] data in
                guard let self = self else { return }
                self.regions = data ?? []
                self.currentRegion = self.regions.filter { $0.id == self.address?.region_id }.first
                
                if let region = self.regions.filter { $0.id == self.address?.getRegionID() }.first {
                    self.currentRegion = region
                    self.address?.region_id = nil
                }
                
            }.store(in: &bag)
        
        viewModel
            .$districts
            .dropFirst()
            .sink { [weak self] data in
                guard let self = self else { return }

                self.districts = data ?? []
                
                if let district = self.districts.filter { $0.id == self.address?.getDistrictID() }.first {
                    self.currentDistrict = district
                    self.address?.district_id = nil
                }
                
            }.store(in: &bag)
        
        viewModel
            .$addressSaveError
            .sink { [weak self] isError in
                guard let self = self else { return }
                if isError {
                    self.saveButton.settings.requesting = false
                }
            }.store(in: &bag)
        
        viewModel
            .$savedAddress
            .sink { [weak self] data in
                guard let self = self, let data = data else { return }
                acceptNewAddress(data)
                self.saveButton.settings.requesting = false
                
                self.showSuccess(text: "location_saved".localized()) {
                    
                    self.completion?()
                    self.coordinator?.finishedSaving(address: data)
                    
                }
                
            }.store(in: &bag)
        
        saveButton.settings.clicked { [weak self] in
            guard let self = self else { return }
            self.saveAddress()
        }
        
        houseNumberField.observeText { [weak self] in
            guard let self = self else { return }
            self.checkButtonState()
        }
        
        flatField.observeText { [weak self] in
            guard let self = self else { return }
            self.checkButtonState()
        }
        
        mainLocationTextView.delegate = self
        
        scrollView.delegate = self
    }
    
    func textViewDidChange(_ textView: UITextView) {
        checkButtonState()
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        districtFieldButton.openMenu = false
        regionFieldButton.openMenu = false
    }
    
    func loadDistricts() {
        guard let id = currentRegion?.id else { return }

        viewModel.loadDistricts(regionID: id)
    }
    
    func saveAddress() {
        let newAddress = createSaveAddress()
        saveButton.settings.requesting = true
        
        
        viewModel.saveAddress(newAddress)
    }
    
    private func createSaveAddress() -> UserAddress {
        let newAddress = UserAddress()
        newAddress.id = address?.id
        newAddress.region_id = currentRegion?.id
        newAddress.district_id = currentDistrict?.id
        newAddress.street = mainLocationTextView.text
        
        newAddress.house_number = houseNumberField.settings.text
        newAddress.apartment = flatField.settings.text
        newAddress.entrance = entranceField.settings.text
        newAddress.floor = floorField.settings.text
        
        newAddress.lat = address?.lat
        newAddress.lng = address?.lng
        return newAddress
    }
    
    private func acceptNewAddress(_ newAddress: UserAddress) {
        
        address?.region_id = newAddress.region_id
        address?.district_id = newAddress.district_id
        address?.region = newAddress.region
        address?.district = newAddress.district
        address?.street = newAddress.street
        address?.house_number = newAddress.house_number
        address?.apartment = newAddress.apartment
        address?.entrance = newAddress.entrance
        address?.floor = newAddress.floor
        address?.lat = newAddress.lat
        address?.lng = newAddress.lng
        
        
    }
    
    func checkButtonState() {
        var buttonActive = true
        
        if currentRegion == nil {
            buttonActive = false
        }
        
        if currentDistrict == nil {
            buttonActive = false
        }
        
        if mainLocationTextView.text.withoutSpace == "" {
            buttonActive = false
        }
        
        if houseNumberField.settings.text?.withoutSpace == "" {
            buttonActive = false
        }
        
        saveButton.settings.isEnabled = buttonActive
        saveButton.settings.backgroundColor = .olchaAccentColor.withAlphaComponent(buttonActive ? 1 : 0.2)
        mainLocationCancelButton.isHidden = mainLocationTextView.text == ""
        
    }

}
