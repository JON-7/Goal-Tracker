//
//  LoseButton.swift
//  Goal Tracker
//
//  Created by Jon E on 3/29/21.
//

import UIKit

class LoseButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        setTitle("LOSE", for: .normal)
        setTitleColor(Colors.textColor, for: .normal)
        layer.cornerRadius = 10
        layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
    }
}
