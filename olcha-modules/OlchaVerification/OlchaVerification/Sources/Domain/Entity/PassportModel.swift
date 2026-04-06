//
//  VerificationModel.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 15/09/22.
//


import UIKit
public enum PassportType: String {
    case passport = "passport"
    case selfi = "passport_in_user"
    case registration = "registration"
}

public struct PassportModel {
    public let type: PassportType
    public let image: UIImage?
}

public struct DownloadedPassportData: Codable {
    var passport: AbsolutePathData?
    var registration: AbsolutePathData?
    var passport_in_user: AbsolutePathData?
}

public struct AbsolutePathData: Codable {
    var absolutePath: String?
}
