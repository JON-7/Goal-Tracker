//
//  GoalButton.swift
//  LayoutFlowDemo
//
//  Created by Jon E on 2/13/21.
//

import UIKit

class GoalButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor(named: "goalActionBtnColor")
        setTitleColor(.black, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 30, weight: .semibold)
        clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
    
}
