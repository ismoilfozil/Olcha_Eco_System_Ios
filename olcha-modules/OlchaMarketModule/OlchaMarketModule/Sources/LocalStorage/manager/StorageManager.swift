//
//  StorageManager.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 28/07/22.
//

import UIKit
import CoreData
final class BasketStorageManager {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func getBasketProducts(productID: Int? = nil, storeID: Int? = nil) async ->  [BasketModelData] {
        return await getBasketProducts(product_id: productID, store_id: storeID)
    }
    
    @discardableResult
    func increaseBasket(productModel: ProductModel?) async -> BasketModel? {
        
        if let product = await isExist(product: productModel) {
           return await changeBasketCount(product: product, increase: true)
        } else {
           return await createBasket(productModel: productModel)
        }
        
    }
    
    func decreaseBasket(productModel: ProductModel?) async {
        if let product = await isExist(product: productModel) {
            await changeBasketCount(product: product, increase: false)
        }
    }
    
    @discardableResult
    func removeBasket(productModel: ProductModel?) async -> Bool {
        if let product = await isExist(product: productModel) {
            do {
                context.delete(product)
                try context.save()
                return true
            } catch {}
        }
        return false
    }
    
}

private extension BasketStorageManager {
    func getBasketProducts(product_id: Int?, store_id: Int?) async -> [BasketModelData] {
        
        let fetchRequest = BasketModel.fetchRequest()
        
        if let id = product_id {
            fetchRequest.predicate = getProductIDPredicate(id: id)
        }
        
        if let id = store_id {
            fetchRequest.predicate = getStoreIDPredicate(id: id)
        }
        
        do {
            let productModels = try context.fetch(fetchRequest)
            let decoder = JSONDecoder()
            var products : [BasketModelData] = []
            
            for model in productModels {
                let product_id = model.product_id.int
                let store_id = model.store_id.int
                
                if let data = model.product {
                    
                    let productModel =  try decoder.decode(ProductModel.self, from: data)
                    products.append(.init(product_id: product_id,
                                          store_id: store_id,
                                          product: productModel))
                    
                }
            }
            return products
        } catch {}
        return []
    }
    
    private func createBasket(productModel: ProductModel?) async -> BasketModel? {
        guard let entity = NSEntityDescription.insertNewObject(forEntityName: BasketModel.className(), into: context) as? BasketModel else { return nil }
        
        do {
            if let productID = productModel?.id,
               let storeID = productModel?.store?.id {
                let product = try JSONEncoder().encode(productModel)
                entity.product_id = productID.int64
                entity.store_id = storeID.int64
                entity.product = product
                try context.save()
                return entity
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
    
    private func isExist(product: ProductModel?) async -> BasketModel? {
        
        if let productID = product?.id,
           let storeID = product?.store?.id {
            let fetchRequest = BasketModel.fetchRequest()
            fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
                getProductIDPredicate(id: productID),
                getStoreIDPredicate(id: storeID)
            ])
            do {
                let productModels = try context.fetch(fetchRequest)
                return productModels.first
            } catch {
                return nil
            }
        }
        
        return nil
    }
    
    @discardableResult
    func changeBasketCount(product: BasketModel?, increase: Bool) async -> BasketModel? {
        if increase {
            product?.count = (product?.count ?? 0) + 1
        } else {
            if (product?.count ?? 0) > 0 {
                product?.count = (product?.count ?? 0) - 1
            }
        }
        do {
            try context.save()
        } catch {}
        return product
    }
    
    
    func getProductIDPredicate(id: Int) -> NSPredicate {
        .init(format: "product_id == %@", id)
    }
    
    func getStoreIDPredicate(id: Int) -> NSPredicate {
        .init(format: "store_id == %@", id)
    }
}
