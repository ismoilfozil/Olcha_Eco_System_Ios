//
//  CompareModel+CoreDataProperties.swift
//  
//
//  Created by Elbek Khasanov on 12/08/22.
//
//

import Foundation
import CoreData


extension CompareModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CompareModel> {
        return NSFetchRequest<CompareModel>(entityName: "CompareModel")
    }

    @NSManaged public var product: Data?
    @NSManaged public var product_id: Int64
    @NSManaged public var category_id: Int64
}


