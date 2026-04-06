//
//  BaseResponse.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 24/01/22.
//

import Foundation

public struct BaseDecodingResponse<Output: Codable, OutputErrors: Codable>: Codable {
    public var message: String?
    public var data: Output?
    public var errors: OutputErrors?
    public var status: String?
    public var success:Bool?
    public var status_code: Int?
    
    private enum CodingKeys : String, CodingKey {
        case message = "message"
        case data = "data"
        case errors = "errors"
        case status = "status"
        case success = "success"
        case status_code = "status_code"

    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            message = try values.decodeIfPresent(String.self, forKey: .message)
        } catch {}
        do {
            data = try values.decodeIfPresent(Output.self, forKey: .data)
        } catch {}
        do {
            errors = try values.decodeIfPresent(OutputErrors.self, forKey: .errors)
        } catch {}
        
        do {
            status = try values.decodeIfPresent(String.self, forKey: .status)
        } catch {}
        
        do {
            success = try values.decodeIfPresent(Bool.self, forKey: .success)
        } catch {}

        do {
            status_code = try values.decodeIfPresent(Int.self, forKey: .status_code)
        } catch {
            let newValue = try values.decodeIfPresent(String.self, forKey: .status_code)
            status_code = Int(newValue ?? "-1")
        }
    }
    
    public init(message: String? = nil, data: Output? = nil, errors: OutputErrors? = nil, status: String? = nil, success: Bool? = nil, status_code: Int? = nil) {
        self.message = message
        self.data = data
        self.errors = errors
        self.status = status
        self.status_code = status_code
        self.success = success
    }
}

public struct BaseResponse<Output: Codable, OutputErrors: Codable>: @unchecked Sendable {
    public var status: NetworkStatus
    public var error: String?
    public var response: Output?
    public var code: Int?
    public var errors: OutputErrors?
    public var success:Bool?
    
    public init(status: NetworkStatus, error: String? = nil, response: Output? = nil, code: Int? = nil, errors: OutputErrors? = nil, success:Bool? = nil) {
        self.status = status
        self.errors = errors
        self.error = error
        self.response = response
        self.code = code
        self.success = success
    
    }

    public static func mock() -> BaseResponse {
        return BaseResponse(status: .success,
                            error: nil,
                            response: nil,
                            code: nil,
                            errors: nil,
                            success: nil)
    }
}

public struct SingleResponse<Output> {
    public var status: NetworkStatus
    public var error: String?
    public var response: Output?
}

public struct BaseResponseData {
    public var status: NetworkStatus
    public var error: String?
    public var response: Data?
}

public enum NetworkStatus {
    case success
    case fail
    case canceled
}

open class BaseError: Codable {
    open var errors: [String]?
}

public struct Paginator : Codable {
    public var current_page: Int?
    public var first_page_url: String?
    public var from: Int?
    public var last_page: Int?
    
    public var last_page_url: String?
    public var next_page_url: String?
    public var path: String?
    
    //    var per_page: String?
    public var prev_page_url: String?
    public var to: Int?
    public var total: Int?
    
    public init() {}
    
    public init(current_page: Int?,
                first_page_url: String?,
                from: Int?,
                last_page: Int?,
                last_page_url: String?,
                next_page_url: String?,
                path: String?,
                prev_page_url: String?,
                to: Int?,
                total: Int?) {
        self.current_page = current_page
        self.first_page_url = first_page_url
        self.from = from
        self.last_page = last_page
        self.last_page_url = last_page_url
        self.next_page_url = next_page_url
        self.path = path
        self.prev_page_url = prev_page_url
        self.to = to
        self.total = total
    }
}

public class Paging {
    public var isLoading = false
    public var current = 1
    public var total = 1
    public var per_page = 20
    public var itemsCount = 0
    
    public init() {}
    
    public init(current: Int, total: Int) {
        self.current = current
        self.total = total
    }
    
    public init(current: Int) {
        self.current = current
    }
    
    public var isFinishedPaging: Bool {
        (current == total) && !isLoading
    }
    
    public func finished(paginator: Paginator?) {
        isLoading = false
        current = paginator?.current_page ?? 1
        total = paginator?.last_page ?? 1
        itemsCount = paginator?.total ?? 0
    }
    
    public func errorFinished() {
        current -= 1
        isLoading = false
    }
    
    public func reset() {
        self.current = 1
        self.total = 1
        self.itemsCount = 0
        self.isLoading = false
    }
    
    public func footerLoadingCount() -> Int {
        (isLoading && (current <= total)) ? 1 : 0
    }
    
    public func isInitialLoad() -> Bool {
        isLoading && (current == 1)
    }
    
    public func perPage(_ count: Int) -> Self {
        self.per_page = count
        return self
    }
}


