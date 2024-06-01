//
//  Constants.swift
//  InnoviticsNetworkLayer
//
//  Created by ahmed moharam on 31/05/2024.
//

import Foundation

struct Server {
    static let baseURL = "https://gateway.marvel.com/v1/public/"
    static let apiPublicKey = "55e1aedc4850aff4baf07072963ba123"
    static let apiPrivateKey = "e8cef5c020cbe0477203a66aee188fcab08ff8c6"
    static var timestamp: String { return String(Date().getTimeIntervalSince1970()) }
    static var hash: String { return String(timestamp + apiPrivateKey + apiPublicKey).md5() }
}

public struct Message {
    static let genericError = "Something went wrong"
}
