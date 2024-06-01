//
//  AppDelegate.swift
//  InnoviticsNetowkLayer
//
//  Created by ahmed moharam on 31/05/2024.
//

import UIKit

protocol AppDelegateProtocol: AnyObject {
    var window: UIWindow? { get }
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate, AppDelegateProtocol {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //Handling Network Reachability
        BaseReachability.shared.startNetworkMonitoring()
        
        return true
    }
}

