//
//  ReviewsPageAPI.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 20/07/22.
//

import Foundation
import OlchaCore
public enum ReviewType: String {
    case question = "question"
    case review = "comment"
}

public enum ReviewMainType {
    case main
    case reply
}

public enum ReviewsAPI: OlchaMarketAPI {
    case reviews(id: Int, page: Int)
    case faqs(id: Int, page: Int)
    case reviewsFiles(id: Int, page: Int)
    case like(commentID: Int)
    case dislike(commentID: Int)
    case sendFAQ(productID: Int, question: String)
    case sendReplyFAQ(productID: Int, question: String, repliedID: Int)
    case sendReview(model: ReviewRequestModel)
    case editReview(model: EditReviewRequestModel)
    case sendReplyReview(productID: Int, review: String, repliedID: Int)
    case myReviews(page: Int)
    case myFAQs(page: Int)
}
public extension ReviewsAPI {
    var queryItems: [URLQueryItem] {
        switch self {
        case .reviews(let id, let page):
            return [
                .init(name: "type", value: ReviewType.review.rawValue),
                .init(name: "page", value: "\(page)")
            ]
        case .faqs(let id, let page):
            return [
                .init(name: "type", value: ReviewType.question.rawValue),
                .init(name: "page", value: "\(page)")
            ]
        case .reviewsFiles(let id, let page):
            return [
                .init(name: "per_page", value: "5"),
                .init(name: "page", value: "\(page)")
            ]
        default: return []
        }
    }
    
    var path: String {
        switch self {
        case .reviews(let id, _):
            return "products/\(id)/comments"
        case .faqs(let id, _):
            return "products/\(id)/comments"
        case .reviewsFiles(let id, _):
            return "comments/\(id)/files"
        case .like:
            return "comments/like"
        case .dislike:
            return "comments/dislike"
        case .sendFAQ, .sendReview, .sendReplyReview, .sendReplyFAQ:
            return "comments"
        case .editReview(let model):
            return "comment/\(model.review_id)"
        case .myReviews(let page):
            return "user/comments?type=comment&page=\(page)"
        case .myFAQs(let page):
            return "user/comments?type=question&page=\(page)"
        }
    }
    
    public var method: RequestType {
        switch self {
        case .like, .dislike, .sendFAQ, .sendReview, .sendReplyReview, .sendReplyFAQ:
            return .post
        case .editReview:
            return .put
        default:
            return .get
        }
    }
    
    var body: Data? {
        var data: Data?
        
        switch self {
        case .like(let commentID), .dislike(let commentID):
            let model = LikeRequestModel(comment_id: "\(commentID)")
            do {
                data = try JSONEncoder().encode(model)
            } catch {}
        case .sendFAQ(let productID, let question):
            let model = QuestionRequestModel(review: question,
                                             type: ReviewType.question.rawValue,
                                             product_id: productID)
            do {
                data = try JSONEncoder().encode(model)
            } catch {}
            break
        case .sendReplyFAQ(let productID, let question, let repliedID):
            let model = QuestionReplyRequestModel(review: question,
                                                  type: ReviewType.question.rawValue,
                                                  product_id: productID,
                                                  review_id: repliedID)
            do {
                data = try JSONEncoder().encode(model)
            } catch {}
            break
        case .sendReview(let model):
            do {
                data = try JSONEncoder().encode(model)
            } catch {}
            break
        case .editReview(let model):
            data = encode(model)
            break
        case .sendReplyReview(let productID, let review,let repliedID):
            let model = ReviewReplyRequestModel(review: review,
                                                type: ReviewType.review.rawValue,
                                                product_id: productID,
                                                review_id: repliedID,
                                                rating: 5.0)
            
            do {
                data = try JSONEncoder().encode(model)
            } catch {}
            break
        default: break
        }
        return data
    }
    
    
}
