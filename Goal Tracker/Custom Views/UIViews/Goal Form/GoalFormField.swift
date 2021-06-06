//
//  GoalFormField.swift
//  Goal Tracker
//
//  Created by Jon E on 6/5/21.
//

import UIKit

class GoalFormField: UIView {
    
    let goalLabel = GoalFormFieldTitle()
    let goalTF = GoalTextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required convenience init(fieldTitle: String) {
        self.init(frame: .zero)
        configure()
        goalLabel.titleLabel.text = fieldTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(goalLabel)
        goalLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(goalTF)
        goalTF.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            goalLabel.topAnchor.constraint(equalTo: self.topAnchor),
            goalLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            goalLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            goalLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.25),
            
            goalTF.leadingAnchor.constraint(equalTo: goalLabel.trailingAnchor),
            goalTF.topAnchor.constraint(equalTo: self.topAnchor),
            goalTF.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            goalTF.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
}

