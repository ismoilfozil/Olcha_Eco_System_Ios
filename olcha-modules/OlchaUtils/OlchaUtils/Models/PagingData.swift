//
//  PagingData.swift
//  OlchaUtils
//
//  Created by Elbek Khasanov on 12/05/23.
//

import Foundation
import OlchaCore
public class PagingData<Model> {
    public var paging = Paging()
    public var models: [Model] = []
    
    public var modelsCount: Int {
        models.count
    }
    
    public init(paging: Paging = .init()) {
        self.paging = paging
    }
    
    public func append(_ models: [Model]?) {
        self.models.append(contentsOf: models ?? [])
    }
    
    public func reset() {
        paging.reset()
        models.removeAll()
    }
}
