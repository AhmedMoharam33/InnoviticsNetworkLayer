//
//  LibrariesNetwork.swift
//  InnoviticsNetworkLayer
//
//  Created by ahmed moharam on 01/06/2024.
//

import Foundation
import Alamofire

enum LibrariesNetwork {
    
    case getLibraries(page: Int)
}

extension LibrariesNetwork: TargetType {
    
    var baseURL: String { Server.baseURL }
    
    var path: String {
        
        switch self {
            case .getLibraries:
                return "characters"
        }
    }
    
    var method: HTTPMethod {
        switch self {
                
            default:
                return .get
        }
    }
    
    var task: Task {
        switch self {
            case let .getLibraries(page):
                return .requestParameters(
                    parameters: ["apikey": Server.apiPublicKey,
                                 "ts": Server.timestamp,
                                 "hash": Server.hash,
                                 "limit": "10",
                                 "offset": page-1],
                    encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
            case .getLibraries:
                 return [
                    "Content-Type": "application/json",
                    "Accept": "application/json"
                 ]
        }
    }
}
