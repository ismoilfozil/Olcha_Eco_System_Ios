//
//  ReviewRequestModel.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 02/08/22.
//

import Foundation
public struct ReviewRequestModel : Codable {
    let review: String
    let product_id: Int
    let rating: Double
    let files: [Int]
    let order_id: Int?
    let services: [ReviewService]
    let anonymous: Bool
}

public struct EditReviewRequestModel : Codable {
    let review_id: Int
    let review: String
    let rating: Double
    let files: [Int]
}


public struct ReviewService: Codable {
    let type: String
    let text: String
    let rating: Int
}

public struct QuestionRequestModel : Codable {
    let review: String
    let type: String
    let product_id: Int
}

public struct QuestionReplyRequestModel : Codable {
    let review: String
    let type: String
    let product_id: Int
    let review_id: Int
}

public struct ReviewReplyRequestModel : Codable {
    let review: String
    let type: String
    let product_id: Int
    let review_id: Int
    let rating: Double
}
