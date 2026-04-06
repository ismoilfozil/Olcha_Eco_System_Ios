//
//  Texts.swift
//  OlchaUtils
//
//  Created by Elbek Khasanov on 10/02/23.
//

import Foundation
open class Texts {
    
    public static let token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI2IiwianRpIjoiMGUzMmQ5YjExNDRiMzJmOTg1ZTQ4Yzk3NGVkOGJmMTkwMGY5OTBmNDYyN2Q2ZjQzMzRlNWMxMDkyMjcxODQ4OWM2MzkzMzAyYzU1YTNkZWMiLCJpYXQiOjE2ODQ5MDc3MTguNDY4MTcxLCJuYmYiOjE2ODQ5MDc3MTguNDY4MTc0LCJleHAiOjE2ODc0OTk3MTguNDYxOTU2LCJzdWIiOiIxNjkzODciLCJzY29wZXMiOltdfQ.GIOVdIkcuCZEeccrtAdZCM228TqovnWYkPq8NAsTdU5EM42-Cx0DVomHl-tfD1VI_6Cfc70_sS4AS6R3VEsrrCm_eRgbSIFY1Bjvja3BxwbhPWEA7BiwlqVmJby5z4djhdR0Rpv5_aW_2n6MChN7TmLbCiwxFz3HOGN7oiLMLklvtLd3OIElVcVwppvur-O_uQjogmHBzAkGiPXOgaz6YxWdcmfZzlp5ceLDtAM8ngqUUrZhusWjC_JaWC1L2e27S1R9Jy5mR1WyJNEqrMZVs1p35ODc2FBTWy8sl06cCBlhzhK1NBZ2BZB-n7Ns79N3IHC2yT0-uUO0yNb70L_9DVofumB0FWiqkDD5f0FRkpRvJqfeg0fQRdvDi25p8NbIcnn3iTs47wPlRotpqOAQD7XIR2sJSY0alTGDww6LIiI05P9ntd4ttW78pTu5CSPQoz4F61Uw0_z5QxLy3e62jen68J8Kt9OQsb8RtoFkk5uST2hM0aEZEQAzDit9ttMikHT_CcCQlfIDPJdZvsf84eV1RCdBA5wOI5EdhYbz0LF3TdqTh3GklIMLcHOTpzu9ir5vFkxasamXKQ5GjskMrYS2_w-JQfb22t-LBuyTncHoEavrL2437a5Wg9VYJ58nZ3hAw4EuTAfxuIIjFUrXpQJ3GfkCc9p3FE-ug4zQDq4"
    
    public struct urls {
        public static let olcha_phone = "+998(71)-202-202-1"
        public static let olcha_telegram = "https://t.me/olcha_support"
        public static let olcha = "https://www.olcha.uz"
        
        public static let telegram = "https://t.me/olchauz"
        public static let instagram = "https://www.instagram.com/olcha_uz/"
        public static let facebook = "https://www.facebook.com/profile.php?id=100092217454933&locale=ru_RU"
        
        public static let offerta = "https://www.instagram.com/olcha_uz/"
        public static let privacy = "https://www.instagram.com/olcha_uz/"
        public static let call = "https://www.instagram.com/olcha_uz/"
        public static let message = "https://www.instagram.com/olcha_uz/"
        
        public static let cashbackWeb = "http://92.204.168.110:4040"
    }
    
    public struct notificationTopics {
        public static let invest = "all_ios"
        public static let ecoSystem = "all_ios"
        public static let ecoSystemTest = "all_test_ios"
    }
    
    public struct sayohatUrl {
        public static var prod: String {
            "https://travel.webview.olcha.uz/\(String.getAppLanguage())"            
        }
        public static let test = "http://92.204.162.197/ru"
        nonisolated(unsafe) public static var base = prod
    }

    public struct groupUrls {
        public static let invest = "group.com.olcha.olcha-invest.NotificationServiceExtension"
        public static let ecoSystem = "group.com.olcha.ecommerce.NotificationServiceExtension"
        public static let nasiya = "group.com.ecommerce.olcha-nasiya"
    }
    
    public struct investUrl {
        public static let prod = "https://olchainvest.uz"
        public static let test = "http://134.119.188.213:4901"
        nonisolated(unsafe) public static var base = prod

        public static func toogleBaseUrl() {
            base = base == prod ? test : prod
        }
    }
    
    public struct socialUrl {
        public static let fbUrl = "https://www.facebook.com/profile.php?id=100092217454933"
        public static let igUrl = "https://www.instagram.com/olcha_uz/"
        public static let tgUrl = "https://t.me/olchauz"
        public static var publicOffer: String {
            "https://olcha.uz/\(String.getAppLanguage())/page/public-offer"
        }
    }
    
    public struct appUrl {
        public static let olchaUrl = "https://apps.apple.com/uz/app/olcha/id1551492785"
        public static let olchaInvestUrl = "https://apps.apple.com/uz/app/olcha-invest/id6450216864"
        public static let ecoSystemUrl = "https://apps.apple.com/us/app/olcha-eco-system/id6466405583"
        public static let nasiyaUrl = "https://apps.apple.com/us/app/olcha-nasiya/id6448916300"
    }
    
    public struct url {
        public static let mockBase = "https://647ee5ddc246f166da8f9867.mockapi.io/mockapi"
        
        public static let allUrls: [String] = [
            pay.base,
            olcha.base,
            auth.base,
            nasiya.base,
            common.base,
            billing.base
        ]
        
        public struct pay {
            public static let test = "http://92.204.253.20:9000"
            public static let prod = "https://pay.olcha.uz"
            nonisolated(unsafe) public static var base = prod
        }
        
        public struct olcha {
            public static var test: String {
                if Config.isTestFlightOrDebug {
                    return "http://92.204.254.100:4900"
                } else {
                    return prod
                }
                
            }
            public static let prod = "https://mobile.olcha.uz"
            nonisolated(unsafe) public static var base = prod
        }
        
        public struct auth {
            public static let test = "https://auth.olcha.uz/test"
            public static let prod = "https://auth.olcha.uz"
            nonisolated(unsafe) public static var base = prod
        }
        
        public struct nasiya {
            public static var test: String {
                if Config.isTestFlightOrDebug {
//                    return "http://92.204.254.100:4660"
                    return "http://134.119.179.99:4902"
                } else {
                    return prod
                }
            }
            public static let prod = "https://api.olchanasiya.uz"
            nonisolated(unsafe) public static var base = prod
        }
        
        public struct common {
            public static let test = "https://builder.olcha.uz"
            public static let prod = "https://builder.olcha.uz"
            nonisolated(unsafe) public static var base = prod
        }
        
        public struct billing {
            public static let test = "https://testbilling.olcha.uz"
            public static let prod = "https://billing.olcha.uz"
            nonisolated(unsafe) public static var base = prod
        }
        
        public struct cashback {
            public static let test = "https://cashback.olcha.uz"
            public static let prod = "https://cashback.olcha.uz"
            public static let base = prod
        }
        
        public static func getVersion(_ v: Int? = nil) -> String {
            guard let v = v else { return "/api/" }
            return "/api/v\(v)/"
        }
        
        public static func changeType() {
            if pay.base == pay.prod {
                pay.base = pay.test
            } else {
                pay.base = pay.prod
            }
            
            if olcha.base == olcha.prod {
                olcha.base = olcha.test
            } else {
                olcha.base = olcha.prod
            }
            
            auth.base = auth.base == auth.prod ? auth.test : auth.prod
            nasiya.base = nasiya.base == nasiya.prod ? nasiya.test : nasiya.prod
            billing.base = billing.base == billing.prod ? billing.test : billing.prod
            common.base = common.base == common.prod ? common.test : common.prod
        }
    }
    
    public static var currency: String {
        get {
            return "currency".localized()
        }
    }
    
    public static var fail: String {
        get {
            return "error_text".localized()
        }
    }
    
    public static var cash : String {
        get {
            "cash".localized()
        }
    }
    
    public static let anorbank_alias = "anorbank_instalment"
    
    public static let cash_alias = "cash"
    public static let fargo_alias = "fargo"
    public static let anorbank = "anorbank"
    
    public static let currency_alias = "UZS"
}
