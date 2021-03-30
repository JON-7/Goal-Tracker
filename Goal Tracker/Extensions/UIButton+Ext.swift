//
//  UIButton+Ext.swift
//  Goal Tracker
//
//  Created by Jon E on 3/29/21.
//

import UIKit

extension UIButton {
    func pulsate() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.15
        pulse.fromValue = 0.95
        pulse.toValue = 1
        pulse.autoreverses = false
        pulse.repeatCount = 0
        pulse.initialVelocity = 0.9
        pulse.damping = 1.0
        layer.add(pulse, forKey: nil)
    }
}
