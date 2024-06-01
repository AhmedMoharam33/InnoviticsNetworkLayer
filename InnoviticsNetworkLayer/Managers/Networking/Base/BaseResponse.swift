//
//  BaseResponse.swift
//  InnoviticsNetworkLayer
//
//  Created by ahmed moharam on 31/05/2024.
//

import Foundation

public class BaseResponse<T: Decodable>: Decodable {
    var status: String?
    var statusCode: Int?
    var message: String?
    var data: T?
}

public class BaseArrayResponse<T: Decodable>: Decodable {
    var status: String?
    var statusCode: Int?
    var message: String?
    var data: [T]?
}
