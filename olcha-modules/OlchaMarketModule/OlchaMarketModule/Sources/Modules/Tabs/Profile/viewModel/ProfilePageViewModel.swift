//
//  ProfilePageViewModel.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 16/09/22.
//

import Foundation
import Combine
import OlchaAuth
import OlchaUI
import OlchaCore

public class ProfilePageViewModel: OldBaseViewModel {
    static let shared = ProfilePageViewModel()
    
    @Published var bonus: Bonus?
    @Published var user: User?
    @Published var notificationsData: NotificationsData?
    @Published var notificationsError = false
    @Published var settings: [ProfilePage.Section] = []
    
    @Published var ramazanTimes: [PrayTimeModel] = []
    
    let userIndicator = CurrentValueSubject<Bool, Never>(false)
    let bonusIndicator = CurrentValueSubject<Bool, Never>(false)
    
    init() {
        super.init(manager: OlchaDIContainer.shared.resolve())
    }
    
    func loadUserData(withIndicator: Bool = false) {
        guard AuthGlobalDefaults.isUser() else { return }
        let api: ProfileAPI = .userDatas
        self.startRequesting(api: api,
                             indicator: withIndicator ? userIndicator : nil) { [weak self] (data: UserData?) in
            guard let self = self else { return }
            self.user = data?.user
            AuthGlobalDefaults.user.id = data?.user?.id
            AuthGlobalDefaults.user.name = data?.user?.name
            AuthGlobalDefaults.user.phone = data?.user?.phone?.phoneNumber
            AuthGlobalDefaults.user.created_at = data?.user?.created_at
        }
        
    }
    
    func updateUser(user: User?) {
        guard let user = user, AuthGlobalDefaults.isUser() else { return }
        
        let model: EditUserProtocol = user.getEditUser()

        let api: ProfileAPI = .editUserDatas(model: model)
        self.startRequesting(api: api) { (data: EmptyData?) in }
        
    }
    
    func loadNotifications(page: Int) {
        guard AuthGlobalDefaults.isUser() else { return }
        let api: ProfileAPI = .notifications(page: page)
        self.startRequesting(api: api) { [weak self] (data: NotificationsData?) in
            guard let self = self else { return }
            self.notificationsData = data
        } onError: { [weak self] message in
            guard let self = self else { return }
            self.show(error: message)
            self.notificationsError = true
        }
    }
    
    func readNotification(id: Int) {
        guard AuthGlobalDefaults.isUser() else { return }
        let api: ProfileAPI = .readNotification(id: id)
        self.startRequesting(api: api, onCompleted: { (data: EmptyData?) in })
    }
    
    func registerNotification() {
        let api: ProfileAPI = .notification
        self.startRequesting(api: api, onCompleted: { (data: EmptyData?) in }) { _ in }
    }
    
    func loadBonus(withIndicator: Bool = false) {
        guard AuthGlobalDefaults.isUser() else { return }
        let api: CheckoutAPI = .bonus
        self.startRequesting(api: api,
                             indicator: withIndicator ? bonusIndicator : nil) { [weak self] (data: Bonus?) in
            guard let self = self else { return }
            self.bonus = data
        }
    }
    
    func loadUserSettings() {
        guard AuthGlobalDefaults.isUser() else { return }
        let api: ProfileAPI = .settings
        self.startRequesting(api: api) { [weak self] (data: SettingsData?) in
            guard let self = self,
                  let data = data else { return }
            self.settings = (data.settings ?? []).compactMap {
                guard let type = $0.type else {
                    return nil
                }
                return ProfilePage.Section(rawValue: type)
            }
        }
    }
    
    func loadRamadanTimes(_ region: District?) {
        let api: ProfileAPI = .prayTimes(type: .ramadan, region_id: region?.id)
        
        self.startRequesting(api: api, centerLoader: true) { [weak self] (data: RamazanTimesData?) in
            guard let self = self else { return }
            self.ramazanTimes = data?.timings ?? []
        }
    }
    
    func registerRamazanTaqvim(_ status: Bool) {

        OlchaGlobalDefaults.user.ramazanPrayNotifications = status
        NotificationHelper.setRamazanPrayNotification(status)
        
    }
}
