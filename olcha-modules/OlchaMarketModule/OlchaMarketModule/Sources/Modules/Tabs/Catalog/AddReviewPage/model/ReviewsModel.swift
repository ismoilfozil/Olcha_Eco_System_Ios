//
//  ReviewsModel.swift
//  NewOlcha
//
//  Created by Muhammadjon on 2/20/21.
//


import UIKit
import OlchaAuth
import OlchaUI
import OlchaCore
struct ReviewsModel : Codable {
    var message: String?
    var status: String?
    var data: ReviewsData?
}
struct ReviewsData : Codable {
    var comments: [Comment]?
    var comment: Comment?
    var total_comments: TotalComments?
    var paginator: Paginator?
    
    static func mockData() -> Self {
        .init(comments: mockFAQs(),
              comment: nil,
              total_comments: nil,
              paginator: .init(current_page: nil,
                               first_page_url: nil, from: nil, last_page: nil, last_page_url: nil, next_page_url: nil, path: nil, prev_page_url: nil, to: nil, total: 10))
    }
    
    static func mockFAQs() -> [Comment] {
        var comments: [Comment] = []
        
        
        let subComment1 = Comment(id: -101,
                              product_id: nil,
                              rating: 5.0,
                              review: "Sub faq text 1",
                              files: [],
                              user: .init(id: nil,
                                          name: "Elbek",
                                          lastname: nil,
                                          activate: nil,
                                          blocked: nil,
                                          gender: nil, birthdate: nil,
                                          is_verified: nil,
                                          phone: nil),
                              comment_rating: .init(like: 12,
                                                    dislike: 9,
                                                    is_like: true,
                                                    is_dislike: false),
                              created_at: "17.11.2021 09:00",
                              commentHeight: nil,
                                  child: [],
                                  textHeight: 0)
        let subComment2 = Comment(id: -101,
                              product_id: nil,
                              rating: 5.0,
                              review: "Sub faq text 2",
                              files: [],
                              user: .init(id: nil,
                                          name: "Alisher",
                                          lastname: nil,
                                          activate: nil,
                                          blocked: nil,
                                          gender: nil, birthdate: nil,
                                          is_verified: nil,
                                          phone: nil),
                              comment_rating: .init(like: 12,
                                                    dislike: 9,
                                                    is_like: true,
                                                    is_dislike: false),
                              created_at: "17.11.2021 09:00",
                                  commentHeight: nil, child: [subComment1],
                                  textHeight: 0)
        
        let mainComment1 = Comment(id: -101,
                              product_id: nil,
                              rating: 5.0,
                              review: "Main faq text",
                              files: [],
                              user: .init(id: nil,
                                          name: "Yusuf",
                                          lastname: nil,
                                          activate: nil,
                                          blocked: nil,
                                          gender: nil, birthdate: nil,
                                          is_verified: nil,
                                          phone: nil),
                              comment_rating: .init(like: 12,
                                                    dislike: 9,
                                                    is_like: true,
                                                    is_dislike: false),
                              created_at: "17.11.2021 09:00",
                              commentHeight: nil, child: [subComment1],
                                   textHeight: 0)
        
        
        let mainComment2 = Comment(id: -101,
                              product_id: nil,
                              rating: 5.0,
                              review: "Main faq text 2",
                              files: [],
                              user: .init(id: nil,
                                          name: "Ahmad",
                                          lastname: nil,
                                          activate: nil,
                                          blocked: nil,
                                          gender: nil, birthdate: nil,
                                          is_verified: nil,
                                          phone: nil),
                              comment_rating: .init(like: 12,
                                                    dislike: 9,
                                                    is_like: true,
                                                    is_dislike: false),
                              created_at: "17.11.2021 09:00",
                              commentHeight: nil, child: [subComment1, subComment2],
                                   textHeight: 0)
        
        
        let mainComment3 = Comment(id: -101,
                              product_id: nil,
                              rating: 5.0,
                              review: "Main faq text 3",
                              files: [],
                              user: .init(id: nil,
                                          name: "Ulug'bek",
                                          lastname: nil,
                                          activate: nil,
                                          blocked: nil,
                                          gender: nil, birthdate: nil,
                                          is_verified: nil,
                                          phone: nil),
                              comment_rating: .init(like: 12,
                                                    dislike: 9,
                                                    is_like: true,
                                                    is_dislike: false),
                              created_at: "17.11.2021 09:00",
                              commentHeight: nil, child: [subComment1, subComment2],
                                   textHeight: 0)
        
        
        let mainComment4 = Comment(id: -101,
                              product_id: nil,
                              rating: 5.0,
                              review: "Main faq text 4",
                              files: [],
                              user: .init(id: nil,
                                          name: "Farrux",
                                          lastname: nil,
                                          activate: nil,
                                          blocked: nil,
                                          gender: nil, birthdate: nil,
                                          is_verified: nil,
                                          phone: nil),
                              comment_rating: .init(like: 12,
                                                    dislike: 9,
                                                    is_like: true,
                                                    is_dislike: false),
                              created_at: "17.11.2021 09:00",
                              commentHeight: nil, child: [subComment2],
                                   textHeight: 0)
        comments.append(mainComment1)
        comments.append(mainComment2)
        comments.append(mainComment3)
        comments.append(mainComment4)
        comments.append(subComment1)
        return comments
    }
}

struct TotalComments : Codable {
    var count: Int?
    var rating: Double?
    var rating_count: [Int]?
    
    private enum CodingKeys: String, CodingKey {
        case count
        case rating
        case rating_count
    }
    
    init(count: Int? = nil, rating: Double? = nil, rating_count: [Int]? = nil) {
        self.count = count
        self.rating = rating
        self.rating_count = rating_count
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        count = try container.decode(Int.self, forKey: .count)
        rating_count = try container.decode([Int].self, forKey: .rating_count)
        
        do {
            rating = try container.decode(Double.self, forKey: .rating)
        } catch DecodingError.typeMismatch {
            rating = try Double(container.decode(Int.self, forKey: .rating))
        }
    }
}

public struct Comment : Codable {
    var id: Int?
    var product_id: Int?
    var rating: Double?
    var review: String?
    var files: [File]?
    var user: User?
    var comment_rating: CommentRating?
    var created_at: String?
    var commentHeight: CGFloat?
    var child: [Comment]?
    var textHeight: CGFloat?
    var product: ProductModel?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case product_id
        case rating
        case review
        case files
        case user
        case comment_rating
        case created_at
        case child
        case product
    }
    
    public init(
        id: Int?,
        product_id: Int?,
        rating: Double?,
        review: String?,
        files: [File]?,
        user: User?,
        comment_rating: CommentRating?,
        created_at: String?,
        commentHeight: CGFloat?,
        child: [Comment]?,
        textHeight: CGFloat?,
        product: ProductModel? = nil
    ) {
        self.id = id
        self.product_id = product_id
        self.rating = rating
        self.review = review
        self.files = files
        self.user = user
        self.comment_rating = comment_rating
        self.created_at = created_at
        self.commentHeight = commentHeight
        self.child = child
        self.textHeight = textHeight
        self.product = product
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            id = try container.decode(Int?.self, forKey: .id)
        } catch {}
        do {
            product_id = try container.decode(Int?.self, forKey: .product_id)
        } catch {}
        do {
            review = try container.decode(String?.self, forKey: .review)
        } catch {}
        do {
            files = try container.decode([File]?.self, forKey: .files)
        } catch {}
        
        do {
            user = try container.decode(User?.self, forKey: .user)
        } catch {}
        
        do {
            comment_rating = try container.decode(CommentRating?.self, forKey: .comment_rating)
        } catch {}
        
        do {
            created_at = try container.decode(String?.self, forKey: .created_at)
        } catch {}
        
        do {
            child = try container.decode([Comment]?.self, forKey: .child)
        } catch {}
        
        do {
            product = try container.decode(ProductModel?.self, forKey: .product)
        } catch {}
        
        do {
            rating = try container.decode(Double?.self, forKey: .rating)
        } catch DecodingError.typeMismatch {
            rating = try Double(container.decode(Int?.self, forKey: .rating) ?? 0)
        }
    }
    
    static func mock() -> Self {
        Comment(id: 1, product_id: nil, rating: 4, review: "TEST REVIEW", files: [], user: nil, comment_rating: .init(like: 5, dislike: nil, is_like: nil, is_dislike: nil), created_at: nil, commentHeight: nil, child: nil, textHeight: nil)
    }
}

public struct CommentRating : Codable {
    var like: Int?
    var dislike: Int?
    var is_like: Bool?
    var is_dislike: Bool?
}
