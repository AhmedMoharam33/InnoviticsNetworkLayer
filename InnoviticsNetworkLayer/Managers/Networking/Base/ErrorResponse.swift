//
//  ErrorResponse.swift
//  InnoviticsNetworkLayer
//
//  Created by ahmed moharam on 31/05/2024.
//

import Foundation

public class ErrorResponse: Decodable, Error {
    
    var statusCode: Int?
    var message: String?
}
