//
//  VariationHelper.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 18/07/22.
//

import UIKit
import SwiftyJSON
import Combine
class CustomError: Error {}
class VariationHelper {
    
    static let imageSize: CGFloat = 110
    static let textSize: CGFloat = 90
    
    private var resultVariation : GetVariationData?
    
    private var combinationsJSON: JSON?
    
    var combinationOptions: [Int: Int] = [:]
    
    var selectedOptions: [Int: Int] = [:]

    var resultVariations: [GetVariationData] = []
    
    var combinations: [String: Combination] = [:]
    
    let productLoader = PassthroughSubject<String, Never>()
    let productLoaderError = PassthroughSubject<String, Never>()
    
    
    
    func checkCombination(featureID: Int?) -> [Int: Int] {
        guard let featureID = featureID else { return [:] }
        var xSelectedOptions : [Int: Int] = [:]
        xSelectedOptions = selectedOptions
        xSelectedOptions[featureID] = -1//x element
        return xSelectedOptions
    }
    
    func variation(id: Int?, valueID: Int?) {
        guard let variationID = id else { return }
        guard let valueID = valueID else { return }
        selectedOptions[variationID] = valueID
        combinationOptions[variationID] = valueID
        
        let combinationId = getCombination()
        
        for index in 0..<resultVariations.count {
            for i in 0..<(resultVariations[index].data?.count ?? 0) {
                if (resultVariations[index].id == variationID && resultVariations[index].data?[i].feature_value_id == valueID) {
                    resultVariations[index].data?[i].active = true
                } else if (resultVariations[index].id == variationID) {
                    resultVariations[index].data?[i].active = false
                }
            }
        }
        
        let combination: Combination? = combinations[combinationId]
        
        if (combination?.alias ?? "") != "" {
            self.productLoader.send(combination?.alias ?? "")
        } else {
            self.productLoaderError.send("empty_product".localized())
        }
    }
    
    
    private func convertCombinations(jsonData: JSON) {
        let combinations = jsonData["data"]["combinations"]
        self.combinationsJSON = combinations
    }
    
    private func getProductAlias(by options: [PostOptionJSON]) -> String? {
        let aliasID = options
            .map { "\($0.value_id)" }
            .joined(separator: ".")
        let alias = self.combinationsJSON?["\(aliasID)"]["alias"].stringValue
        return alias
    }
    
    private func isProductActive() -> Bool {
        return (combinations[ getCombination() ]?.status ?? 0) == 1
    }
    
    private func getCombination() -> String {
        if selectedOptions.count < combinationOptions.count {
            for option in combinationOptions {
                if selectedOptions[option.key] == nil {
                    selectedOptions[option.key] = option.value
                }
                if selectedOptions.count == combinationOptions.count {
                    break
                }
            }
        }

        
        var combinationId = ""
        for variation in resultVariations {
            if let id = variation.id {
                if let featureID = selectedOptions[id] {
                    combinationId += "\(featureID)."
                }
            }
        }
        if combinationId.last != nil {
            combinationId.removeLast()
        }
        return combinationId
    }

    func getTableHeight() -> CGFloat {
        var height: CGFloat = 0.0
        
        for variation in resultVariations {
            if variation.isImage {
                height += VariationHelper.imageSize
            } else {
                height += VariationHelper.textSize
            }
        }
        return height
    }
    
    func variationResultData(data: Data) {
        let jsonData = JSON(data)
        
        if jsonData["status"].stringValue == MarketTexts.status_ok {
            
            let data = jsonData["data"]
            let variationsData = data["variations"]
            let combinationData = data["combinations"]
            
            var variations = [GetVariationData]()
            
            let combinationDictionary = combinationData.dictionary ?? [:]
            var combinations: [String: Combination] = [:]
            
            for key in combinationDictionary.keys {
                do {
                    if let dataValue = try combinationDictionary[key]?.rawData() {
                        let value: Combination = try JSONDecoder().decode(Combination.self, from: dataValue)
                        combinations[key] = value
                    }
                    
                } catch {
                    debugPrint(error.localizedDescription)
                }
            }
            
            self.combinations = combinations
            
            for model in (variationsData.array ?? []) {
                do {
                    let dataValue = try model.rawData()
                    let value: GetVariationData? = try JSONDecoder().decode(GetVariationData.self,
                                                                            from: dataValue)
                    if let v = value {
                        variations.append(v)
                    }
                } catch {
                    debugPrint(error.localizedDescription)
                }
            }
            
            
            self.resultVariations = variations
            for vari in resultVariations {
                
                for val in (vari.data ?? []) {
                    
                    if let id = val.feature_id, let valueId = val.feature_value_id {
                        if combinationOptions[id] == nil {
                            combinationOptions[id] = valueId
                        }
                        
                    }
                }
            }
            
            self.variation(id: nil, valueID: nil)
            
            self.convertCombinations(jsonData: jsonData)
            self.defaultSelectedOptions()
            
        }
    }
    
    private func defaultSelectedOptions() {
        if selectedOptions.count == 0 {
            for i in 0..<resultVariations.count {
                for k in 0..<(resultVariations[i].data?.count ?? 0) {
                    if (resultVariations[i].data?[k].active ?? false) == true {
                        if let featureID = resultVariations[i].data?[k].feature_id {
                            if let valueID = resultVariations[i].data?[k].feature_value_id {
                                selectedOptions[featureID] = valueID
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getCombination(
        from combinations: [String: Combination],
        variations: [GetVariationData],
        currentID: Int,
        maskCombinations: [Int: Int]
    ) -> CombinationState {
        
        var newCombination: [Int: Int] = maskCombinations
        
        for combination in maskCombinations {
            /// -1 is the value of X element which is being checked
            if combination.value == -1 {
                newCombination[combination.key] = currentID
            }
        }
        
        var combinationId = ""
        
        for variation in variations {
            if let id = variation.id {
                if let featureID = newCombination[id] {
                    combinationId += "\(featureID)."
                }
            }
        }
        if combinationId.last != nil {
            combinationId.removeLast()
        }

        if let combination = combinations[combinationId] {
            let status = (combination.status ?? 0) == 1
            return (status) ? .enabled : .none
        } else {
            let countStatus = newCombination.count < variations.count
            return countStatus ? .none : .disabled
        }
    }
}
