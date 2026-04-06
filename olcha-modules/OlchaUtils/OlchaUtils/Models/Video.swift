//
//  Video.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 03/08/22.
//

import Foundation
public struct Video {
    public let data: Data?
    public let url: URL?
    
    public init(data: Data?, url: URL?) {
        self.data = data
        self.url = url
    }
}
