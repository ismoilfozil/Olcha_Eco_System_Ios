//
//  NewsModel.swift
//  NewOlcha
//
//  Created by Muhammadjon on 2/15/21.
//

import Foundation
struct NewsModel: Codable {
    var message: String?
    var status: String?
    var data: NewsData?
}

struct NewsData: Codable {
    var blog: Blog?
}
