//
//  GoalTextField.swift
//  Goal Tracker
//
//  Created by Jon E on 6/5/21.
//

import UIKit

class GoalTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .tertiarySystemBackground
        autocorrectionType = .no
        layer.cornerRadius = 10
        layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        setLeftPaddingPoints(10)
        setRightPaddingPoints(10)
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
