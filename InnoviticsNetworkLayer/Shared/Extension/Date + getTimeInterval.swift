//
//  Date.swift
//  InnoviticsNetworkLayer
//
//  Created by ahmed moharam on 01/06/2024.
//

import Foundation

extension Date {
    func getTimeIntervalSince1970() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
