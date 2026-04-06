//
//  DeeplinkHandler.swift
//  OlchaNasiyaModule
//
//  Created by Akhrorkhuja on 09/08/23.
//

import Foundation

public protocol DeeplinkHandlerProtocol {
    func canOpenURL(_ url: URL) -> Bool
    func openURL(_ url: URL)
}
