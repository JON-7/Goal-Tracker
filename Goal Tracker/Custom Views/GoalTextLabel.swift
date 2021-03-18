//
//  GoalTextView.swift
//  LayoutFlowDemo
//
//  Created by Jon E on 2/13/21.
//

import UIKit

class GoalTextLabel: UITextView {
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(title: String) {
        super.init(frame: .zero, textContainer: nil)
        self.text = title
        configure()
    }
    
    var label = UILabel()
    var titles = UILabel()
    
    func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        font = .preferredFont(forTextStyle: .subheadline)
        isEditable = false
        isSelectable = false
        textAlignment = NSTextAlignment.center
        clipsToBounds = true
        layer.cornerRadius = 10
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        backgroundColor = UIColor(named: "createGoalLabelColor")
    }
}
