//
//  LoadingSpinnerManager.swift
//  InnoviticsNetworkLayer
//
//  Created by ahmed moharam on 31/05/2024.
//

import Foundation
import UIKit

public  protocol LoadingSpinnerProtocol {
    func show()
    func hide()
}

public class LoadingSpinnerManager: LoadingSpinnerProtocol {
    
    //MARK: Properties
    
    private var loadingSpinner: InnoviticsLoaderView?
    private let screenBound = UIScreen.main.bounds
    private var containerView: UIView?
    private var isLoading: Bool = false
    
    //MARK: Singleton
    
    public static let shared: LoadingSpinnerProtocol = LoadingSpinnerManager()
    
    //MARK: - Init
    
    private init() {}
    
    //MARK: Methods
    
    public func show() {
        guard isLoading == false else {return}
        self.isLoading = true
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return }
        containerView = UIView(frame: window.bounds)
        loadingSpinner = InnoviticsLoaderView()
        guard let view = containerView else { return }
        guard let spinner = loadingSpinner else { return }
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        spinner.startLoading()
        view.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        window.addSubview(view)
    }
    
    public func hide() {
        loadingSpinner?.removeFromSuperview()
        containerView?.removeFromSuperview()
        loadingSpinner = nil
        containerView = nil
        isLoading = false
    }
}
