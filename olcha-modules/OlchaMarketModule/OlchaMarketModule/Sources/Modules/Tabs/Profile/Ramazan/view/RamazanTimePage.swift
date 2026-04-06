//
//  RamazanTaqvimViewController.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 14/03/23.
//

import UIKit
import Combine
import OlchaUI
class RamazanTimePage: BaseViewController {

    private let scrollView = UIScrollView()
    private let scrollContainer = UIView()
    
    private let fromAudioView = RamazanAudioView()
    private let toAudioView = RamazanAudioView()
    
    private let regionField = TField()
    private let regionFieldButton = MenuButton()
    
    private let timesTable = BaseTableView()
    
    private let enableContaienr = UIView()
    private let enableTitleLabel = UILabel()
    private let enableSwitch = UISwitch()
    
    let fromAudio = RamazanAudioModel(title: "ramazan_from_title".localized(),
                                      content: "ramazan_from_content".localized(),
                                      audioPath: "ramazan_from_audio.m4a")
    
    let toAudio = RamazanAudioModel(title: "ramazan_to_title".localized(),
                                    content: "ramazan_to_content".localized(),
                                    audioPath: "ramazan_to_audio.mp3")
    
    var times: [PrayTimeModel] = [ ]
    
    var regions: [District] = [] {
        didSet {
            regionFieldButton.items = regions.map { $0.getName() }
        }
    }
    
    var currentRegion: District? {
        didSet {
            regionField.settings.text = currentRegion?.getName()
            loadTimes()
        }
    }
    
    let rowHeight: CGFloat = 32
    
    var currentPath: String = ""
    
    private var bag = Set<AnyCancellable>()
    
    private let locationsViewModel = LocationsPageViewModel()
    
    private let viewModel = ProfilePageViewModel()
    
    override func setupViews() {
        container.addSubview(scrollView)
        scrollView.addSubview(scrollContainer)
        scrollContainer.addSubview(enableContaienr)
        
        enableContaienr.addSubview(enableTitleLabel)
        enableContaienr.addSubview(enableSwitch)
        
        scrollContainer.addSubview(fromAudioView)
        scrollContainer.addSubview(toAudioView)
        scrollContainer.addSubview(regionField)
        scrollContainer.addSubview(timesTable)
        
        container.addSubview(regionFieldButton)
    }
    
    override func autolayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(container.snp.height).priority(.low)
            make.width.equalTo(container.snp.width)
        }
        
        enableContaienr.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }
        
        enableTitleLabel.snp.makeConstraints { make in
            make.top.bottom.left.equalToSuperview()
            make.right.equalTo(enableSwitch.snp.left).inset(-16)
        }
        
        enableSwitch.snp.makeConstraints { make in
            make.top.bottom.right.equalToSuperview()
        }
        
        fromAudioView.snp.makeConstraints { make in
            make.top.equalTo(enableContaienr.snp.bottom).inset(-12)
            make.left.right.equalToSuperview()
        }
        
        toAudioView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(fromAudioView.snp.bottom).inset(-12)
        }
        
        regionField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(toAudioView.snp.bottom).inset(-12)
        }
        
        timesTable.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(regionField.snp.bottom).inset(-12)
            make.bottom.equalToSuperview()
            make.height.equalTo(0)
        }
        
        regionFieldButton.snp.makeConstraints { make in
            make.top.equalTo(regionField.snp.top)
            make.left.equalTo(regionField.snp.left)
            make.right.equalTo(regionField.snp.right)
        }
        
    }
    
    
    override func configureViews() {
        navigation.configure(style: .back)
        
        timesTable.delegate = self
        timesTable.dataSource = self
        timesTable.registerClass(forCell: RamazanTimeRoom.self)
        timesTable.configure()
        timesTable.isScrollEnabled = false
        
        setupAudioViews()
        
        regionField.rightImage = .down_anchor_black
        regionField.topHint = "region".localized()
        
        scrollContainer.layoutIfNeeded()

        regionFieldButton.height = regionField.bounds.height
        
        
        enableTitleLabel.style(.medium, 16)
        enableTitleLabel.textColor = .olchaTextBlack
        enableTitleLabel.numberOfLines = 0
        
        enableTitleLabel.text = "push_notification".localized()
        
        enableSwitch.onTintColor = .olchaAccentColor
        enableSwitch.addTarget(self,
                               action: #selector(pushObserver(_:)),
                               for: .valueChanged)
        
        enableSwitch.isOn = (OlchaGlobalDefaults.user.ramazanPrayNotifications ?? true)
    }
    
    @objc func pushObserver(_ sender: UISwitch) {
        viewModel.registerRamazanTaqvim(sender.isOn)
    }
    
    override func initialRequest() {
        locationsViewModel.loadRegions()
    }
    
    override func setupObservers() {
        super.baseSetupObservers(viewModel: viewModel)
        fromAudioView.audioPlayer.currentPlayingPath = { [weak self] path in
            guard let self = self,
                  let path = path else { return }
            self.currentPath = path
            self.setupAudioViews()
        }
        
        toAudioView.audioPlayer.currentPlayingPath = { [weak self] path in
            guard let self = self,
                  let path = path else { return }
            self.currentPath = path
            self.setupAudioViews()
        }
        
        fromAudioView.dropDownIcon.clicked { [weak self] in
            guard let self = self else { return }
            
            self.fromAudioView.isExpanded = !self.fromAudioView.isExpanded
            
        }
        
        toAudioView.dropDownIcon.clicked { [weak self] in
            guard let self = self else { return }
            self.toAudioView.isExpanded = !self.toAudioView.isExpanded
        }
        
        regionFieldButton.settings.clicked { [weak self] in
            guard let self = self else { return }
            self.regionFieldButton.openMenu = !self.regionFieldButton.openMenu
        }
        
        regionFieldButton.selectedIndex = { [weak self] index in
            guard let self = self else { return }
            if self.regions.isGreater(index) {
                self.currentRegion = self.regions[index]
            }
        }
        
        locationsViewModel
            .$regions
            .sink { [weak self] data in
                guard let self = self,
                      let data = data else { return }
                self.regions = data
                self.currentRegion = self.regions.first
            }.store(in: &bag)
        
        viewModel
            .$ramazanTimes
            .sink { [weak self] times in
                guard let self = self else { return }
                self.times = times
                self.reloadTimeTable()
            }.store(in: &bag)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        currentPath = ""
    }
    
    
    private func setupAudioViews() {
        fromAudioView.setup(with: fromAudio, currentPath: currentPath)
        toAudioView.setup(with: toAudio, currentPath: currentPath)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        regionFieldButton.openMenu = false
    }
    
    private func reloadTimeTable() {
        timesTable.reloadData()
        timesTable.layoutIfNeeded()
        timesTable.snp.updateConstraints { make in
            make.height.equalTo(rowHeight * (times.count + 1).cgfloat)
        }
    }
    
    private func loadTimes() {
        viewModel.loadRamadanTimes(currentRegion)
    }
}
