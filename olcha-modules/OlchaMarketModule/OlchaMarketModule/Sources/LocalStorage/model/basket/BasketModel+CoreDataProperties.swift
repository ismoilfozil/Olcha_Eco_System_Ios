//
//  BasketModel+CoreDataProperties.swift
//  
//
//  Created by Elbek Khasanov on 28/07/22.
//
//

import Foundation
import CoreData


extension BasketModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BasketModel> {
        return NSFetchRequest<BasketModel>(entityName: BasketModel.className())
    }

    @NSManaged public var product_id: Int64
    @NSManaged public var store_id: Int64
    @NSManaged public var count: Int16
    @NSManaged public var product: Data?

}
