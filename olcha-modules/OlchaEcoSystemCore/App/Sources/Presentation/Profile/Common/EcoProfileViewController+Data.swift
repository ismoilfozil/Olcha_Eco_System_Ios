import UIKit
import OlchaUI
import OlchaAuth

public extension EcoProfileViewController {
    var sections: [Section] {
        AuthGlobalDefaults.isUser() ? [.orders, .products, .information, .main] : [.login, .application]
    }
    
    enum Section {
        case login
        case orders
        case products
        case information
        case main
        case application
        
        var rows: [RowProtocol] {
            switch self {
            case .login:
                return [LoginRow.login]
            case .application:
                return [ApplicationRow.settings, ApplicationRow.about, ApplicationRow.support]
            case .orders:
                return [OrderRow.myOrders, OrderRow.refundAndExchange, OrderRow.ticketsAndTours, OrderRow.favorites]
            case .products:
                return [ProductRow.comments, ProductRow.compare, ProductRow.myQuestionsAndAnswers]
            case .information:
                return [InformationRow.myCards, InformationRow.bonusProgram, InformationRow.installmentData, InformationRow.notifications, InformationRow.addresses, InformationRow.security]
            case .main:
                return [MainRow.settings, MainRow.about, MainRow.help, MainRow.logout, MainRow.delete]
            }
        }
        
        var title: String? {
            switch self {
            case .login: return nil
            case .application:
                return "profile_section_application".localized(.olchaEcoSystemCore)
            case .orders:
                return "profile_section_orders".localized(.olchaEcoSystemCore)
            case .products:
                return "profile_section_products".localized(.olchaEcoSystemCore)
            case .information:
                return "profile_section_information".localized(.olchaEcoSystemCore)
            case .main: return nil
            }
        }
    }
    
    enum LoginRow: RowProtocol {
        case login
        
        public var title: String {
            return ""
        }
        public var image: UIImage? {
            return nil
        }
    }
    
    enum ApplicationRow: RowProtocol {
        case settings
        case about
        case support
        
        public var title: String {
            switch self {
            case .about:
                return "profile_row_about_app".localized(.olchaEcoSystemCore)
            case .settings:
                return "profile_row_settings".localized(.olchaEcoSystemCore)
            case .support:
                return "profile_row_help".localized(.olchaEcoSystemCore)
            }
        }
        
        public var image: UIImage? {
            return nil
        }
    }
    
    enum OrderRow: RowProtocol {
        case myOrders
        case refundAndExchange
        case ticketsAndTours
        case favorites
        
        public var title: String {
            switch self {
            case .myOrders: return "profile_row_my_orders".localized(.olchaEcoSystemCore)
            case .refundAndExchange: return "profile_row_refund_exchange".localized(.olchaEcoSystemCore)
            case .ticketsAndTours: return "profile_row_tickets_tours".localized(.olchaEcoSystemCore)
            case .favorites: return "profile_row_favorites".localized(.olchaEcoSystemCore)
            }
        }
        
        public var image: UIImage? {
            switch self {
            case .myOrders: return .ordersIcon
            case .refundAndExchange: return .refundIcon
            case .ticketsAndTours: return .ticketsIcon
            case .favorites: return .favoritesIcon
            }
        }
    }
    
    enum ProductRow: RowProtocol {
        case comments
        case compare
        case myQuestionsAndAnswers
        
        public var title: String {
            switch self {
            case .comments: return "profile_row_comments".localized(.olchaEcoSystemCore)
            case .compare: return "profile_row_compare".localized(.olchaEcoSystemCore)
            case .myQuestionsAndAnswers: return "profile_row_question_answers".localized(.olchaEcoSystemCore)
            }
        }
        
        public var image: UIImage? {
            switch self {
            case .comments: return .commentsIcon
            case .compare: return .compareIcon
            case .myQuestionsAndAnswers: return .questionIcon
            }
        }
    }
    
    enum InformationRow: RowProtocol {
        case myCards
        case bonusProgram
        case installmentData
        case notifications
        case addresses
        case security
        
        public var title: String {
            switch self {
            case .myCards: return "profile_row_cards".localized(.olchaEcoSystemCore)
            case .bonusProgram: return "profile_row_bonus_program".localized(.olchaEcoSystemCore)
            case .installmentData: return "profile_row_installment_data".localized(.olchaEcoSystemCore)
            case .notifications: return "profile_row_notifications".localized(.olchaEcoSystemCore)
            case .addresses: return "profile_row_addressess".localized(.olchaEcoSystemCore)
            case .security: return "profile_row_security".localized(.olchaEcoSystemCore)
            }
        }
        
        public var image: UIImage? {
            switch self {
            case .myCards: return .cardIcon
            case .bonusProgram: return .bonusIcon
            case .installmentData: return .installmentIcon
            case .notifications: return .notificationIcon
            case .addresses: return .addressIcon
            case .security: return .securityIcon
            }
        }
    }
    
    enum MainRow: RowProtocol {
        case settings
        case about
        case help
        case logout
        case delete
        
        public var title: String {
            switch self {
            case .settings: return "profile_row_settings".localized(.olchaEcoSystemCore)
            case .about: return "profile_row_about".localized(.olchaEcoSystemCore)
            case .help: return "profile_row_help".localized(.olchaEcoSystemCore)
            case .logout: return "profile_row_logout".localized(.olchaEcoSystemCore)
            case .delete: return "delete_account".localized()
            }
        }
        
        public var image: UIImage? {
            return nil
        }
    }
}
