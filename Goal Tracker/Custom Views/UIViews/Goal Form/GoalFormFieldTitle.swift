//
//  GoalFormFieldTitle.swift
//  Goal Tracker
//
//  Created by Jon E on 6/5/21.
//

import UIKit

class GoalFormFieldTitle: UIView {

    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureBackground()
        configureLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureBackground() {
        clipsToBounds = true
        layer.cornerRadius = 10
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        backgroundColor = #colorLiteral(red: 0.1285711527, green: 0.1285960376, blue: 0.1285656989, alpha: 1)
    }
    
    private func configureLabel() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.preferredMaxLayoutWidth = 80
        titleLabel.font = .preferredFont(forTextStyle: .subheadline)
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
}
