//
//  BillingTexts.swift
//  OlchaBilling
//
//  Created by Elbek Khasanov on 21/06/23.
//

import Foundation
open class BillingTexts {
    
    public struct url {
        
        public static func getVersion(_ v: Int? = nil) -> String {
            guard let v = v else { return "/api/" }
            return "/api/v\(v)/"
        }
        
        
    }
}
