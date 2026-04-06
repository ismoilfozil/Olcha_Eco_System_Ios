//
//  CommentFilesData.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 20/07/22.
//

import Foundation
import OlchaCore
import OlchaUI
public struct ReviewFilesData : Codable {
    var files: [File]?
    var paginator: Paginator?
}
