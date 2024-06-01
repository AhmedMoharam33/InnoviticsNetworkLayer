//
//  BaseReachability.swift
//  InnoviticsNetworkLayer
//
//  Created by ahmed moharam on 31/05/2024.
//

import Foundation
import Alamofire

// MARK: - NetworkConnection Protocol

public protocol NetworkConnectionProtocol: AnyObject {
    func startNetworkMonitoring()
    func stopListening()
}

public class BaseReachability: NetworkConnectionProtocol {
    
    // MARK: - Singleton Pattern
    
    public static let shared: NetworkConnectionProtocol = BaseReachability()
    
    // MARK: - Properties
    
    let reachabilityManager = NetworkReachabilityManager(host: "www.google.com")
    var reachabilityState: Bool = NetworkReachabilityManager()?.isReachable ?? false
    
    // MARK: - Public Methods
    
    public func startNetworkMonitoring() {
        
        reachabilityManager?.startListening { [weak self] status in
            guard let self = self else { return }
            
            switch status {
                case .notReachable:
                    self.showOffline()
                    
                case .reachable(.cellular), .reachable(.ethernetOrWiFi):
                    self.showOnline()
                    
                case .unknown:
                    print("Unknown network state")
            }
        }
    }
    
    public func stopListening() {
        reachabilityManager?.stopListening()
    }
    
    // MARK: - Private Methods
    
    private func showOffline() {
        reachabilityState = false
        // Show offline toast or popup
        showNetworkAlertWith(message: "No Internet Connection Available")
    }
    
    private func showOnline() {
        guard !reachabilityState else {
            return
        }
        reachabilityState = true
        // Show online toast or popup
        showNetworkAlertWith(message: "Internet Connection Available Right Now")
    }
}

// MARK: - Alert Mainly For Testing

extension BaseReachability {
    
    public func showNetworkAlertWith(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        UIWindow.getTopViewController()?.present(alert, animated: true)
        
        let when = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: when) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
}
