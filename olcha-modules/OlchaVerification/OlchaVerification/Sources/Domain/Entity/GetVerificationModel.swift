//
//  GetVerificationModel.swift
//  NewOlcha
//
//  Created by Firdavs Zokirov  on 07/01/22.
//

import Foundation

//first
struct GetVerificationFirstStepModel : Codable {
    var message: String?
    var status: String?
    var status_code: Int?
    var data: GetVerificationFirstStepData?
}

struct GetVerificationFirstStepData : Codable {
    var family_status : Int?
    var work_company_name : String?
    var seniority : String?
    var work_month_price : String?
    var industry : String
}



//second
struct GetVerificationSecondStepModel : Codable {
    var message: String?
    var status: String?
    var status_code: Int?
    var data: GetVerificationSecondStepData?
}

struct GetVerificationSecondStepData : Codable {
    var original_name: String?
    var type: String?
    var file_name: String?
    var absolutePath: String?
}


//third
struct GetVerificationThirdStepModel : Codable {
    var message: String?
    var status: String?
    var status_code: Int?
    var data: GetVerificationThirdStepData?
}

struct GetVerificationThirdStepData : Codable {
    
}
