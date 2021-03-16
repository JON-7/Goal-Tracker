//
//  ProgressBarView.swift
//  Goal Tracker
//
//  Created by Jon E on 2/22/21.
//

import UIKit

class ProgressBarView: UIView {

    let progressLabel = UILabel()
    let shape = CAShapeLayer()
    let backShape = CAShapeLayer()
    var currentNum: Double!
    var endNum: Double!
    var showPercentage = true
    var isGainGoal: Bool!
    var percentage: String!
    var currentValue: String!
    var timer: Timer!
    
    lazy var containerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 300))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    required init(currentNum: Double, endNum: Double, isGainGoal: Bool) {
        super.init(frame: .zero)
        self.currentNum = currentNum
        self.endNum = endNum
        self.isGainGoal = isGainGoal
        percentage = "\(self.getPercentage(self.currentNum!, self.endNum!, isGainGoal: self.isGainGoal).percentage.formatToString)%"
        currentValue = "\(self.currentNum!.formatToString)/\(self.endNum!.formatToString)"
        addSubview(containerView)
        configureProgress()
        
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(showDetails), userInfo: nil, repeats: true)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureProgress() {
        
        configureLabel()
        configureProgressCircle()
        backgroundColor = .secondarySystemBackground
    }
    
    func configureProgressCircle() {
        let circlePath = UIBezierPath(arcCenter: containerView.center, radius: 150, startAngle: -(.pi / 2), endAngle: .pi * 2, clockwise: true)
        
        backShape.path = circlePath.cgPath
        backShape.fillColor = UIColor.clear.cgColor
        backShape.lineWidth = 40
        backShape.strokeColor = UIColor.tertiarySystemBackground.cgColor
        containerView.layer.addSublayer(backShape)
        
        shape.path = circlePath.cgPath
        shape.fillColor = UIColor.clear.cgColor
        shape.lineWidth = 40
        shape.strokeEnd = 0
        containerView.layer.addSublayer(shape)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = getPercentage(currentNum!, endNum!, isGainGoal: isGainGoal).barProgress
        animation.duration = 1
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        shape.add(animation, forKey: "animation")
    }
    
    func configureLabel() {
        containerView.addSubview(progressLabel)
        progressLabel.sizeToFit()
        progressLabel.textAlignment = .center
        progressLabel.text = "\(getPercentage(currentNum!, endNum!, isGainGoal: isGainGoal).percentage.formatToString)%"
        progressLabel.font = .systemFont(ofSize: 70, weight: .bold)
        progressLabel.sizeToFit()
        progressLabel.center = containerView.center
        progressLabel.adjustsFontSizeToFitWidth = true
    }
    
    @objc func showDetails() {
        DispatchQueue.main.async {
            if self.showPercentage == true {
                self.progressLabel.text = self.percentage
                self.showPercentage = false
            } else {
                self.progressLabel.text = self.currentValue
                self.showPercentage = true
            }
        }
    }
    
    func getPercentage(_ current: Double, _ goal: Double, isGainGoal: Bool) -> (percentage: Double, barProgress: Double) {
        
        var percentage: Double = 0.0
        if isGainGoal {
            if current >= goal {
                percentage = 100
            } else {
                percentage = (current / goal) * 100
            }
        } else {
            if current <= goal {
                percentage = 100
            } else {
                percentage = (goal / current) * 100
            }
        }

        let progress: Double = (percentage * 0.008)
        print("Percentage: \(percentage)")
        print("Progress: \(progress)")
        
        if percentage > 70 {
            print("GREATER THAN 70")
        }
        
        return (percentage, progress)
    }
    
    func stopTimer() {
        self.timer.invalidate()
    }
}
