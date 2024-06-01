//
//  LoaderView.swift
//  InnoviticsNetworkLayer
//
//  Created by ahmed moharam on 31/05/2024.
//

import Foundation
import Combine
import UIKit

@IBDesignable
open class InnoviticsLoaderView: XIBView {
    
    // MARK: - Outlet
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var topImage: UIImageView!
    @IBOutlet private weak var bottomImage: UIImageView!

    // MARK: - Private Properties
    
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Public Properties
    
    let duration: TimeInterval = 0.4

    // MARK: - Methods
    open override func setup() {
        setupUI()
    }
    
    private func setupUI() {
        setupBottomImage()
        setupTopImage()
    }
    
    private func setupTopImage() {
        topImage.image = UIImage(named: "Top")
        topImage.isHidden = true
        topImage.alpha = 1
    }

    private func setupBottomImage() {
        bottomImage.image = UIImage(named: "Bottom")
        bottomImage.isHidden = true
        bottomImage.alpha = 1
    }
    
    private func startAnimating() {
        DispatchQueue.main.async { [weak self] in
            self?.animateTopImage()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
            self?.animateBottomImage()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration * 2) { [weak self] in
            self?.rotateContainerView()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration * 3) { [weak self] in
            self?.fadeOutImages()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration * 5) { [weak self] in
            self?.restartAnimation()
        }
    }

    private func animateTopImage() {
        topImage.isHidden = false
        AnimationUtility.viewSlideIn(view: topImage, direction: .fromBottom, timingFunctionName: .easeOut, duration: duration)
    }

    private func animateBottomImage() {
        bottomImage.isHidden = false
        AnimationUtility.viewSlideIn(view: bottomImage, direction: .fromTop, timingFunctionName: .easeOut, duration: duration)
    }

    private func rotateContainerView() {
        UIView.animate(withDuration: 1) {
            self.containerView.transform = CGAffineTransform(rotationAngle: .pi)
            self.containerView.transform = CGAffineTransform(rotationAngle: .pi * 2)
        }
    }

    private func fadeOutImages() {
        UIView.animate(withDuration: duration) {
            self.topImage.alpha = 0
            self.bottomImage.alpha = 0
        }
    }

    private func restartAnimation() {
        setupUI()
        startAnimating()
    }

    @discardableResult
    public func startLoading() -> Self {
        startAnimating()
        return self
    }
}
