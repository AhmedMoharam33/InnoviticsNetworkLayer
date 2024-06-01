//
//  LibrariesProvider.swift
//  InnoviticsNetworkLayer
//
//  Created by ahmed moharam on 01/06/2024.
//

import Foundation
import Combine

protocol LibrariesProviderProtocol {
    
    func getLibrariesList(page: Int) -> AnyPublisher<BaseResponse<LibrariesModel>, NSError>
}

class LibrariesProvider: BaseAPI<LibrariesNetwork>, LibrariesProviderProtocol {
    
    func getLibrariesList(page: Int) -> AnyPublisher<BaseResponse<LibrariesModel>, NSError> {
        self.fetchData(target: .getLibraries(page: page))
    }
}
