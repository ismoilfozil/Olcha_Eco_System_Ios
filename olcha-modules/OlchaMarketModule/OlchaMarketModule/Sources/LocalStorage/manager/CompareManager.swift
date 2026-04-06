//
//  CompareManager.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 12/08/22.
//

import UIKit
import CoreData

final class CompareManager: BaseStorageManager<CompareModel, ProductModel> {
    
    override init(context: NSManagedObjectContext) {
        super.init(context: context)
    }
    
    func addToCompare(product: ProductModel?) async -> ProductModel? {
        return await add(
            output: product,
            
            checkIsExist: { product -> [NSPredicate] in
                guard let id = product.id else { return [] }
                return [.init(format: "product_id == %@", id as NSNumber)]
            }, mapper: { (entity: CompareModel, model: ProductModel) -> CompareModel? in
                guard let productID = product?.id,
                      let categoryID = product?.category?.id else { return nil }
                let encoder = JSONEncoder()
                entity.product = try encoder.encode(model)
                entity.product_id = productID.int64
                entity.category_id = categoryID.int64
                return entity
            })
    }
    
    func removeCompare(product: ProductModel?) async -> Bool {
        return await remove {
            guard let id = product?.id else { return [] }
            return [ .init(format: "product_id == %@", id as NSNumber) ]
        }
    }
    
    func removeCompare(category: CategoryModel?) async -> Bool {
        return await remove {
            guard let id = category?.id else { return [] }
            return [ .init(format: "category_id == %@", id as NSNumber) ]
        }
    }
    
    func loadCompareProducts() async -> [ProductModel] {
        return await getModels { entity in
            let decoder = JSONDecoder()
            guard let data = entity.product else { return nil }
            let model = try decoder.decode(ProductModel.self, from: data)
            return model
        }.reversed()
    }
    
    func isAddedCompare(product: ProductModel?) async -> Bool {
        guard let id = product?.id else { return false }
        let models = await getModels(
            predicates: [.init(format: "product_id == %@", id as NSNumber)]) { entity in
                let decoder = JSONDecoder()
                guard let data = entity.product else { return nil }
                let model = try decoder.decode(ProductModel.self, from: data)
                return model
            }
        
        return !models.isEmpty
    }
}
