//
//  ReviewFileModel.swift
//  NewOlcha
//
//  Created by Muhammadjon on 2/28/21.
//

import Foundation

public struct ReviewFileModel : Codable {
    var data: ReviewFileData?
    var message: String?
    var status: String?
}

public struct ReviewFileData : Codable {
    public var file: File?
}

public struct File : Codable {
    public var file_extension: String?
    public var file_name: String?
    public var file_path: String?
    public var file_size: Int?
    public var full_path: String?
    public var id: Int?
    public var mime_type: String?
    
    public init(file_extension: String? = nil, file_name: String? = nil, file_path: String? = nil, file_size: Int? = nil, full_path: String? = nil, id: Int? = nil, mime_type: String? = nil) {
        self.file_extension = file_extension
        self.file_name = file_name
        self.file_path = file_path
        self.file_size = file_size
        self.full_path = full_path
        self.id = id
        self.mime_type = mime_type
    }
}
