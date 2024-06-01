//
//  Strings + MD5.hashing.swift
//  InnoviticsNetworkLayer
//
//  Created by ahmed moharam on 01/06/2024.
//

import Foundation
import CryptoKit

extension String {
    func md5() -> String {
        let digest = Insecure.MD5.hash(data: self.data(using: .utf8) ?? Data())
        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
}
