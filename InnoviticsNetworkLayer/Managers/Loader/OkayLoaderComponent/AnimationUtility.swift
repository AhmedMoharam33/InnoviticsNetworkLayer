//
//  AnimationUtility.swift
//  InnoviticsNetworkLayer
//
//  Created by ahmed moharam on 31/05/2024.
//

import Foundation
import UIKit

class AnimationUtility {
    static func viewSlideIn(view: UIView, direction: CATransitionSubtype, timingFunctionName: CAMediaTimingFunctionName, duration: CFTimeInterval = 0.4) {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: timingFunctionName)
        transition.type = .push
        transition.subtype = direction
        view.layer.add(transition, forKey: nil)
    }

    static func zoomOutAnimation(view: UIView, duration: CGFloat = 0.5, delay: CGFloat = 0.0) {
        view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        UIView.animate(withDuration: 0.5, delay: TimeInterval(delay), options: [], animations: {
            view.transform = CGAffineTransform.identity
        })
    }
}
