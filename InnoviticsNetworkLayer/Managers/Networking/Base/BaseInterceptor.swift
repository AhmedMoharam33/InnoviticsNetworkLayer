//
//  BaseInterceptor.swift
//  InnoviticsNetworkLayer
//
//  Created by ahmed moharam on 31/05/2024.
//

import Foundation
import Alamofire

class BaseInterceptor: RequestInterceptor {
    
    // MARK: - Properties
    
    let retryLimit = 3
    let retryDelay: TimeInterval = 5
    let failedStatusCodes = 500...599
    
    // MARK: - Methods 
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        
        let response = request.task?.response as? HTTPURLResponse

        if let statusCode = response?.statusCode, failedStatusCodes.contains(statusCode), request.retryCount < retryLimit {
            completion(.retryWithDelay(retryDelay))
        } else {
            return completion(.doNotRetry)
        }
    }
}
