//
//  NetworkUtils.swift
//  OlchaCore
//
//  Created by Elbek Khasanov on 17/03/23.
//

import Foundation
import SwiftyJSON
class NetworkUtils {
    
}

public extension Data {
    func decodeData<Output: Codable>() throws -> Output {
        let decoder = JSONDecoder()
        return try decoder.decode(Output.self, from: self)
    }
}

public extension String {
    ///First we replaced all "?" symbols to -> "&", afterthat we replaced first "&" symbol to "?"
    public var correctQueryItems: String {
        guard let index = self.indexInt(of: "?") else {
            return self
        }
        return .replace(self.replacingOccurrences(of: "?", with: "&"),
                        index,
                        "?")
    }
    
    
    func indexInt(of char: Character) -> Int? {
        return firstIndex(of: char)?.utf16Offset(in: self)
    }
    
    static func replace(_ str: String, _ index: Int, _ newChar: Character) -> String {
        var chars = Array(str)
        if index < chars.count {
            chars[index] = newChar
        }
        let modifiedString = String(chars)
        return modifiedString
    }
}
