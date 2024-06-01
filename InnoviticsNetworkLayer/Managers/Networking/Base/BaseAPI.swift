//
//  BaseAPI.swift
//  InnoviticsNetworkLayer
//
//  Created by ahmed moharam on 31/05/2024.
//

import Foundation
import Alamofire
import Combine

open class BaseAPI<T: TargetType>: NSObject {
    
    // MARK: - Properties
    
    private var unAuthorizedStatusCode = 401
    private var acceptedStatusCodes = 200...300
    private var genericError: NSError = NSError(domain: Server.baseURL, code: 999, userInfo: [NSLocalizedDescriptionKey: Message.genericError])
    
    // MARK: - Session Managers
    
    private let cacheSessionManager: Session = {
        let configuration = URLSessionConfiguration.af.default
        let interceptor = BaseInterceptor()
        configuration.requestCachePolicy = .reloadRevalidatingCacheData
        configuration.urlCredentialStorage = nil
        let responseCacher = ResponseCacher(behavior: .modify { _, response in
            let userInfo = ["date": Date()]
            return CachedURLResponse(response: response.response, data: response.data, userInfo: userInfo, storagePolicy: .allowed)
        })
        return Session(configuration: configuration, interceptor: interceptor, cachedResponseHandler: responseCacher)
    }()
    
    private let regularSessionManager: Session = {
        let configuration = URLSessionConfiguration.af.default
        let interceptor = BaseInterceptor()
        configuration.timeoutIntervalForRequest = 30
        configuration.waitsForConnectivity = true
        configuration.urlCredentialStorage = nil
        return Session(configuration: configuration, interceptor: interceptor)
    }()
    
    // MARK: - Public Methods
    
    public func sendRequest(target: T) -> AnyPublisher<Any?, NSError> {
        
        let method = Alamofire.HTTPMethod(rawValue: target.method.rawValue)
        let requestPublisher = makeRequest(target: target, session: regularSessionManager, method: method)
        return handleRawResponse(requestPublisher: requestPublisher)
    }
    
    public func fetchData<M: Decodable>(target: T, shouldUseCache: Bool = false) -> AnyPublisher<M, NSError> {
        
        let method = Alamofire.HTTPMethod(rawValue: target.method.rawValue)
        let session = shouldUseCache ? cacheSessionManager : regularSessionManager
        let requestPublisher = makeRequest(target: target, session: session, method: method)
        return handleDecodableResponse(requestPublisher: requestPublisher)
    }
    
    public func upload<M: Decodable>(target: T, shouldUseCache: Bool = false) -> AnyPublisher<M, NSError> {
        
        let method = Alamofire.HTTPMethod(rawValue: target.method.rawValue)
        let session = shouldUseCache ? cacheSessionManager : regularSessionManager
        let requestPublisher = session.upload(multipartFormData: buildData(task: target.task), to: target.baseURL + target.path.description, method: method, headers: HTTPHeaders(target.headers ?? [:]))
            .validate(statusCode: acceptedStatusCodes)
            .uploadProgress { print($0) }
            .publishData()
            .eraseToAnyPublisher()
        return handleDecodableResponse(requestPublisher: requestPublisher)
    }
}


//MARK: - Request Maker

extension BaseAPI {
    
    private func makeRequest(target: T, session: Session, method: Alamofire.HTTPMethod) -> AnyPublisher<DataResponse<Data, AFError>, Never> {
        
        let headers = HTTPHeaders(target.headers ?? [:])
        let params = buildParams(task: target.task)
        printRequest(target: target)
        
        return session.request(target.baseURL + target.path.description, method: method, parameters: params.0, encoding: params.1, headers: headers)
            .validate(statusCode: acceptedStatusCodes)
            .publishData()
            .eraseToAnyPublisher()
    }
}


// MARK: - Handling Response

extension BaseAPI {
    
    private func handleRawResponse(requestPublisher: AnyPublisher<DataResponse<Data, AFError>, Never>) -> AnyPublisher<Any?, NSError> {
        
        var error: NSError = genericError
        return requestPublisher
            .tryMap { response in
                self.printResponse(response: response)
                
                if !(self.acceptedStatusCodes.contains(response.response?.statusCode ?? -1)) {
                    error = self.parseErrorIfAny(in: response)
                    throw error
                }
                
                if let data = response.data, let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                    return json
                } else {
                    return nil
                }
            }
            .mapError { _ in error }
            .eraseToAnyPublisher()
    }
    
    private func handleDecodableResponse<M: Decodable>(requestPublisher: AnyPublisher<DataResponse<Data, AFError>, Never>) -> AnyPublisher<M, NSError> {
        
        var error: NSError = genericError
        
        return requestPublisher
            .tryMap { response in
                self.printResponse(response: response)
                
                if !(self.acceptedStatusCodes.contains(response.response?.statusCode ?? -1)) {
                    error = self.parseErrorIfAny(in: response)
                    throw error
                }
                
                guard let data = response.data else {
                    throw error
                }
                
                do {
                    let decodedData = try JSONDecoder().decode(M.self, from: data)
                    return decodedData
                } catch {
                    throw error
                }
            }
            .mapError { _ in error }
            .eraseToAnyPublisher()
    }
}


// MARK: - Helper Methods

extension BaseAPI {
    
    private func buildParams(task: Task) -> ([String: Any], ParameterEncoding) {
        
        switch task {
            case .requestPlain:
                return ([:], URLEncoding.default)
                
            case let .requestParameters(parameters: parameters, encoding: encoding):
                return (parameters, encoding)
                
            case .data:
                return ([:], URLEncoding.default)
        }
    }
    
    private func buildData(task: Task) -> MultipartFormData {
        switch task {
            case let .data(formData):
                return formData
                
            default:
                return MultipartFormData()
        }
    }
    
    private func parseErrorIfAny(in response: DataResponse<Data, AFError>) -> NSError {
        
        guard let statusCode = response.response?.statusCode else { return genericError }
        var error = NSError(domain: genericError.domain, code: statusCode, userInfo: genericError.userInfo)
        
        if !(acceptedStatusCodes.contains(statusCode)) {
            guard let data = response.data,
                  let responseObj = try? JSONDecoder().decode(ErrorResponse.self, from: data)
            else { return error }
            
            error = NSError(domain: response.request?.urlRequest?.url?.absoluteString ?? Server.baseURL, code: statusCode, userInfo: [NSLocalizedDescriptionKey: responseObj.message ?? ""])
            
            if statusCode == unAuthorizedStatusCode {
                // AppStateManager.shared.switchState(to: .loggedOut)
                // Remove all keychain Data
                // remove user Data from user Defaults
            }
            
        }
        return error
    }
}


// MARK: - Request Printing

extension BaseAPI {
    
    private func printRequest(target: T) {
        
        print("👇#### Innovitics Network Layer ###👇")
        print("(*) request called: \(target.baseURL)\(target.path)")
        print("(*) parameters: \(target.task)")
        print("(*) http method: \(target.method)")
        if let headers = target.headers { print("(*) headers:\(headers)") }
    }
    
    private func printResponse(response: DataResponse<Data, AFError>) {
        
        if let result = response.request { print( "(*) request: ",result) }
        
        switch response.result {
            case let .success(data):
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("(*) JSON response 👇(\(response.response?.statusCode ?? -00))\n",json)
                } else {
                    print("Unable to parse JSON.")
                }
                
            case let .failure(error):
                print(error)
        }
        print("####")
    }
}
