//
//  CreateGoalFields.swift
//  Goal Tracker
//
//  Created by Jon E on 2/15/21.
//

import UIKit

class CreateGoalVC: UIViewController {
    
    let goalType: String
    let action: String
    let goalTFText: String?
    let dateTFText: String?
    let currentNumTFText: String?
    let finalNumTFText: String?
    let buttonTitle: String
    var isGainGoal: Bool
    var isGoalComplete: Bool!
    var onlyGoal: Bool?
    
    var currentGoalIndex: Int?
    var currentSubIndex: Int?
    
    var color: UIColor?
    // default color shown when creating a new goal
    let defaultColors = [ #colorLiteral(red: 0.8870380521, green: 0.5724834204, blue: 0.9965009093, alpha: 1), #colorLiteral(red: 0.6950762272, green: 0.8662387729, blue: 0.5456559658, alpha: 1), #colorLiteral(red: 0.7887167931, green: 0.7959396243, blue: 0.9998794198, alpha: 1), #colorLiteral(red: 0.4156676531, green: 0.7495350242, blue: 0.9007849097, alpha: 1) ]
    private let colorPicker = UIColorPickerViewController()
    
    required init(goalType: String, action: String, goalTFText: String, dateTFText: String?, currentNumTFText: String?, finalNumTFText: String?, buttonTitle: String, isGainGoal: Bool) {
        self.goalType = goalType
        self.action = action
        self.goalTFText = goalTFText
        self.dateTFText = dateTFText
        self.currentNumTFText = currentNumTFText
        self.finalNumTFText = finalNumTFText
        self.buttonTitle = buttonTitle
        self.isGainGoal = isGainGoal
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let createGoalLabel = UILabel()
    public let goalTextfield = GoalTextField()
    let goalLabel = GoalTextLabel(title: "Goal Name")
    
    let dateTextfield = GoalTextField()
    let dateLabel = GoalTextLabel(title: "Goal Date")
    var datePicker = UIDatePicker()
    
    let currentNumberLabel = GoalTextLabel(title: "Current Number")
    let currentNumberTF = GoalTextField()
    
    let numberGoalLabel = GoalTextLabel(title: "Goal \nNumber")
    let numberTextfield = GoalTextField()
    
    let colorLabel = GoalTextLabel(title: "Goal Color")
    let colorButton = UIButton()
    
    let gainOrLoseLabel = GoalTextLabel(title: "Goal Type")
    let gainButton = UIButton()
    let loseButton = UIButton()
    let closeButton = UIButton()
    
    let createEditButton = GoalButton()
    let deleteButton = GoalButton()
    let trailingPadding = CGFloat(5)
    let topPadding = CGFloat(19)
    let heightMultiplier = CGFloat(0.06) //0.066
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        view.backgroundColor = .secondarySystemBackground
        goalTextfield.delegate = self
        dateTextfield.delegate = self
        currentNumberTF.delegate = self
        numberTextfield.delegate = self
        colorPicker.delegate = self
        configureView()
    }
    
    func configureView() {
        if goalType == "main" && dateTFText == "" && currentNumTFText == "" && finalNumTFText == "" {
            configLeftBarItem()
        }
        configureCloseButton()
        configureColor()
        if action == "create" { configureMainLabel() }
        configureGoalNameTF()
        configureDateTF()
        configureCurrentNumTF()
        configureNumGoalTF()
        configureGoalColor()
        configureGainOrLose()
        configureEditCreateButton()
        configureDeleteButton()
        dismissKeyboardByTap()
    }
    
    // getting the goal color to be used throughout the UI
    func configureColor() {
        if action == "create" {
            color = defaultColors.randomElement()
        } else if goalType == "main" {
            color = HomeVC.goals[currentGoalIndex!].cellColor
        } else if goalType == "sub" {
            color = SubGoalsVC.subGoals[currentSubIndex!].cellColor
        } else {
            color = defaultColors.randomElement()
        }
    }
    
    func configureCloseButton() {
        if action == "edit" {
            navigationItem.leftBarButtonItem = .init(barButtonSystemItem: .close, target: self, action: #selector(closeView))
        }
    }
    
    @objc func closeView() {
        dismiss(animated: true)
    }
    
    func configLeftBarItem() {
        if onlyGoal ?? false && goalType == "main" {
            let goalComplete = HomeVC.goals[currentGoalIndex!].isGoalComplete
            var leftTitle = ""
            if goalComplete {
                leftTitle = "Goal Complete"
            } else {
                leftTitle = "Mark Goal As Complete"
            }
            navigationItem.rightBarButtonItem = .init(title: leftTitle, style: .plain, target: self, action: #selector(updateNav))
        }
    }
    
    @objc func updateNav() {
        let goalComplete = HomeVC.goals[currentGoalIndex!].isGoalComplete
        if goalComplete {
            let ac = UIAlertController(title: "Mark As Incomplete?", message: "Do you want to change the status of the goal to INCOMPLETE?", preferredStyle: .alert)
            let inComplete = UIAlertAction(title: "Change To Incomplete", style: .default) { _ in
                HomeVC.goals[self.currentGoalIndex!].isGoalComplete = false
                DataManager.shared.save()
                DispatchQueue.main.async { [self] in
                    navigationItem.leftBarButtonItem?.title = "Mark Goal As Complete"
                    dismiss(animated: true, completion: nil)
                }
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            ac.addAction(inComplete)
            ac.addAction(cancel)
            present(ac, animated: true)
            
        } else if !goalComplete {
            let ac = UIAlertController(title: "Mark As Complete?", message: "Do you want to mark this goal as COMPLETE?", preferredStyle: .alert)
            let complete = UIAlertAction(title: "Mark As Complete", style: .default) { _ in
                HomeVC.goals[self.currentGoalIndex!].isGoalComplete = true
                DataManager.shared.save()
                DispatchQueue.main.async { [self] in
                    navigationItem.leftBarButtonItem?.title = "Goal Complete"
                    dismiss(animated: true, completion: nil)
                }
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            ac.addAction(complete)
            ac.addAction(cancel)
            present(ac, animated: true)
        }
    }
    
    public func configureMainLabel() {
        createGoalLabel.translatesAutoresizingMaskIntoConstraints = false
        if goalType == "main" {
            createGoalLabel.text = "Create Goal"
        } else if goalType == "sub" {
            createGoalLabel.text = "Create Sub-Goal"
        }
        
        createGoalLabel.textAlignment = .center
        createGoalLabel.font = .preferredFont(forTextStyle: .largeTitle)
        view.addSubview(createGoalLabel)
        
        NSLayoutConstraint.activate([
            createGoalLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: -8),
            createGoalLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: trailingPadding),
            createGoalLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -trailingPadding),
            createGoalLabel.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
    
    func configureGoalNameTF() {
        view.addSubview(goalTextfield)
        self.view.addSubview(goalLabel)
        goalTextfield.text = goalTFText
        
        if action == "create" {
            NSLayoutConstraint.activate([
                goalLabel.containerView.topAnchor.constraint(equalTo: createGoalLabel.bottomAnchor, constant: -20),
                goalLabel.containerView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: trailingPadding),
                goalLabel.containerView.widthAnchor.constraint(equalToConstant: 100),
                goalLabel.containerView.heightAnchor.constraint(equalToConstant: view.bounds.height * heightMultiplier),
                
                goalTextfield.topAnchor.constraint(equalTo: createGoalLabel.bottomAnchor, constant: -20),
                goalTextfield.leadingAnchor.constraint(equalTo: goalLabel.containerView.trailingAnchor),
                goalTextfield.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -trailingPadding),
                goalTextfield.heightAnchor.constraint(equalToConstant: view.bounds.height * heightMultiplier)
            ])
        } else {
            NSLayoutConstraint.activate([
                goalLabel.containerView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
                goalLabel.containerView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: trailingPadding),
                goalLabel.containerView.widthAnchor.constraint(equalToConstant: 100),
                goalLabel.containerView.heightAnchor.constraint(equalToConstant: view.bounds.height * heightMultiplier),
                
                goalTextfield.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
                goalTextfield.leadingAnchor.constraint(equalTo: goalLabel.containerView.trailingAnchor),
                goalTextfield.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -trailingPadding),
                goalTextfield.heightAnchor.constraint(equalToConstant: view.bounds.height * heightMultiplier)
            ])
        }
    }
    
    func configureDateTF() {
        view.addSubview(dateTextfield)
        self.view.addSubview(dateLabel)
        
        dateTextfield.text = dateTFText ?? ""
        if action == "create" { dateTextfield.placeholder = "Optional" }
        createDatePicker()
        
        NSLayoutConstraint.activate([
            dateLabel.containerView.topAnchor.constraint(equalTo: goalLabel.containerView.bottomAnchor, constant: view.bounds.height * heightMultiplier/2),
            dateLabel.containerView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: trailingPadding),
            dateLabel.containerView.widthAnchor.constraint(equalToConstant: 100),
            dateLabel.containerView.heightAnchor.constraint(equalToConstant: view.bounds.height * heightMultiplier),
            
            dateTextfield.topAnchor.constraint(equalTo: goalLabel.containerView.bottomAnchor, constant: view.bounds.height * heightMultiplier/2),
            dateTextfield.leadingAnchor.constraint(equalTo: dateLabel.containerView.trailingAnchor),
            dateTextfield.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -trailingPadding),
            dateTextfield.heightAnchor.constraint(equalToConstant: view.bounds.height * heightMultiplier),
        ])
    }
    
    func configureCurrentNumTF() {
        view.addSubview(currentNumberTF)
        self.view.addSubview(currentNumberLabel)
        currentNumberTF.keyboardType = .decimalPad
        currentNumberTF.inputAccessoryView = configureDone()
        currentNumberTF.text = currentNumTFText ?? ""
        if action == "create" { currentNumberTF.placeholder = "Optional" }
        
        NSLayoutConstraint.activate([
            currentNumberLabel.containerView.topAnchor.constraint(equalTo: dateLabel.containerView.bottomAnchor, constant: view.bounds.height * heightMultiplier/2),
            currentNumberLabel.containerView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: trailingPadding),
            currentNumberLabel.containerView.widthAnchor.constraint(equalToConstant: 100),
            currentNumberLabel.containerView.heightAnchor.constraint(equalToConstant: view.bounds.height * heightMultiplier),
            
            currentNumberTF.topAnchor.constraint(equalTo: dateLabel.containerView.bottomAnchor, constant: view.bounds.height * heightMultiplier/2),
            currentNumberTF.leadingAnchor.constraint(equalTo: currentNumberLabel.containerView.trailingAnchor),
            currentNumberTF.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -trailingPadding),
            currentNumberTF.heightAnchor.constraint(equalToConstant: view.bounds.height * heightMultiplier)
        ])
    }
    
    func configureNumGoalTF() {
        view.addSubview(numberTextfield)
        self.view.addSubview(numberGoalLabel)
        numberTextfield.keyboardType = .decimalPad
        numberTextfield.inputAccessoryView = configureDone()
        numberTextfield.text = finalNumTFText ?? ""
        if action == "create" { numberTextfield.placeholder = "Optional" }
        
        NSLayoutConstraint.activate([
            numberGoalLabel.containerView.topAnchor.constraint(equalTo: currentNumberLabel.containerView.bottomAnchor, constant: view.bounds.height * heightMultiplier/2),
            numberGoalLabel.containerView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: trailingPadding),
            numberGoalLabel.containerView.widthAnchor.constraint(equalToConstant: 100),
            numberGoalLabel.containerView.heightAnchor.constraint(equalToConstant: view.bounds.height * heightMultiplier),
            
            numberTextfield.topAnchor.constraint(equalTo: currentNumberLabel.containerView.bottomAnchor, constant: view.bounds.height * heightMultiplier/2),
            numberTextfield.leadingAnchor.constraint(equalTo: numberGoalLabel.containerView.trailingAnchor),
            numberTextfield.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -trailingPadding),
            numberTextfield.heightAnchor.constraint(equalToConstant: view.bounds.height * heightMultiplier)
        ])
    }
    
    func configureGoalColor() {
        self.view.addSubview(colorLabel)
        view.addSubview(colorButton)
        colorButton.translatesAutoresizingMaskIntoConstraints = false
        colorButton.clipsToBounds = true
        colorButton.layer.cornerRadius = 10
        colorButton.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        colorButton.backgroundColor = color
        
        NSLayoutConstraint.activate([
            colorLabel.containerView.topAnchor.constraint(equalTo: numberGoalLabel.containerView.bottomAnchor, constant: view.bounds.height * heightMultiplier/2),
            colorLabel.containerView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: trailingPadding),
            colorLabel.containerView.widthAnchor.constraint(equalToConstant: 100),
            colorLabel.containerView.heightAnchor.constraint(equalToConstant: view.bounds.height * heightMultiplier),
            
            colorButton.topAnchor.constraint(equalTo: numberGoalLabel.containerView.bottomAnchor, constant: view.bounds.height * heightMultiplier/2),
            colorButton.leadingAnchor.constraint(equalTo: colorLabel.containerView.trailingAnchor),
            colorButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -trailingPadding),
            colorButton.heightAnchor.constraint(equalToConstant: view.bounds.height * heightMultiplier)
        ])
        colorButton.addTarget(self, action: #selector(showColorPicker), for: .touchUpInside)
    }
    
    @objc private func showColorPicker() {
        colorPicker.supportsAlpha = true
        colorPicker.selectedColor = color!
        colorPicker.modalPresentationStyle = .fullScreen
        present(colorPicker, animated: true)
    }
    
    func configureGainOrLose() {
        self.view.addSubview(gainOrLoseLabel)
        view.addSubview(gainButton)
        gainButton.translatesAutoresizingMaskIntoConstraints = false
        gainButton.setTitle("GAIN", for: .normal)
        gainButton.setTitleColor(UIColor(named: "textColor"), for: .normal)
    
        DispatchQueue.main.async { [self] in
            if isGainGoal {
                gainButton.isSelected = true
                loseButton.isSelected = false
                gainButton.backgroundColor = color
                loseButton.backgroundColor = .tertiarySystemBackground
            }
            if !isGainGoal {
                loseButton.isSelected = true
                gainButton.isSelected = false
                loseButton.backgroundColor = color
                gainButton.backgroundColor = .tertiarySystemBackground
            }
        }
        
        view.addSubview(loseButton)
        loseButton.translatesAutoresizingMaskIntoConstraints = false
        loseButton.backgroundColor = .tertiarySystemBackground
        loseButton.setTitle("LOSE", for: .normal)
        loseButton.setTitleColor(UIColor(named: "textColor"), for: .normal)
        loseButton.layer.cornerRadius = 10
        loseButton.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        
        NSLayoutConstraint.activate([
            gainOrLoseLabel.containerView.topAnchor.constraint(equalTo: colorLabel.containerView.bottomAnchor, constant: view.bounds.height * heightMultiplier/2),
            gainOrLoseLabel.containerView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: trailingPadding),
            gainOrLoseLabel.containerView.widthAnchor.constraint(equalToConstant: 100),
            gainOrLoseLabel.containerView.heightAnchor.constraint(equalToConstant: view.bounds.height * heightMultiplier),
            
            gainButton.topAnchor.constraint(equalTo: colorLabel.containerView.bottomAnchor, constant: view.bounds.height * heightMultiplier/2),
            gainButton.leadingAnchor.constraint(equalTo: gainOrLoseLabel.containerView.trailingAnchor),
            gainButton.heightAnchor.constraint(equalToConstant: view.bounds.height * heightMultiplier),
            gainButton.widthAnchor.constraint(equalToConstant: CGFloat((view.bounds.width - 20 - 100 - 20)) / 2),
            
            loseButton.topAnchor.constraint(equalTo: colorLabel.containerView.bottomAnchor, constant: view.bounds.height * heightMultiplier/2),
            loseButton.leadingAnchor.constraint(equalTo: gainButton.trailingAnchor),
            loseButton.heightAnchor.constraint(equalToConstant: view.bounds.height * heightMultiplier),
            loseButton.widthAnchor.constraint(equalToConstant: CGFloat((view.bounds.width - 20 - 100 - 20)) / 2)
        ])
        
        gainButton.addTarget(self, action: #selector(gainPressed), for: .touchUpInside)
        loseButton.addTarget(self, action: #selector(losePressed), for: .touchUpInside)
    }
    
    @objc func gainPressed() {
        gainButton.isSelected = true
        loseButton.isSelected = false
        gainButton.backgroundColor = color
        loseButton.backgroundColor = .tertiarySystemBackground
        isGainGoal = true
    }
    
    @objc func losePressed() {
        loseButton.isSelected = true
        gainButton.isSelected = false
        loseButton.backgroundColor = color
        gainButton.backgroundColor = .tertiarySystemBackground
        isGainGoal = false
    }
    
    func configureEditCreateButton() {
        view.addSubview(createEditButton)
        createEditButton.setTitle(buttonTitle, for: .normal)
        
        NSLayoutConstraint.activate([
            createEditButton.topAnchor.constraint(equalTo: gainButton.bottomAnchor, constant: 20),
            createEditButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createEditButton.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.90),
            createEditButton.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.10)
        ])
        
        createEditButton.addTarget(self, action: #selector(createGoal), for: .touchUpInside)
    }
    
    func configureDeleteButton() {
        if action == "edit" {
            view.addSubview(deleteButton)
            if goalType == "main" { deleteButton.setTitle("Delete Goal", for: .normal)}
            if goalType == "sub" { deleteButton.setTitle("Delete Sub-Goal", for: .normal)}
            
            deleteButton.backgroundColor = .systemRed
            deleteButton.setTitleColor(.white, for: .normal)
            
            NSLayoutConstraint.activate([
                deleteButton.topAnchor.constraint(equalTo: createEditButton.bottomAnchor, constant: 20),
                deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                deleteButton.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.90),
                deleteButton.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.10)
            ])
            
            deleteButton.addTarget(self, action: #selector(deleteWarning), for: .touchUpInside)
        }
    }
    
    @objc func deleteWarning() {
        let ac = UIAlertController(title: "Delete Goal",
                                   message: "Are you sure you want to delete this goal?",
                                   preferredStyle: .alert)
        let delete = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.deleteGoal()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        ac.addAction(delete)
        ac.addAction(cancel)
        present(ac, animated: true)
    }
    
    func deleteGoal() {
        if goalType == "main" {
            let goalToRemove = HomeVC.goals[currentGoalIndex!]
            DataManager.shared.persistentContainer.viewContext.delete(goalToRemove)
            DataManager.shared.save()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
            
            let vc = UINavigationController(rootViewController: HomeVC())
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
        
        if goalType == "sub" {
            let subGoalToRemove = SubGoalsVC.subGoals[currentSubIndex!]
            DataManager.shared.persistentContainer.viewContext.delete(subGoalToRemove)
            DataManager.shared.save()
            SubGoalsVC.subGoals.remove(at: currentSubIndex!)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
            
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func createGoal() {
        let goalName = goalTextfield.text ?? ""
        let goalDate = dateTextfield.text ?? ""
        
        let startNumText = currentNumberTF.text
        let startNum = Double(startNumText!) ?? 0
        
        let endNumText = numberTextfield.text
        let endNum = Double(endNumText!) ?? 0
        var checksPassed = 0
        
        func displayTFMessage(title: String, message: String) {
            let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "Continue", style: .default)
            ac.addAction(action)
            present(ac, animated: true)
        }
        
        if goalName == "" {
            displayTFMessage(title: "Please Enter a Goal Name",
                             message: "")
        } else {
            checksPassed += 1
        }
        
        if startNumText == "" && endNumText != "" {
            displayTFMessage(title: "Enter Starting Number",
                             message: "Please enter a starting number or remove the ending number")
        } else {
            checksPassed += 1
        }
        
        if startNumText != "" && endNumText == "" {
            displayTFMessage(title: "Enter Final Number Goal",
                             message: "Please enter your final numeric goal or remove the starting number")
        } else {
            checksPassed += 1
        }
        
        if checksPassed == 3 {
            // Create goal
            if action == "create" {
                if goalType == "main" {
                    let goal = DataManager.shared.goal(name: goalName, date: goalDate, startNum: startNum, endNum: endNum, cellColor: color!, index: HomeVC.goals.count, isGainGoal: gainButton.isSelected, isGoalComplete: false)
                    HomeVC.goals.append(goal)
                    DataManager.shared.save()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
                    dismiss(animated: true)
                } else if goalType == "sub" {
                    let subGoal = DataManager.shared.subGoal(name: goalName, date: goalDate, startNum: startNum, endNum: endNum, cellColor: color!, index: SubGoalsVC.subGoals.count, isGainGoal: isGainGoal, isGoalComplete: false, goal: HomeVC.goals[currentGoalIndex!])
                    SubGoalsVC.subGoals.append(subGoal)
                    DataManager.shared.save()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
                    dismiss(animated: true)
                }
            }
            // Update goal
            if action == "edit" {
                NotificationCenter.default.post(name: Notification.Name("updateGoalUI"), object: nil)
                if goalType == "main" {
                    HomeVC.goals[currentGoalIndex!].name = goalName
                    HomeVC.goals[currentGoalIndex!].date = goalDate
                    HomeVC.goals[currentGoalIndex!].startNum = startNum
                    HomeVC.goals[currentGoalIndex!].endNum = endNum
                    HomeVC.goals[currentGoalIndex!].cellColor = color
                    HomeVC.goals[currentGoalIndex!].isGainGoal = isGainGoal
                    DataManager.shared.save()
                    NotificationCenter.default.post(name: NSNotification.Name("newDataNotif"), object: nil)
                    dismiss(animated: true)
                    
                } else if goalType == "sub" {
                    SubGoalsVC.subGoals[currentSubIndex!].name = goalName
                    SubGoalsVC.subGoals[currentSubIndex!].date = goalDate
                    SubGoalsVC.subGoals[currentSubIndex!].startNum = startNum
                    SubGoalsVC.subGoals[currentSubIndex!].endNum = endNum
                    SubGoalsVC.subGoals[currentSubIndex!].cellColor = color
                    SubGoalsVC.subGoals[currentSubIndex!].isGainGoal = isGainGoal
                    DataManager.shared.save()
                    NotificationCenter.default.post(name: NSNotification.Name("newDataNotif"), object: nil)
                    dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    func createDatePicker() {
        datePicker = UIDatePicker.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 75))
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        datePicker.addTarget(self, action: #selector(dateChanged), for: .allEvents)
        
        let toolbar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44))
        let makeSpaceBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let removeBtn = UIBarButtonItem(title: "Remove", style: .plain, target: self, action: #selector(removeDate))
        let doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(dismissWithDone))
        toolbar.setItems([removeBtn, makeSpaceBtn, doneBtn], animated: true)
        
        dateTextfield.inputAccessoryView = toolbar
        dateTextfield.inputView = datePicker
    }
    
    func dismissKeyboardByTap() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @objc func removeDate() {
        DispatchQueue.main.async {
            self.dateTextfield.text = ""
        }
    }
    
    @objc func dateChanged() {
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .medium
        self.dateTextfield.text = dateFormat.string(from: datePicker.date)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        goalTextfield.resignFirstResponder()
        dateTextfield.resignFirstResponder()
        return true
    }
    
    func configureDone() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let makeSpaceBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self,
                                     action: #selector(dismissWithDone))
        toolBar.setItems([makeSpaceBtn, button], animated: true)
        toolBar.isUserInteractionEnabled = true
        return toolBar
    }
    @objc func dismissWithDone() {
        view.endEditing(true)
    }
}

extension CreateGoalVC: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        color = viewController.selectedColor
        colorButton.backgroundColor = color
    }
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        DispatchQueue.main.async {
            if self.gainButton.isSelected {
                self.gainButton.backgroundColor = self.color
            } else if self.loseButton.isSelected {
                self.loseButton.backgroundColor = self.color
            }
        }
    }
}

extension UIViewController: UITextFieldDelegate, UINavigationControllerDelegate {
    var topbarHeight: CGFloat {
            return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
                (self.navigationController?.navigationBar.frame.height ?? 0.0)
        }
}
