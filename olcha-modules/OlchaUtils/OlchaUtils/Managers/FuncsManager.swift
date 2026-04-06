//
//  FuncsManager.swift
//  OlchaUtils
//
//  Created by Elbek Khasanov on 13/10/23.
//

import UIKit
public class FuncsManager {
    public static func openURL(_ urlString: String?) {
        guard let urlString = urlString,
              let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
}
