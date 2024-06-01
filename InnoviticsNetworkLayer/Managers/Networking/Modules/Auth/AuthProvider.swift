//
//  AuthProvider.swift
//  InnoviticsNetworkLayer
//
//  Created by ahmed moharam on 31/05/2024.
//

import Foundation
import Combine

protocol AuthProviderProtocol {
    
    func login(email: String, password: String) -> AnyPublisher<BaseResponse<UserModel>, NSError>
    func register(email: String, firstName: String, lastName: String, password: String) -> AnyPublisher<BaseResponse<UserModel>, NSError>
    func getProfile() -> AnyPublisher<BaseResponse<UserModel>, NSError>
}

class AuthProvider: BaseAPI<AuthNetworking>, AuthProviderProtocol {
    
    func getProfile() -> AnyPublisher<BaseResponse<UserModel>, NSError> {
        self.fetchData(target: .getProfile)
    }
    
    func login(email: String, password: String) -> AnyPublisher<BaseResponse<UserModel>, NSError> {
        self.fetchData(target: .login(email: email, password: password))
    }

    func register(email: String, firstName: String, lastName: String, password: String) -> AnyPublisher<BaseResponse<UserModel>, NSError> {
        self.fetchData(target: .register(email: email, firstName: firstName, lastName: lastName, password: password))
    }
}
