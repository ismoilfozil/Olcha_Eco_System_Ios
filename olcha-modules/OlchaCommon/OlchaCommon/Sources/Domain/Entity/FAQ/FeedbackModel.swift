import Foundation

public struct FeedbackModel: Codable {
    public let question: String?
    
    public init(question: String?) {
        self.question = question
    }
}
