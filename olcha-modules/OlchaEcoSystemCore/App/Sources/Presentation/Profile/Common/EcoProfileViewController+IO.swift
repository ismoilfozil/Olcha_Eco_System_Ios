import OlchaUtils
import OlchaCommon
import OlchaAuth

public extension EcoProfileViewController {
    struct Input {
        public var notifications = PagingData<CommonNotificationModel>()
        public var user: User?
        public init() {}
    }
    
    struct Output {
        public init() {}
    }
}
