//
//  DaysRemainingView.swift
//  Goal Tracker
//
//  Created by Jon E on 2/22/21.
//

import UIKit

class DaysRemainingView: UIView {
    
    var dateString: String!
    var goalDate: Date!
    var daysView = UILabel()
    var daysTextLabel = UILabel()
    
    var hoursView = UILabel()
    var hoursTextLabel = UILabel()
    
    var minutesView = UILabel()
    var minutesTextLabel = UILabel()
    
    var secondsView = UILabel()
    var secondsTextLabel = UILabel()
    
    //var topPadding = CGFloat(100)
    var topPadding = CGFloat(UIScreen.main.bounds.height / 3)
    var constWidth = CGFloat(70)
    
    var timeDiff: Double!
    
    var timer: Timer!
    lazy var containerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100))
        //let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    required init(dateString: String) {
        super.init(frame: .zero)
        self.dateString = dateString
        addSubview(containerView)
        configureCountdown()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func configureCountdown() {
        configureDays()
        configureHours()
        configureMin()
        configureSeconds()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    @objc func updateTime() {
        let formatter = DateFormatter()
        // keeping the same date format used when creating the goal but, adding a starting time of 12:00 am
        formatter.dateFormat = "MMM d, yyyy, 00:00:00"
        goalDate = formatter.date(from: self.dateString)
        timeDiff = floor((goalDate?.timeIntervalSince(Date()))!)
        DispatchQueue.main.async { [self] in
            self.daysView.text = "\(Int(timeDiff) / 86400)"
            self.hoursView.text = "\((Int(timeDiff) % 86400) / 3600)"
            self.minutesView.text = "\((Int(timeDiff) % 3600) / 60)"
            self.secondsView.text = "\((Int(timeDiff) % 3600) % 60)"
            timeDiff -= 1
        }
    }

    
    func configureDays() {
        containerView.addSubview(daysView)
        daysView.translatesAutoresizingMaskIntoConstraints = false
        daysView.textAlignment = .center
        daysView.font = .boldSystemFont(ofSize: 35)
        
        containerView.addSubview(daysTextLabel)
        daysTextLabel.translatesAutoresizingMaskIntoConstraints = false
        daysTextLabel.text = "Days"
        daysTextLabel.font = .preferredFont(forTextStyle: .subheadline)
        daysTextLabel.font = .systemFont(ofSize: 20)
        daysTextLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            daysView.topAnchor.constraint(equalTo: containerView.layoutMarginsGuide.topAnchor, constant: topPadding),
            daysView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            daysView.widthAnchor.constraint(equalToConstant: containerView.bounds.width / 4),
            
            daysTextLabel.topAnchor.constraint(equalTo: daysView.bottomAnchor, constant: 2),
            daysTextLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            daysTextLabel.widthAnchor.constraint(equalToConstant: containerView.bounds.width / 4)
        ])
    }
    
    func configureHours() {
        containerView.addSubview(hoursView)
        hoursView.translatesAutoresizingMaskIntoConstraints = false
        hoursView.textAlignment = .center
        hoursView.font = .boldSystemFont(ofSize: 35)
        
        containerView.addSubview(hoursTextLabel)
        hoursTextLabel.translatesAutoresizingMaskIntoConstraints = false
        hoursTextLabel.text = "Hrs"
        hoursTextLabel.font = .preferredFont(forTextStyle: .subheadline)
        hoursTextLabel.font = .systemFont(ofSize: 20)
        hoursTextLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            hoursView.topAnchor.constraint(equalTo: containerView.layoutMarginsGuide.topAnchor, constant: topPadding),
            hoursView.leadingAnchor.constraint(equalTo: daysView.trailingAnchor),
            hoursView.widthAnchor.constraint(equalToConstant: containerView.bounds.width / 4),
            
            hoursTextLabel.topAnchor.constraint(equalTo: hoursView.bottomAnchor, constant: 2),
            hoursTextLabel.leadingAnchor.constraint(equalTo: daysTextLabel.trailingAnchor),
            hoursTextLabel.widthAnchor.constraint(equalToConstant: containerView.bounds.width / 4)
        ])
    }
    
    func configureMin() {
        containerView.addSubview(minutesView)
        minutesView.translatesAutoresizingMaskIntoConstraints = false
        minutesView.textAlignment = .center
        minutesView.font = .boldSystemFont(ofSize: 35)
        
        containerView.addSubview(minutesTextLabel)
        minutesTextLabel.translatesAutoresizingMaskIntoConstraints = false
        minutesTextLabel.text = "Min"
        minutesTextLabel.font = .preferredFont(forTextStyle: .subheadline)
        minutesTextLabel.font = .systemFont(ofSize: 20)
        minutesTextLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            minutesView.topAnchor.constraint(equalTo: containerView.layoutMarginsGuide.topAnchor, constant: topPadding),
            minutesView.leadingAnchor.constraint(equalTo: hoursView.trailingAnchor),
            minutesView.widthAnchor.constraint(equalToConstant: containerView.bounds.width / 4),
            
            minutesTextLabel.topAnchor.constraint(equalTo: minutesView.bottomAnchor, constant: 2),
            minutesTextLabel.leadingAnchor.constraint(equalTo: hoursTextLabel.trailingAnchor),
            minutesTextLabel.widthAnchor.constraint(equalToConstant: containerView.bounds.width / 4)
        ])
    }
    
    func configureSeconds() {
        containerView.addSubview(secondsView)
        secondsView.translatesAutoresizingMaskIntoConstraints = false
        secondsView.textAlignment = .center
        secondsView.font = .boldSystemFont(ofSize: 35)
        
        containerView.addSubview(secondsTextLabel)
        secondsTextLabel.translatesAutoresizingMaskIntoConstraints = false
        secondsTextLabel.text = "Sec"
        secondsTextLabel.font = .preferredFont(forTextStyle: .subheadline)
        secondsTextLabel.font = .systemFont(ofSize: 20)
        secondsTextLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            secondsView.topAnchor.constraint(equalTo: containerView.layoutMarginsGuide.topAnchor, constant: topPadding),
            secondsView.leadingAnchor.constraint(equalTo: minutesView.trailingAnchor),
            secondsView.widthAnchor.constraint(equalToConstant: containerView.bounds.width / 4),
            
            secondsTextLabel.topAnchor.constraint(equalTo: secondsView.bottomAnchor, constant: 2),
            secondsTextLabel.leadingAnchor.constraint(equalTo: minutesTextLabel.trailingAnchor),
            secondsTextLabel.widthAnchor.constraint(equalToConstant: containerView.bounds.width / 4)
        ])
    }
    
    func stopTimer() {
        timer.invalidate()
    }

}
