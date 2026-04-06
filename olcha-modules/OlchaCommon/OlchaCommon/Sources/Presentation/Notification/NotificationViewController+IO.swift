//
//  NotificationViewController+IO.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 25/07/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import OlchaUtils

public extension NotificationViewController {
    
    struct Input {
        var notifications = PagingData<CommonNotificationModel>()
        public init() {}
    }
    
    struct Output {
        public init() {}
    }
    
}
