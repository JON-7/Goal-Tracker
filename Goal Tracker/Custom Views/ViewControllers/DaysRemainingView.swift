//
//  DaysRemainingView.swift
//  Goal Tracker
//
//  Created by Jon E on 2/22/21.
//

import UIKit

class DaysRemainingView: UIViewController {
    
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
    
    var constWidth = CGFloat(70)
    var timeDiff: Double!
    var timer: Timer!
    
    init(dateString: String) {
        self.dateString = dateString
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCountdown()
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
        view.addSubview(daysView)
        daysView.translatesAutoresizingMaskIntoConstraints = false
        daysView.textAlignment = .center
        daysView.font = .boldSystemFont(ofSize: 35)
        
        view.addSubview(daysTextLabel)
        daysTextLabel.translatesAutoresizingMaskIntoConstraints = false
        daysTextLabel.text = "Days"
        daysTextLabel.font = .preferredFont(forTextStyle: .subheadline)
        daysTextLabel.font = .systemFont(ofSize: 20)
        daysTextLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            daysTextLabel.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            daysTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            daysTextLabel.widthAnchor.constraint(equalToConstant: view.bounds.width / 4),
            
            daysView.bottomAnchor.constraint(equalTo: daysTextLabel.topAnchor, constant: 2),
            daysView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            daysView.widthAnchor.constraint(equalToConstant: view.bounds.width / 4),
        ])
    }
    
    func configureHours() {
        view.addSubview(hoursView)
        hoursView.translatesAutoresizingMaskIntoConstraints = false
        hoursView.textAlignment = .center
        hoursView.font = .boldSystemFont(ofSize: 35)
        
        view.addSubview(hoursTextLabel)
        hoursTextLabel.translatesAutoresizingMaskIntoConstraints = false
        hoursTextLabel.text = "Hrs"
        hoursTextLabel.font = .preferredFont(forTextStyle: .subheadline)
        hoursTextLabel.font = .systemFont(ofSize: 20)
        hoursTextLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            hoursTextLabel.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            hoursTextLabel.leadingAnchor.constraint(equalTo: daysTextLabel.trailingAnchor),
            hoursTextLabel.widthAnchor.constraint(equalToConstant: view.bounds.width / 4),
            
            hoursView.bottomAnchor.constraint(equalTo: hoursTextLabel.topAnchor),
            hoursView.leadingAnchor.constraint(equalTo: daysView.trailingAnchor),
            hoursView.widthAnchor.constraint(equalToConstant: view.bounds.width / 4),
        ])
    }
    
    func configureMin() {
        view.addSubview(minutesView)
        minutesView.translatesAutoresizingMaskIntoConstraints = false
        minutesView.textAlignment = .center
        minutesView.font = .boldSystemFont(ofSize: 35)
        
        view.addSubview(minutesTextLabel)
        minutesTextLabel.translatesAutoresizingMaskIntoConstraints = false
        minutesTextLabel.text = "Min"
        minutesTextLabel.font = .preferredFont(forTextStyle: .subheadline)
        minutesTextLabel.font = .systemFont(ofSize: 20)
        minutesTextLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            minutesTextLabel.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            minutesTextLabel.leadingAnchor.constraint(equalTo: hoursTextLabel.trailingAnchor),
            minutesTextLabel.widthAnchor.constraint(equalToConstant: view.bounds.width / 4),
            
            minutesView.bottomAnchor.constraint(equalTo: minutesTextLabel.topAnchor),
            minutesView.leadingAnchor.constraint(equalTo: hoursView.trailingAnchor),
            minutesView.widthAnchor.constraint(equalToConstant: view.bounds.width / 4),
        ])
    }
    
    func configureSeconds() {
        view.addSubview(secondsView)
        secondsView.translatesAutoresizingMaskIntoConstraints = false
        secondsView.textAlignment = .center
        secondsView.font = .boldSystemFont(ofSize: 35)
        
        view.addSubview(secondsTextLabel)
        secondsTextLabel.translatesAutoresizingMaskIntoConstraints = false
        secondsTextLabel.text = "Sec"
        secondsTextLabel.font = .preferredFont(forTextStyle: .subheadline)
        secondsTextLabel.font = .systemFont(ofSize: 20)
        secondsTextLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            secondsTextLabel.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            secondsTextLabel.leadingAnchor.constraint(equalTo: minutesTextLabel.trailingAnchor),
            secondsTextLabel.widthAnchor.constraint(equalToConstant: view.bounds.width / 4),
            
            secondsView.bottomAnchor.constraint(equalTo: secondsTextLabel.topAnchor),
            secondsView.leadingAnchor.constraint(equalTo: minutesView.trailingAnchor),
            secondsView.widthAnchor.constraint(equalToConstant: view.bounds.width / 4),
        ])
    }
    
    func stopTimer() {
        timer.invalidate()
    }
}
