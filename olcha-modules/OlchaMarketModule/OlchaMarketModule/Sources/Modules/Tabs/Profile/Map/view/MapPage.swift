//
//  MapPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 08/09/22.
//

import UIKit
//import YandexMapsMobile
import Combine
import CoreLocation

class MapPage: BaseViewController {
//    
//    private var timer: Timer?
//
//    private var bag = Set<AnyCancellable>()
//    
//    private let mapView = YMKMapView()
//    
//    let viewModel = MapPageViewModel()
//    
//    let streetMapViewModel = StreetMapViewModel()
//    
//    private let searchField = TField()
//    
//    let searchHintTable = BaseTableView()
//    
//    private let searchIcon = IconButton()
//    
//    private let plusIcon = IconButton()
//    
//    private let minusIcon = IconButton()
//    
//    private let directionIcon = IconButton()
//    
//    private let bottomContainer = UIView()
//    
//    private let bottomStack = UIStackView()
//    
//    private let bottomTracker = UIView()
//    
//    private let bottomAddressTitle = UILabel()
//    
//    private let nextButton = OlchaButton()
//    
//    private let pin = UIImageView()
//    
//    private var zoom: Float = 15
//    
//    let roomHeight: CGFloat = 40
//    
//    weak var coordinator: ProfileCoordinatorProtocol?
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.tabBarController?.tabBar.isHidden = true
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        self.tabBarController?.tabBar.isHidden = false
//    }
//    
//    var searchedLocations: [StreetMapLocationModel] = [] {
//        didSet {
//            updateLayout()
//            searchHintTable.isHidden = searchedLocations.isEmpty
//        }
//    }
//    
//    var address = AddressModel()
//    
//    override func setupViews() {
//        super.setupViews()
//        container.addSubview(mapView)
//        container.addSubview(pin)
//        container.addSubview(searchField)
//        container.addSubview(searchIcon)
//        
//        container.addSubview(plusIcon)
//        container.addSubview(minusIcon)
//        container.addSubview(directionIcon)
//        container.addSubview(searchHintTable)
//        
//        view.addSubview(bottomContainer)
//        bottomContainer.addSubview(bottomStack)
//        bottomStack.addArrangedSubview(bottomTracker)
//        bottomStack.addArrangedSubview(bottomAddressTitle)
//        bottomStack.addArrangedSubview(nextButton)
//    }
//    
//    override func autolayout() {
//        super.autolayout()
//        mapView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//        
//        pin.snp.makeConstraints { make in
//            make.centerX.centerY.equalTo(mapView)
//            make.width.equalTo(29)
//            make.height.equalTo(39)
//        }
//        
//        searchField.snp.makeConstraints { make in
//            make.top.equalToSuperview().inset(8)
//            make.left.equalToSuperview().inset(16)
//            make.height.equalTo(40)
//        }
//        
//        searchIcon.snp.makeConstraints { make in
//            make.width.equalTo(60)
//            make.height.equalTo(40)
//            make.top.equalToSuperview().inset(8)
//            make.right.equalToSuperview().inset(16)
//            make.left.equalTo(searchField.snp.right).inset(-8)
//        }
//        
//        plusIcon.snp.makeConstraints { make in
//            make.right.equalToSuperview().inset(16)
//            make.width.height.equalTo(40)
//        }
//        
//        minusIcon.snp.makeConstraints { make in
//            make.top.equalTo(plusIcon.snp.bottom).inset(-8)
//            make.right.equalToSuperview().inset(16)
//            make.width.height.equalTo(40)
//            make.centerY.equalToSuperview()
//        }
//        
//        directionIcon.snp.makeConstraints { make in
//            make.top.equalTo(minusIcon.snp.bottom).inset(-8)
//            make.right.equalToSuperview().inset(16)
//            make.width.height.equalTo(40)
//        }
//        
//        bottomContainer.snp.makeConstraints { make in
//            make.left.bottom.right.equalToSuperview()
//        }
//        
//        bottomStack.snp.makeConstraints { make in
//            make.left.right.equalToSuperview().inset(16)
//            make.top.equalToSuperview().inset(8)
//            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(24)
//        }
//        
//        bottomTracker.snp.makeConstraints { make in
//            make.width.equalTo(40)
//            make.height.equalTo(4)
//        }
//        
//        nextButton.snp.makeConstraints { make in
//            make.left.right.equalToSuperview()
//            make.height.equalTo(40)
//        }
//    }
//    
//    override func configureViews() {
//        super.configureViews()
//        pin.image = .pin
//        
//        navigation.configure(style: .back)
//        navigation.setTitle("add_new_address".localized())
//        
//        searchField.background = .olchaWhite
//        
//        searchField.placeholder = "search_places".localized()
//        searchIcon.setIcon(.search_white)
//        searchIcon.backgroundColor = .olchaAccentColor
//        searchIcon.round()
//        searchIcon.updateLayout(with: 20)
//        
//        
//        plusIcon.setIcon(.plus?.withColor(.olchaTextBlack ?? .black))
//        minusIcon.setIcon(.minus?.withColor(.olchaTextBlack ?? .black))
//        directionIcon.setIcon(.direction?.withColor(.olchaTextBlack ?? .black))
//        
//        [plusIcon, minusIcon, directionIcon].forEach {
//            $0.darkBorder()
//            $0.round()
//            $0.backgroundColor = .olchaWhite
//            $0.updateLayout(with: 24)
//        }
//        
//        
//        mapConfiguration()
//        
//        searchHintTable.delegate = self
//        searchHintTable.dataSource = self
//        searchHintTable.registerClass(forCell: TitleLabelRoom.self)
//        searchHintTable.configure()
//        searchHintTable.darkBorder()
//        searchHintTable.round()
//        searchHintTable.showsVerticalScrollIndicator = false
//        
//        searchedLocations = []
//        
//        bottomContainer.round(12, topCorner: true)
//        bottomContainer.shadowAdd(offset: .init(width: 0, height: -4), opacity: 1, radius: 12)
//        
//        bottomContainer.backgroundColor = .olchaWhite
//        bottomStack.axis = .vertical
//        bottomStack.alignment = .center
//        bottomStack.spacing = 16
//        
//        bottomTracker.backgroundColor = .olchaLightNeutralDarkGray
//        bottomTracker.round(2)
//        
//        bottomAddressTitle.style(.semibold, 18)
//        bottomAddressTitle.textColor = .olchaTextBlack
//        bottomAddressTitle.numberOfLines = 3
//        bottomAddressTitle.text = " - "
//        
//        nextButton.setTitle("next".localized())
//    }
//    
//    private func mapConfiguration() {
//        mapView.mapWindow.map.mapType = .map
//        mapView.mapWindow.map.addCameraListener(with: viewModel)
//    }
//    
//    override func initialRequest() {
//        super.initialRequest()
//
//        if let lat = address.lat,
//           let lng = address.lng {
//            viewModel.mapLocation = .init(latitude: lat.double, longitude: lng.double)
//            moveTo(location: viewModel.mapLocation)
//        }
//        
//    }
//    
//    override func setupObservers() {
//        super.baseSetupObservers(viewModel: streetMapViewModel)
//
//        plusIcon.clicked { [weak self] in
//            guard let self = self else { return }
//            self.zoom = min(20, self.zoom + 1)
//            self.moveTo(location: self.viewModel.mapLocation)
//        }
//        
//        minusIcon.clicked { [weak self] in
//            guard let self = self else { return }
//            self.zoom = max(5, self.zoom - 1)
//            self.moveTo(location: self.viewModel.mapLocation)
//        }
//        
//        directionIcon.clicked { [weak self] in
//            guard let self = self else { return }
//            self.viewModel.mapLocation = self.viewModel.currentLocation
//            self.moveTo(location: self.viewModel.mapLocation)
//        }
//        
//        streetMapViewModel
//            .$searchedLocations
//            .dropFirst()
//            .sink { [weak self] data in
//                guard let self = self else { return }
//                self.searchedLocations = data
//                self.searchHintTable.reloadData()
//            }.store(in: &bag)
//        
//        streetMapViewModel
//            .$currentLocation
//            .sink { [weak self] data in
//                guard let self = self else { return }
//                self.bottomAddressTitle.text = data?.display_name
//                self.address.street = data?.display_name
//            }.store(in: &bag)
//        
//        searchField.observeText { [weak self] in
//            guard let self = self else { return }
//            self.timer?.invalidate()
//            self.timer = Timer.scheduledTimer(
//                timeInterval: 0.1,
//                target: self,
//                selector: #selector(self.searchLocation),
//                userInfo: [],
//                repeats: false)
//        }
//        
//        viewModel
//            .$locationChanged
//            .sink { [weak self] isChanged in
//                guard let self = self else { return }
//                if isChanged {
//                    self.streetMapViewModel.loadLocation(latitude: self.viewModel.mapLocation?.latitude,
//                                                         longitude: self.viewModel.mapLocation?.longitude)
//                }
//            }.store(in: &bag)
//        
//        nextButton.settings.clicked { [weak self] in
//            guard let self = self else { return }
//            self.address.lat = self.viewModel.mapLocation?.latitude.string
//            self.address.lng = self.viewModel.mapLocation?.longitude.string
//            self.coordinator?.pushUsersFullLocationPage(address: self.address)
//        }
//        
//        
//        viewModel
//            .initialLocation
//            .sink { [weak self] result in
//                guard let self = self, result == .finished else { return }
//                
//                if self.address.lat == nil && self.address.lng == nil {
//                    self.viewModel.mapLocation = self.viewModel.currentLocation
//                    self.moveTo(location: self.viewModel.mapLocation)
//                }
//            } receiveValue: { _ in }
//            .store(in: &bag)
//        
//        searchIcon.clicked { [weak self] in
//            guard let self = self else { return }
//            self.searchLocation()
//        }
//    }
//    
//    @objc func searchLocation() {
//        guard let text = searchField.settings.text,
//              text.count > 2
//        else {
//            return
//        }
//        
//        streetMapViewModel.searchLocation(text: text)
//    }
//    
//    func moveTo(location: CLLocationCoordinate2D?) {
//        guard let location = location else { return }
//
//        self.mapView.mapWindow.map.move(
//            with: YMKCameraPosition(target: YMKPoint(latitude: location.latitude,
//                                                     longitude: location.longitude),
//                                    zoom: self.zoom,
//                                    azimuth: 0,
//                                    tilt: 0),
//            animationType: YMKAnimation(type: YMKAnimationType.smooth,
//                                        duration: 1),
//            cameraCallback: nil)
//        
//    }
//
//    
//    private func updateLayout() {
//        let maxTableHeight = roomHeight * 5.cgfloat + roomHeight / 2
//        let currentHeight = roomHeight * searchedLocations.count.cgfloat
//        let tableHeight = min(currentHeight, maxTableHeight)
//        
//        searchHintTable.snp.remakeConstraints { make in
//            make.top.equalTo(searchField.snp.bottom).inset(-4)
//            make.left.right.equalToSuperview().inset(16)
//            make.height.equalTo(tableHeight)
//        }
//        
//        searchHintTable.isScrollEnabled = currentHeight > maxTableHeight
//    }
}
