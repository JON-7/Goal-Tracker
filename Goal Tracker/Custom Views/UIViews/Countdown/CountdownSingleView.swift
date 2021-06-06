//
//  CountdownSingleView.swift
//  Goal Tracker
//
//  Created by Jon E on 6/5/21.
//

import UIKit

class CountdownSingleView: UIView {
    
    let timeRemaining = UILabel()
    let timeTitle = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(timeRemaining)
        timeRemaining.translatesAutoresizingMaskIntoConstraints = false
        timeRemaining.textAlignment = .center
        timeRemaining.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.height * (0.1/2.4), weight: .semibold)
        
        addSubview(timeTitle)
        timeTitle.translatesAutoresizingMaskIntoConstraints = false
        timeTitle.textAlignment = .center
        timeTitle.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.height * (0.1/2.4), weight: .semibold)
        timeTitle.backgroundColor = .tertiarySystemFill
        
        NSLayoutConstraint.activate([
            timeRemaining.topAnchor.constraint(equalTo: self.topAnchor),
            timeRemaining.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            timeRemaining.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            timeTitle.topAnchor.constraint(equalTo: timeRemaining.bottomAnchor),
            timeTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            timeTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}
