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
    public var displayPercentage: Double {
        is_verified == true ? 100 : percentage.orZero
    }

    private enum CodingKeys: String, CodingKey {
        case step
        case is_verified
        case percentage
        case steps
        case status
        case time_amount
        case last_requested
        case status_text
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        step = try container.decodeIfPresent(Int.self, forKey: .step)
        is_verified = try container.decodeIfPresent(Bool.self, forKey: .is_verified)
        percentage = try container.decodeIfPresent(Double.self, forKey: .percentage)
        steps = try container.decodeIfPresent([VerificationStep].self, forKey: .steps) ?? []
        status = try container.decodeIfPresent(VerificationStatusType.self, forKey: .status)
        time_amount = try container.decodeIfPresent(Double.self, forKey: .time_amount)
        last_requested = try container.decodeIfPresent(Double.self, forKey: .last_requested)
        status_text = try container.decodeIfPresent(String.self, forKey: .status_text)
    }

    public init(step: Int?,
                is_verified: Bool?,
                percentage: Double?,
                steps: [VerificationStep],
                status: VerificationStatusType?,
                time_amount: Double?,
                last_requested: Double?,
                status_text: String?) {
        self.step = step
        self.is_verified = is_verified
        self.percentage = percentage
        self.steps = steps
        self.status = status
        self.time_amount = time_amount
        self.last_requested = last_requested
        self.status_text = status_text
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(step, forKey: .step)
        try container.encodeIfPresent(is_verified, forKey: .is_verified)
        try container.encodeIfPresent(percentage, forKey: .percentage)
        try container.encode(steps, forKey: .steps)
        try container.encodeIfPresent(status, forKey: .status)
        try container.encodeIfPresent(time_amount, forKey: .time_amount)
        try container.encodeIfPresent(last_requested, forKey: .last_requested)
        try container.encodeIfPresent(status_text, forKey: .status_text)
    }

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
