import Foundation
import OlchaUtils

public struct ValidatedModel: Codable {
    var status: String?
    var message: String?
    var data: ValidatedData?
}

public struct ValidatedData: Codable {
    public var is_verified: Bool?
}

public struct VerificationModel : Codable {
    var status: String?
    var message: String?
    var data: VerificationData?
}

public struct VerificationData : Codable {
    public var step: Int?
    public var is_verified: Bool?
    
    public var percentage: Double?
    public var steps: [VerificationStep]
    public var status: VerificationStatusType?
    public var time_amount: Double?
    public var last_requested: Double?
    public var status_text: String?
    
    public func getStep() -> Int {
        if (is_verified ?? false) {
            return 3
        } else {
            return step ?? 0
        }
    }
    
    public func getSteps() -> [VerificationStatusStep] {
        var steps: [VerificationStatusStep] = []
        self.steps.forEach { step in
            guard step.percentage.orZero > 0 else { return }
            switch step.step {
            case "passport":
                steps.append(.identification)
            case "phone":
                steps.append(.phones)
            case "bank_cards":
                steps.append(.bankCard)
            default: break
            }
        }
        return steps
    }
    
    static func mock() -> VerificationData {
        VerificationData(step: 3,
                         is_verified: nil,
                         percentage: nil,
                         steps: [],
                         status: .approved,
                         time_amount: nil,
                         last_requested: nil,
                         status_text: "amount_increased_by_employee done!!!")
    }
}

public struct VerificationStep: Codable {
    public var step: String?
    public var percentage: Double?
}
