//
//  BaseStorageManager.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 12/08/22.
//

import Foundation
import CoreData

class BaseStorageManager<Input: NSManagedObject, Output> {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func getModels(
        predicates: [NSPredicate] = [],
        mapper: ((Input) throws -> Output?)
    ) async -> [Output] {
        
        let fetchRequest = Input.fetchRequest()
        
        
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        do {
            
            let entities: [Input]  = try (context.fetch(fetchRequest) as? [Input]) ?? []
            var models: [Output] = []
            for entity in entities {
                if let model = try mapper(entity) {
                    models.append(model)
                }
            }
            return models
            
        } catch {}
        return []
    }
    
    @discardableResult
    func add(
        output: Output?,
        checkIsExist: ((Output) throws -> [NSPredicate]),
        mapper: ((Input, Output) throws -> Input?)
    ) async -> Output? {
        
        
        guard let output = output else {
            return nil
        }
        
        do {
            let predicates = try checkIsExist(output)
            
            let isEmpty = try await isExist(predicates: predicates).isEmpty
            
            
            if isEmpty {
                
                guard let entity = NSEntityDescription.insertNewObject(forEntityName: Input.className(),
                                                                       into: context) as? Input else {
                    return nil
                }
                
                let input = try mapper(entity, output)
                if input != nil {
                    try context.save()
                    return output
                }
                
            }
            
        } catch {}
        return nil
    }
    
    @discardableResult
    func remove(
        mapper: () throws -> [NSPredicate]
    ) async -> Bool {
        do {
            let predicates = try mapper()
            if !predicates.isEmpty {
                let entities = try await isExist(predicates: predicates)
                    
                for entity in entities {
                    context.delete(entity)
                }
                    
                try context.save()
                return true
            }
        } catch {}
        
        return false
    }
    
    func isExist(
        predicates: [NSPredicate]
    ) async throws -> [Input] {
        let fetchRequest = Input.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        return try (context.fetch(fetchRequest) as? [Input]) ?? []
    }
}
