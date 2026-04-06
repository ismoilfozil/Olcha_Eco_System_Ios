
import Foundation

public struct UsersAddressModel : Codable {
    var message: String?
    var status: String?
    var data: UsersAddressModelData?
}

public struct UsersAddressModelData : Codable {
    var data: [UserAddress]?
}

public class UserAddress : Codable, Equatable {
    public static func == (lhs: UserAddress, rhs: UserAddress) -> Bool {
        (lhs.id ?? -1) == (rhs.id ?? -2)
    }
    
    var id: Int?
    var user_id: Int?
    var street: String?
    var house_number: String?
    var floor: String?
    var entrance: String?
    var apartment: String?
    var main_address: Int?
    var lat: String?
    var lng: String?
    var region: District?
    var district: District?
    var region_id: Int?
    var district_id: Int?
    func isMainAddress() -> Bool {
        (main_address ?? 0) == 1
    }
    
    func getRegionID() -> Int? {
        region?.id ?? region_id
    }
    
    func getDistrictID() -> Int? {
        district?.id ?? district_id
    }
    
    func getFullAddress() -> String {
        var addressList: [String] = [
            region?.name ?? "",
            .lang(district?.name_ru,
                  district?.name_uz,
                  district?.name_oz),
            ((street ?? "") + " " + (house_number ?? ""))
        ]
        
        addressList = addressList.filter { $0.replacingOccurrences(of: " ", with: "") != "" }
        
        return addressList.joined(separator: ", ")
    }
}

public struct District : Codable {
    var id: Int?
    var parent_id: Int?
    var name_uz: String?
    var name_oz: String?
    var name_ru: String?
    var lft: Int?
    var rgt: Int?
    var alias: String?
    var depth: Int?
    var name: String?
    
    func getName() -> String {
//        if let name = name {
//            return name
//        } else {
        return .lang(name_ru,
                     name_uz,
                     name_oz)
//        }
    }
}
