//
//  AuthNetworking.swift
//  InnoviticsNetworkLayer
//
//  Created by ahmed moharam on 31/05/2024.
//


import Foundation
import Alamofire

enum AuthNetworking {
    
    case login(email: String, password: String)
    case register(email: String,
                  firstName: String,
                  lastName: String,
                  password: String)
    
    case getProfile
}

extension AuthNetworking: TargetType {
    
    var baseURL: String { Server.baseURL }
    
    var path: String {
        
        switch self {
            case .login:
                return "/user/login"
            case .register:
                return "/user/signup"
            case .getProfile:
                return "/user/user_details"
        }
    }
    
    var method: HTTPMethod {
        
        switch self {
            case .getProfile:
                return .get
            default:
                return .post
        }
    }
    
    var task: Task {
        
        switch self {
            case let .register(email, firstName, lastName, password):
                let params: [String : Any] = ["first_name": firstName,
                                              "last_name": lastName,
                                              "email": email,
                                              "password": password]
                
                return .requestParameters(parameters: params, encoding: JSONEncoding.default)
                
            case let .login(email, password):
                let params: [String : Any] = ["password": password,
                                              "email": email]
                
                return .requestParameters(parameters: params, encoding: JSONEncoding.default)
                
            default:
                return .requestPlain
        }
    }
    
    
    
    var headers: [String : String]? {
        switch self {
            case .login, .register:
                return [:]
                
            case .getProfile:
                return ["token":"-"]
        }
    }
}
