//
//  CountdownView.swift
//  Goal Tracker
//
//  Created by Jon E on 6/5/21.
//

import UIKit

class CountdownView: UIView {

    var dateString: String!
    var goalDate: Date!
    var timeDiff: Double!
    var timeDiffCpy: Double!
    var timer: Timer!
    
    let daysView = CountdownSingleView()
    let hoursView = CountdownSingleView()
    let minutesView = CountdownSingleView()
    let secondsView = CountdownSingleView()
    var views = [CountdownSingleView]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(dateString: String) {
        super.init(frame: .zero)
        self.dateString = dateString
        configureCountdown()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCountdown() {
        views = [daysView, hoursView, minutesView, secondsView]
        configureView()
        startTimer()
    }
    
    @objc func updateTime() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy, 00:00:00"
        goalDate = formatter.date(from: self.dateString)
        timeDiff = floor((goalDate?.timeIntervalSince(Date()))!)
        DispatchQueue.main.async { [self] in
            let absTimeDiff = abs(timeDiff)
            self.daysView.timeRemaining.text = "\(Int(absTimeDiff) / 86400)"
            self.hoursView.timeRemaining.text = "\((Int(absTimeDiff) % 86400) / 3600)"
            self.minutesView.timeRemaining.text = "\((Int(absTimeDiff) % 3600) / 60)"
            self.secondsView.timeRemaining.text = "\((Int(absTimeDiff) % 3600) % 60)"
            timeDiff -= 1
        }
    }
    
    private func configureView() {
        let leadingConst = CGFloat(0)
        daysView.timeTitle.text = "Days"
        hoursView.timeTitle.text = "Hrs"
        minutesView.timeTitle.text = "Mins"
        secondsView.timeTitle.text = "Sec"
        
        for timeView in views {
            addSubview(timeView)
            timeView.translatesAutoresizingMaskIntoConstraints = false
            timeView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/4).isActive = true
        }
        
        NSLayoutConstraint.activate([
            daysView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -leadingConst),
            hoursView.leadingAnchor.constraint(equalTo: daysView.trailingAnchor, constant: leadingConst),
            minutesView.leadingAnchor.constraint(equalTo: hoursView.trailingAnchor, constant: leadingConst),
            secondsView.leadingAnchor.constraint(equalTo: minutesView.trailingAnchor, constant: leadingConst),
        ])
    }
    
    func setCountdownTextColor(goal: AnyObject) {
        for n in views {
            n.timeRemaining.textColor = goal.cellColor
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    func stopTimer() {
        timer.invalidate()
    }
}
