//
//  GoalTextView.swift
//  LayoutFlowDemo
//
//  Created by Jon E on 2/13/21.
//

import UIKit

class GoalTextLabel: UIView {
    var label = UILabel()
    var labelText: String!
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    required init(title: String) {
        super.init(frame: .zero)
        self.labelText = title
        addSubview(containerView)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        containerView.addSubview(label)
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 10
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        containerView.backgroundColor = Colors.createGoalLabelColor
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = labelText
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.numberOfLines = 2
        label.preferredMaxLayoutWidth = 100
        label.textAlignment = .center
        
        NSLayoutConstraint.activate([
            self.label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            self.label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
}
