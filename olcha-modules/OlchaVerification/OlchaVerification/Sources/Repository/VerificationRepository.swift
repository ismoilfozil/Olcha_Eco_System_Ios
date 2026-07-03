//
//  VerificationRepository.swift
//  OlchaVerification
//
//  Created by Elbek Khasanov on 27/06/23.
//

import Foundation
import OlchaCore
import Combine

public protocol VerificationRepositoryProtocol {
    func loadStep() -> AnyPublisher<BaseResponse<VerificationData, EmptyData>, Never>

    func uploadPassportImage(model: PassportModel, onCompletion: @escaping (BaseResponse<EmptyData, EmptyData>) -> Void)

    func loadPassport() -> AnyPublisher<BaseResponse<DownloadedPassportData, EmptyData>, Never>

    func uploadPhones(model: VerificationUploadPhonesModel) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never>

    func loadPhones() -> AnyPublisher<BaseResponse<VerificationPhonesModel,EmptyData>, Never>

    func creditIsVerified() -> AnyPublisher<BaseResponse<ValidatedData, EmptyData>, Never>
}

public class VerificationRepository: BaseRepository, VerificationRepositoryProtocol {
    private let api: VerificationAPIProtocol

    public init(manager: NetworkManagerProtocol,
                api: VerificationAPIProtocol) {
        self.api = api
        super.init(manager: manager)
    }

    public func loadStep() -> AnyPublisher<BaseResponse<VerificationData, EmptyData>, Never> {
        Future { [weak self] promise in
            guard let self else {
                promise(.success(.init(status: .fail)))
                return
            }

            manager.requestJSON(api: api.step()) { response in
                var baseResponse = BaseResponse<VerificationData, EmptyData>(
                    status: response.status,
                    error: response.error,
                    response: nil
                )

                guard response.status == .success,
                      let data = response.response else {
                    promise(.success(baseResponse))
                    return
                }

                do {
                    baseResponse.response = try Self.decodeStep(from: data)
                    baseResponse.status = .success
                } catch {
                    baseResponse.status = .fail
                    baseResponse.error = error.localizedDescription
                }

                promise(.success(baseResponse))
            }
        }
        .eraseToAnyPublisher()
    }

    public func uploadPassportImage(model: PassportModel, onCompletion: @escaping (BaseResponse<EmptyData, EmptyData>) -> Void) {
        manager.upload(type: .image, api: api.passportUpload(model: model), progress: nil, onCompletion: onCompletion)
    }

    public func loadPassport() -> AnyPublisher<BaseResponse<DownloadedPassportData, EmptyData>, Never> {
        manager.request(api: api.passportDownload())
    }

    public func uploadPhones(model: VerificationUploadPhonesModel)  -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never> {
        manager.request(api: api.phonesUpload(model: model))
    }

    public func loadPhones() -> AnyPublisher<BaseResponse<VerificationPhonesModel, EmptyData>, Never> {
        manager.request(api: api.phonesDownload(), isSingleRequest: true)
    }

    public func creditIsVerified() -> AnyPublisher<BaseResponse<ValidatedData, EmptyData>, Never> {
        manager.request(api: api.creditIsVerified())
    }
}

private extension VerificationRepository {
    static func decodeStep(from data: Data) throws -> VerificationData {
        let decoder = JSONDecoder()
        let baseResponse = try decoder.decode(BaseDecodingResponse<VerificationData, EmptyData>.self, from: data)

        if let responseData = baseResponse.data {
            return responseData
        }

        return try decoder.decode(VerificationData.self, from: data)
    }
}
