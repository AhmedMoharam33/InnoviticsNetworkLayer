//
//  HomeViewModel.swift
//  InnoviticsNetworkLayer
//
//  Created by ahmed moharam on 31/05/2024.
//

import Foundation
import Combine

protocol HomeViewModelProtocol {
    
    var state: PassthroughSubject<HomeViewModel.PageState, Never> { get }
    var subscriptions: Set<AnyCancellable> { get set }
    
    func login()
    func getLibrariesList()
}

class HomeViewModel: HomeViewModelProtocol {
    
    // MARK: - Enums
    
    enum PageState {
        case loading(_ show: Bool)
        case showError(message: String)
        case showGuideMessage
    }
    
    //MARK: - Public Properties
    
    var subscriptions = Set<AnyCancellable>()
    var state = PassthroughSubject<PageState, Never>()
    
    // MARK: - Private Properties
    
    private let authProvider: AuthProviderProtocol
    private let librariesProvider: LibrariesProviderProtocol
    
    // MARK: - Lazy Properties
    
    private lazy var requestCompletionHandler: (Subscribers.Completion<NSError>) -> Void = { [weak self] completion in
        guard let self else { return }
        
        state.send(.loading(false))
        switch completion {
            case let .failure(error):
                state.send(.showError(message: error.localizedDescription))
                
            case .finished:
                print("Finished")
        }
    }
    
    //MARK: - Init & dealloc methods
    
    init(authProvider: AuthProviderProtocol = AuthProvider(),
         librariesProvider: LibrariesProviderProtocol = LibrariesProvider()) {
        
        self.authProvider = authProvider
        self.librariesProvider = librariesProvider
    }
    
    deinit {
        print("DeInit called: \(Self.self)")
    }
    
    //MARK: - Methods
    
    
    // Two Examples
    
    func login() {
        
        authProvider
            .login(email: "innovitics@gmail.com", password: "xxx11xxx")
            .sink(receiveCompletion: requestCompletionHandler) { response in
                                
                // Do any thing
            }
            .store(in: &subscriptions)
    }
    
    func getLibrariesList() {
        state.send(.loading(true))
        
        librariesProvider
            .getLibrariesList(page: 1)
            .sink(receiveCompletion: requestCompletionHandler) { [weak self] response in
                guard let self else { return }
                
                state.send(.showGuideMessage)
            }
            .store(in: &subscriptions)
    }
}

