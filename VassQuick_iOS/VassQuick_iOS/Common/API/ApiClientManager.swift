//
//  ApiClientManager.swift
//  VassQuick_iOS
//
//  Created by Markel Juaristi Mendarozketa   on 6/3/24.
//

import Foundation
import Combine
import UIKit
import Alamofire

class ApiClientManager: BaseAPIClient {
   
    func uploadImage(image: UIImage, imageName: String, token: String) -> AnyPublisher<ImageUploadResponse, BaseError> {
        let subject = PassthroughSubject<ImageUploadResponse, BaseError>()

        let url = self.baseURL.appendingPathComponent("/api/users/upload")
        let _: Data
        let _: ImageType

        guard let imageData = image.jpegData(compressionQuality: 0.5),
              let imageType = ImageType(with: imageData) else {
            subject.send(completion: .failure(BaseError.generic))
            return subject.eraseToAnyPublisher()
        }
        
        let headers: HTTPHeaders = [
            "Authorization": token
        ]

        self.sesionManager.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "file", fileName: "\(imageName).\(imageType.fileExtension)", mimeType: imageType.mimeType)
        }, to: url, headers: headers)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: ImageUploadResponse.self) { response in
            switch response.result {
            case .success(let uploadResponse):
                subject.send(uploadResponse)
                subject.send(completion: .finished)
            case .failure(let error):
                if let baseError = self.handler(error: error) {
                    subject.send(completion: .failure(baseError))
                } else {
                    subject.send(completion: .failure(.generic))
                }
            }
        }
        
        return subject.eraseToAnyPublisher()
    }
    
    func logout() -> AnyPublisher<String, BaseError> {
        guard let token = KeyChainManager.shared.getToken() else {
            print("Token is nil")
            return Fail(error: BaseError.generic).eraseToAnyPublisher()
        }
        
        let headers = ["Authorization": token]

        return requestPublisher(relativePath: "/api/users/logout",
                                method: .post,
                                parameters: nil,
                                urlEncoding: URLEncoding.default,
                                type: String.self, 
                                customHeaders: HTTPHeaders(headers))
            .mapError { [weak self] error -> BaseError in
                return self?.handler(error: error) ?? .generic
            }
            .eraseToAnyPublisher()
    }
    
    func getUsers() -> AnyPublisher<[User], BaseError> {
        let relativePath = "/api/users"
        
        guard let token = KeyChainManager.shared.getToken() else {
            return Fail(error: BaseError.generic).eraseToAnyPublisher()
        }
        
        let headers: HTTPHeaders = [
            "Authorization": token
        ]
        
        return requestPublisher(relativePath: relativePath, method: .get, urlEncoding: JSONEncoding.default, type: [User].self, customHeaders: headers)
    }
    
    func getCurrentUserProfile() -> AnyPublisher<User, BaseError> {
        guard let token = KeyChainManager.shared.getToken() else {
            return Fail(error: BaseError.generic).eraseToAnyPublisher()
        }
        
        let relativePath = "/api/users/profile"
        let headers: HTTPHeaders = ["Authorization": token]
        
        return requestPublisher(relativePath: relativePath, method: .get, urlEncoding: JSONEncoding.default, type: User.self, customHeaders: headers)
    }
    
    func putOfflineStatus() -> AnyPublisher<OnlineModelResponse, BaseError> {
        guard let token = KeyChainManager.shared.getToken() else {
            print("Token is nil")
            return Fail(error: BaseError.generic).eraseToAnyPublisher()
        }
        
        let relativePath = "/api/users/online/false"
        let headers: HTTPHeaders = ["Authorization": token]
        
        return requestPublisher(relativePath: relativePath, method: .put, urlEncoding: JSONEncoding.default, type: OnlineModelResponse.self, customHeaders: headers)
    }
    
    func getMessagesList(chatID: String, offset: Int = 0, limit: Int = 250) -> AnyPublisher<MessageListResponse, BaseError> {
        guard let token = KeyChainManager.shared.getToken() else {
            return Fail(error: BaseError.generic).eraseToAnyPublisher()
        }
        
        var relativePath = "/api/messages/list/"
        relativePath += "\(chatID)?"
        relativePath += "offset=\(offset)&limit=\(limit)"
        
        let headers: HTTPHeaders = [
            "Authorization": token
        ]
        print("Sending request to \(relativePath) with token \(token)")
        return requestPublisher(relativePath: relativePath, method: .get, urlEncoding: JSONEncoding.default, type: MessageListResponse.self, customHeaders: headers)
    }
}

extension Encodable {
    func toDictionary() throws -> [String: Any]? {
        let data = try JSONEncoder().encode(self)
        let dictionary = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any]
        print("Diccionario convertido: \(String(describing: dictionary))")
        return dictionary
    }
}
