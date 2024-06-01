//
//  ViewController.swift
//  InnoviticsNetworkLayer
//
//  Created by ahmed moharam on 31/05/2024.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet private weak var librariesButton: UIButton!
    @IBOutlet private weak var guideLabel: UILabel!
    
    // MARK: - Properties
    
    private var viewModel: HomeViewModelProtocol = HomeViewModel()
    
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModelObservers()
        setupActions()
        setupUI()
    }
    
    //MARK: - Methods
    
    private func setupUI() {
        setupLibrariesButton()
        setupGuideLabel()
    }
    
    private func setupLibrariesButton() {
        librariesButton.layer.cornerRadius = 5
        librariesButton.layer.borderWidth = 0.8
        librariesButton.layer.borderColor = UIColor.white.cgColor
    }
    
    private func setupGuideLabel() {
        guideLabel.alpha = 0
    }
    
    private func showGuideLabelWith(duration: CGFloat = 0.6, state: Bool) {
        UIView.animate(withDuration: duration) {
            self.guideLabel.alpha = state ? 1 : 0
        }
    }
    
    //MARK: - Setup Observers
    
    private func setupViewModelObservers() {
        
        viewModel.state
            .sink { [ weak self] in
                guard let self else { return }
                
                switch $0 {
                    case let .loading(show):
                        show ? LoadingSpinnerManager.shared.show() : LoadingSpinnerManager.shared.hide()
                        
                    case let .showError(message):
                        print("Error Message", message)
                        
                    case .showGuideMessage:
                        showGuideLabelWith(state: true)
                }
            }.store(in: &viewModel.subscriptions)
    }
    
    private func setupActions() {
        librariesButton
            .publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                guard let self else { return }
                
                showGuideLabelWith(duration: 0.1, state: false)
                viewModel.getLibrariesList()
            }.store(in: &viewModel.subscriptions)
    }
}
