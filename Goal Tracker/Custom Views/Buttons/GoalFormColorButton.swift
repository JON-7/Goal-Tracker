//
//  GoalFormColorButton.swift
//  Goal Tracker
//
//  Created by Jon E on 6/5/21.
//

import UIKit

class GoalFormColorButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        layer.cornerRadius = 10
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    }
}

