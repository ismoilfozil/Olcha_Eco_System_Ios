import Combine
import OlchaCore
import Alamofire
import Foundation

public protocol BarcodeRepositoryProtocol {
    func generateBarcode(userId: Int) -> AnyPublisher<BarcodeResponse?, Never>
}

public class BarcodeRepository: BarcodeRepositoryProtocol {

    public init() {}

    public func generateBarcode(userId: Int) -> AnyPublisher<BarcodeResponse?, Never> {
        return Future { promise in
            let url = "https://merchant.olchanasiya.uz/api/barcode/generate"
            let parameters: [String: Any] = ["user_id": userId]

            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "Accept": "application/json",
                "Authorization": "Basic YXBpX21lcmNoYW50Ono6UzXCo0t1Q2w3XXo8N0IxaTZLeUI4cWt2SGw="
            ]

            AF.request(url,
                      method: .post,
                      parameters: parameters,
                      encoding: JSONEncoding.default,
                      headers: headers)
                .validate()
                .responseDecodable(of: BarcodeResponse.self) { response in

                    if let data = response.data, let str = String(data: data, encoding: .utf8) {
                        print("Response Body: \(str)")
                    }

                    switch response.result {
                    case .success(let barcodeResponse):
                        print("✅ Success - Barcode: \(barcodeResponse.code), Success: \(barcodeResponse.success)")
                        promise(.success(barcodeResponse))
                    case .failure(let error):
                        print("❌ Barcode API Error: \(error)")
                        print("Error Description: \(error.localizedDescription)")
                        if let urlError = error.underlyingError as? URLError {
                            print("URL Error Code: \(urlError.code)")
                        }
                        promise(.success(nil))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
}
