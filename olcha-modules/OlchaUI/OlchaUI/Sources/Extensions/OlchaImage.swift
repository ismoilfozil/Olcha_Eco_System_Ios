//
//  UIImage+Extension.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 30/06/22.
//

import UIKit
import OlchaUtils
public extension UIImage {
    static func resolve(named: String, route: BundleType = .resources) -> UIImage? {
        return .init(named: named, in: Bundle(identifier: route.identifier), with: nil)
    }
    
    static let sayohatLogo = resolve(named: "sayohat-logo")
    static let networkError = resolve(named: "network-error")
    
    static let cart_info = resolve(named: "cart_info")
    
    //MARK: --- Settings
    static let olcha_logo = resolve(named: "olcha_main")
    static let user = resolve(named: "user")
    static let message_operator = resolve(named: "message_operator")
    static let offerta = resolve(named: "offerta")
    static let privacy_policy = resolve(named: "privacy_policy")
    static let call_operator = resolve(named: "call_operator")
    
    static let notifications = resolve(named: "notifications")
    static let settings = resolve(named: "settings")
    static let support = resolve(named: "support")
    static let logout = resolve(named: "logout")
    static let locked = resolve(named: "locked")
    static let globuse = resolve(named: "globuse")
    static let round_selected_check = resolve(named: "round_selected_check")
    static let qr = resolve(named: "qr")
    static let round_unselected_check = resolve(named: "round_unselected_check")
    
    static let humo = resolve(named: "humo")
    static let uzcard = resolve(named: "uzcard")
    //MARK: --- Settings
    
    static let plus = resolve(named: "plus")
    static let arrow_down = resolve(named: "arrow_down")
    static let arrow_up = resolve(named: "arrow_up")
    static let show_eye = resolve(named: "show_eye")
    static let dots = resolve(named: "dots")
    static let notification = resolve(named: "bell")
    
    
    static let olcha_pay = resolve(named: "olcha-pay")
    static let olcha_nasiya = resolve(named: "olcha-nasiya")
    static let olcha_market = resolve(named: "olcha-market")
    static let olcha_invest = resolve(named: "olcha-invest")
    static let olcha_eco = resolve(named: "olcha_eco_system")
    
    static let search = resolve(named: "search")
    static let radio_checked = resolve(named: "radio_checked")
    static let radio_unchecked = resolve(named: "radio_unchecked")
    static let success_payment = resolve(named: "success_payment")
    static let makro = resolve(named: "makro")
    static let profile = resolve(named: "profile")
    
    static let person = resolve(named: "person")
    static let profile_person = resolve(named: "profile_person")
    
    static let radio_unselected = resolve(named: "radio_unselected")
    
    static let radio_selected = resolve(named: "radio_selected")
    static let radio_selected_red = resolve(named: "radio_selected_red")
    
    static let radio_switch_on = resolve(named: "radio_switch_on")
    static let radio_switch_off = resolve(named: "radio_switch_off")
    
    static let x = resolve(named: "x")
    static let color_check = resolve(named: "color_check")
    static let hide_eye = resolve(named: "hide_eye")

    static let switch_on = resolve(named: "switch_on")
    static let switch_off = resolve(named: "switch_off")
    
    static let pay_main_tab = resolve(named: "tab_pay_main")
    static let pay_cards_tab = resolve(named: "tab_pay_cards")
    static let pay_payments_tab = resolve(named: "tab_pay_payments")
    
    static let connectionExpandIcon = resolve(named: "connection_expand")
    static let connectionBackground = resolve(named: "connection_background")
    static let connectionTelegram = resolve(named: "connection_telegram")
    static let connectionInstagram = resolve(named: "connection_instagram")
    static let clear = resolve(named: "clear")
    static let textfield_search = resolve(named: "textfield_search")
    
    static let left_anchor = resolve(named: "left_anchor")
    static let back_left_anchor = resolve(named: "back_left_anchor")
    static let left = resolve(named: "left")
    static let back_circle = resolve(named: "back_circle")
    
    static let beeline = resolve(named: "beeline")
    static let circle_add = resolve(named: "circle_add")
    static let rightIcon = resolve(named: "right_anchor")
    
    static let placeholder = resolve(named: "placeholder")
    static let unlike = resolve(named: "heart")
    static let flash = resolve(named: "flash")
    
    static let bottomIcon = resolve(named: "bottom_anchor")
    static let check = resolve(named: "check")
    
    static let search_white = resolve(named: "search_white")
    static let menu = resolve(named: "menu")
    static let anorbank = resolve(named: "anorbank")
    static let clock = resolve(named: "clock")
    
    static let simple_cart_plus = resolve(named: "simple_cart_plus")
    static let cart_minus = resolve(named: "cart_minus")
    static let cart_plus = resolve(named: "cart_plus")
    ///home nav bar
    static let callIcon = resolve(named: "call")
    static let bellIcon = resolve(named: "bell")
    static let olchaIcon = resolve(named: "olcha_main")
    static let olchaAppLogo = resolve(named: "olcha-app-logo")
    static let olchaInvoiceIcon = resolve(named: "olcha_invoice_main")
    static let search_bordered = resolve(named: "search_bordered")
    
    static let error = resolve(named: "error")
    static let finished = resolve(named: "finished")
    
    static let video_play = resolve(named: "video_play")
    
    static let heart_filled = resolve(named: "heart_filled")
    
    static let liked = resolve(named: "liked")
    static let unliked = resolve(named: "unliked")
    
    static let history = resolve(named: "history")
    static let delete_profile = resolve(named: "delete_profile")
    static let follow_order = resolve(named: "follow_order")
    static let defect_return_order = resolve(named: "defect_return_order")
    
    
    static let down_anchor = resolve(named: "down_anchor")
    static let down_anchor_black = resolve(named: "down_anchor_black")
    static let plus_circle = resolve(named: "plus_circle")
    
    static let pin = resolve(named: "pin")
    
    static let password_opened = resolve(named: "password_opened")
    static let password_closed = resolve(named: "password_closed")
    
    static let selfi = resolve(named: "selfi")
    static let passport = resolve(named: "passport")
    
    static let cart = resolve(named: "cart")
    static let empty_placeholder = resolve(named: "empty_placeholder")
    
    static let shrink = resolve(named: "shrink")
    static let expand = resolve(named: "expand")
    
    static let camera_white = resolve(named: "camera_white")
    static let upload = resolve(named: "upload")
    
    
    static let camera = resolve(named: "camera")
    static let camera_simple = resolve(named: "camera_simple")
    static let gallery = resolve(named: "gallery")
    
    
    static let red_track = resolve(named: "red_track")
    static let play = resolve(named: "play")
    static let eye = resolve(named: "eye")
    
    static let bag_active = resolve(named: "bag_active")
    
    static let unchecked = resolve(named: "unchecked")
    static let checked = resolve(named: "checked")
    static let check_light = resolve(named: "check_light")
    
    //MARK: - Cart
    static let touch_helper = resolve(named: "touch_helper")
    static let cart_bonus = resolve(named: "cart_bonus")
    static let cart_comment = resolve(named: "cart_comment")
    static let cart_comment_send = resolve(named: "cart_comment_send")
    static let cart_locations = resolve(named: "cart_locations")
    static let cart_order_type = resolve(named: "cart_order_type")
    static let cart_payment_type = resolve(named: "cart_payment_type")
    static let cart_profile = resolve(named: "cart_profile")
    static let cart_promocode = resolve(named: "cart_promocode")
    
    static let filter = resolve(named: "filter")
    
    static let eco_olcha = resolve(named: "eco_olcha")
    
    static let cancel_x = resolve(named: "cancel_x")
    static let video = resolve(named: "video")
    static let question = resolve(named: "question")
    static let verified = resolve(named: "verified")
    static let rank = resolve(named: "rank")
    static let warranty = resolve(named: "warranty")
    static let gift = resolve(named: "gift")

    static let info = resolve(named: "info")
    static let bag = resolve(named: "bag")
    static let truck_black = resolve(named: "truck_black")
    static let like = resolve(named: "like")
    static let dislike = resolve(named: "dislike")
    static let copy = resolve(named: "copy")
    
    static let cashback = resolve(named: "cashback")
    
    static let pen = resolve(named: "pen")
    static let edit_settings = resolve(named: "edit_settings")
    
    
    static let like_heart = resolve(named: "like_heart")
    static let like_heart_filled = resolve(named: "like_heart_filled")
    static let compare = resolve(named: "compare")
    static let compare_out = resolve(named: "compare_out")
    static let compare_out_selected = resolve(named: "compare_out_selected")
    static let share = resolve(named: "share")
    static let rating = resolve(named: "rating")
    static let minus = resolve(named: "minus")
    
    
    static let large_expanded = resolve(named: "large_expanded")
    static let large_shrinked = resolve(named: "large_shrinked")
    
    
    static let remove_image = resolve(named: "remove_image")
    static let send = resolve(named: "send")
    static let x_cancel = resolve(named: "x_cancel")
    static let category = resolve(named: "category")
    static let direction = resolve(named: "direction")
    
    static let cancel_circle = resolve(named: "cancel_circle")

    

    static let trash_circle = resolve(named: "trash_circle")
    static let trash_blue = resolve(named: "trash_blue")
    static let plus_blue = resolve(named: "plus_blue")
    
    static let attach_pin = resolve(named: "attach_pin")
    //MARK: - profile menu
    static let credit_datas = resolve(named: "credit_datas")
    static let orders = resolve(named: "orders")
    static let location = resolve(named: "location")
    static let favourites = resolve(named: "favourites")
    static let ramazan = resolve(named: "ramazan")
    
    static let empty_cashback = resolve(named: "empty_cashback")

    
    static let celebration = resolve(named: "celebration")
    static let percentage = resolve(named: "percentage")
    static let newspaper = resolve(named: "newspaper")
    static let truck = resolve(named: "truck")
    static let truck_loading = resolve(named: "truck_loading")
    
    //MARK: - tabs
    static let tab_home = resolve(named: "tab_home")
    static let tab_catalog = resolve(named: "tab_catalog")
    static let tab_profile = resolve(named: "tab_profile")
    static let tab_cart = resolve(named: "tab_cart")
    static let tab_favourite = resolve(named: "tab_favourite")

    
    static let gift_orange = resolve(named: "gift_orange")
    
    static let hiddenEye = resolve(named: "hide_eye")
    static let qr_check = resolve(named: "qr_check")//
    static let smile_well = resolve(named: "smile_well")//
    static let smile_neutral = resolve(named: "smile_neutral")//
    static let smile_bad = resolve(named: "smile_bad")//
    static let smile_angry = resolve(named: "smile_angry")//
    static let playing = resolve(named: "playing")//
    static let pausing = resolve(named: "pausing")//
    static let my_questions = resolve(named: "my_questions")
    static let my_reviews = resolve(named: "my_reviews")
    static let monitoring = resolve(named: "monitoring")
    
    static let uncolor_track = resolve(named: "uncolor_track")
    static let circle_red = resolve(named: "circle_red")
    
    static let multiply: UIImage? = resolve(named: "u_multiply")
    
    ///
    ///
    static let zebra_item = resolve(named: "zebra_item")
    static let circle_green = resolve(named: "circle_green")
    
    static let flagUz = resolve(named: "flag-uz")
    static let flagRu = resolve(named: "flag-ru")
    
    static let pay_cancel = resolve(named: "pay-cancel")
    static let pay_contact = resolve(named: "pay-contact")
    
    static let info_red = resolve(named: "info-red")
    
    func resizedImage(_ length: CGFloat) -> UIImage? {
        let frame = CGRect(origin: CGPoint.zero, size: CGSize(width: length, height: length))
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        self.draw(in: frame)
        let resizedImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.withRenderingMode(.alwaysOriginal)
        return resizedImage
    }
    
    func resizeImage(scale: CGFloat) -> UIImage {
        let newSize = CGSize(width: self.size.width*scale, height: self.size.height*scale)
        let rect = CGRect(origin: CGPoint.zero, size: newSize)
        
        UIGraphicsBeginImageContext(newSize)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func withColor(_ color: UIColor) -> UIImage? {
        return withTintColor(color, renderingMode: .alwaysOriginal)
    }
    
    func scaleTo(_ newSize: CGSize) -> UIImage {
        var newImage: UIImage?
//        UIImage.imageQueue.sync {
//            UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
//            self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
//            newImage = UIGraphicsGetImageFromCurrentImageContext()
//            UIGraphicsEndImageContext()
//        }
        return newImage ?? self
    }
}

public extension UIImage {
    static let imageQueue = DispatchQueue(label: "com.olcha.OlchaUI.image-queue", qos: .userInteractive)
}
    
//olcha-pay

public extension UIImage {
    static let onboarding_card = resolve(named: "onboarding_card")
    static let news_mock = resolve(named: "news_mock")
    static let news_mock_1 = resolve(named: "news_mock-1")
    static let news_mock_2 = resolve(named: "news_mock-2")
    static let news_mock_3 = resolve(named: "news_mock-3")
    static let mock_click = resolve(named: "mock_click")
    static let face_id = resolve(named: "face_id")
    static let touch_id = resolve(named: "touch_id")
    static let payment_finish = resolve(named: "payment_finish")
    
    static let `repeat` = resolve(named: "repeat")
    static let star = resolve(named: "star")
    static let unstar = resolve(named: "unstar")
    static let bordered_star = resolve(named: "bordered_star")
    
    static let detail = resolve(named: "detail")
    
}

public extension UIImage {
    static let denyVerification = resolve(named: "deny-verification")
    static let danger = resolve(named: "danger")
    static let tickCircle = resolve(named: "tick-circle")
    static let verifyBadge = resolve(named: "verify-badge")
    static let verificationApproved = resolve(named: "verification-approved")
    static let verificationRejected = resolve(named: "verification-rejected")
    static let verificationRequest = resolve(named: "verification-request")
}

public extension UIImage {
    static let loyalty_1 = resolve(named: "loyalty_1")
    static let loyalty_2 = resolve(named: "loyalty_2")
    static let loyalty_3 = resolve(named: "loyalty_3")
    static let loyalty_4 = resolve(named: "loyalty_4")
    static let loyalty_5 = resolve(named: "loyalty_5")
}
