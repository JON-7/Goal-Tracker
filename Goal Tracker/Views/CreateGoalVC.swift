//
//  CreateGoalFields.swift
//  Goal Tracker
//
//  Created by Jon E on 2/15/21.
//

import UIKit

class CreateGoalVC: UIViewController {
    
    let goalType: GoalType
    let action: Action
    let goalTFText: String?
    let dateTFText: String?
    let currentNumTFText: String?
    let finalNumTFText: String?
    let buttonTitle: String
    var isGainGoal: Bool
    var isGoalComplete: Bool!
    var onlyGoal: Bool?
    
    let createGoalLabel = UILabel()
    let goalTextfield = GoalTextField()
    let goalLabel = GoalTextLabel(title: LabelTitle.goalLabelTitle)
    
    let dateTextfield = GoalTextField()
    let dateLabel = GoalTextLabel(title: LabelTitle.dateLabelTitle)
    var datePicker = UIDatePicker()
    
    let currentNumberLabel = GoalTextLabel(title: LabelTitle.currentNumLabelTitle)
    let currentNumberTF = GoalTextField()
    
    let numberGoalLabel = GoalTextLabel(title: LabelTitle.numGoalLabelTitle)
    let numberTextfield = GoalTextField()
    
    let colorLabel = GoalTextLabel(title: LabelTitle.colorLableTitle)
    let colorButton = UIButton()
    
    let gainOrLoseLabel = GoalTextLabel(title: LabelTitle.gainLoseLabelTitle)
    let gainButton = GainButton()
    let loseButton = LoseButton()
    let closeButton = UIButton()
    
    let createEditButton = GoalButton()
    let deleteButton = GoalButton()
    let trailingPadding = CGFloat(5)
    let topPadding = CGFloat(19)
    let heightMultiplier = CGFloat(0.06) //0.066
    
    var currentGoalIndex: Int?
    var currentSubIndex: Int?
    
    var color: UIColor?
    // default color shown when creating a new goal
    let defaultColors = [ #colorLiteral(red: 0.8870380521, green: 0.5724834204, blue: 0.9965009093, alpha: 1), #colorLiteral(red: 0.6950762272, green: 0.8662387729, blue: 0.5456559658, alpha: 1), #colorLiteral(red: 0.7887167931, green: 0.7959396243, blue: 0.9998794198, alpha: 1), #colorLiteral(red: 0.4156676531, green: 0.7495350242, blue: 0.9007849097, alpha: 1) ]
    private let colorPicker = UIColorPickerViewController()
    
    required init(goalType: GoalType, action: Action, goalTFText: String, dateTFText: String?, currentNumTFText: String?, finalNumTFText: String?, buttonTitle: String, isGainGoal: Bool) {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDelegates()
        configureView()
    }
    
    func configureDelegates() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        view.backgroundColor = .secondarySystemBackground
        goalTextfield.delegate = self
        dateTextfield.delegate = self
        currentNumberTF.delegate = self
        numberTextfield.delegate = self
        colorPicker.delegate = self
    }
    
    func configureView() {
        if goalType == GoalType.main && dateTFText == "" && currentNumTFText == "" && finalNumTFText == "" {
            configLeftBarItem()
        }
        configureCloseButton()
        configureColor()
        if action == Action.create { configureMainLabel() }
        configureCommonUIConstraints()
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
    
    @objc func createGoal() {
        let goalName = goalTextfield.text ?? ""
        let goalDate = dateTextfield.text ?? ""
        
        let startNumText = currentNumberTF.text
        let startNum = Double(startNumText!) ?? 0
        
        let endNumText = numberTextfield.text
        let endNum = Double(endNumText!) ?? 0
        
        guard isAllDataValid() else { return }
        // Create goal
        if action == Action.create {
            if goalType == GoalType.main {
                let goal = DataManager.shared.goal(name: goalName, date: goalDate, startNum: startNum, endNum: endNum, cellColor: color!, index: HomeVC.goals.count, isGainGoal: gainButton.isSelected, isGoalComplete: false)
                HomeVC.goals.append(goal)
                DataManager.shared.save()
                NotificationCenter.default.post(name: NSNotification.Name(NotificationName.reloadData), object: nil)
                dismiss(animated: true)
            } else if goalType == GoalType.sub {
                let subGoal = DataManager.shared.subGoal(name: goalName, date: goalDate, startNum: startNum, endNum: endNum, cellColor: color!, index: SubGoalsVC.subGoals.count, isGainGoal: isGainGoal, isGoalComplete: false, goal: HomeVC.goals[currentGoalIndex!])
                SubGoalsVC.subGoals.append(subGoal)
                DataManager.shared.save()
                NotificationCenter.default.post(name: NSNotification.Name(NotificationName.reloadData), object: nil)
                dismiss(animated: true)
            }
        }
        // Update goal
        if action == Action.edit {
            NotificationCenter.default.post(name: Notification.Name(NotificationName.updateUI), object: nil)
            if goalType == GoalType.main {
                HomeVC.goals[currentGoalIndex!].name = goalName
                HomeVC.goals[currentGoalIndex!].date = goalDate
                HomeVC.goals[currentGoalIndex!].startNum = startNum
                HomeVC.goals[currentGoalIndex!].endNum = endNum
                HomeVC.goals[currentGoalIndex!].cellColor = color
                HomeVC.goals[currentGoalIndex!].isGainGoal = isGainGoal
                DataManager.shared.save()
                NotificationCenter.default.post(name: NSNotification.Name(NotificationName.reloadData), object: nil)
                dismiss(animated: true)
                
            } else if goalType == GoalType.sub {
                SubGoalsVC.subGoals[currentSubIndex!].name = goalName
                SubGoalsVC.subGoals[currentSubIndex!].date = goalDate
                SubGoalsVC.subGoals[currentSubIndex!].startNum = startNum
                SubGoalsVC.subGoals[currentSubIndex!].endNum = endNum
                SubGoalsVC.subGoals[currentSubIndex!].cellColor = color
                SubGoalsVC.subGoals[currentSubIndex!].isGainGoal = isGainGoal
                DataManager.shared.save()
                NotificationCenter.default.post(name: NSNotification.Name(NotificationName.reloadData), object: nil)
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func deleteGoal() {
        if goalType == GoalType.main {
            let goalToRemove = HomeVC.goals[currentGoalIndex!]
            DataManager.shared.persistentContainer.viewContext.delete(goalToRemove)
            DataManager.shared.save()
            NotificationCenter.default.post(name: NSNotification.Name(NotificationName.reloadData), object: nil)
            
            let vc = UINavigationController(rootViewController: HomeVC())
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
        
        if goalType == GoalType.sub {
            let subGoalToRemove = SubGoalsVC.subGoals[currentSubIndex!]
            DataManager.shared.persistentContainer.viewContext.delete(subGoalToRemove)
            DataManager.shared.save()
            SubGoalsVC.subGoals.remove(at: currentSubIndex!)
            NotificationCenter.default.post(name: NSNotification.Name(NotificationName.reloadData), object: nil)
            
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    // getting the goal color to be used throughout the UI
    func configureColor() {
        if action == Action.create {
            color = defaultColors.randomElement()
        } else if goalType == GoalType.main {
            color = HomeVC.goals[currentGoalIndex!].cellColor
        } else if goalType == GoalType.sub {
            color = SubGoalsVC.subGoals[currentSubIndex!].cellColor
        } else {
            color = defaultColors.randomElement()
        }
    }
    
    func configureCloseButton() {
        if action == Action.edit {
            navigationItem.leftBarButtonItem = .init(barButtonSystemItem: .close, target: self, action: #selector(closeView))
        }
    }
    
    @objc func closeView() {
        dismiss(animated: true)
    }
    
    func configLeftBarItem() {
        if onlyGoal ?? false && goalType == GoalType.main {
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
            let ac = AC.markIncomplete
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
            let ac = AC.markComplete
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
        if goalType == GoalType.main {
            createGoalLabel.text = "Create Goal"
        } else if goalType == GoalType.sub {
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
    
    func configureCommonUIConstraints() {
        let labels = [goalLabel, dateLabel, currentNumberLabel, numberGoalLabel, colorLabel, gainOrLoseLabel]
        let textFields = [goalTextfield, dateTextfield, currentNumberTF, numberTextfield, colorButton]
        
        for label in labels {
            view.addSubview(label)
            NSLayoutConstraint.activate([
                label.containerView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: trailingPadding),
                label.containerView.widthAnchor.constraint(equalToConstant: 100),
                label.containerView.heightAnchor.constraint(equalToConstant: view.bounds.height * heightMultiplier),
            ])
        }
        
        for textField in textFields {
            view.addSubview(textField)
            NSLayoutConstraint.activate([
                textField.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -trailingPadding),
                textField.heightAnchor.constraint(equalToConstant: view.bounds.height * heightMultiplier),
            ])
        }
    }
    
    func configureGoalNameTF() {
        goalTextfield.text = goalTFText
        
        if action == Action.create {
            NSLayoutConstraint.activate([
                goalLabel.containerView.topAnchor.constraint(equalTo: createGoalLabel.bottomAnchor, constant: -20),
                goalTextfield.topAnchor.constraint(equalTo: createGoalLabel.bottomAnchor, constant: -20),
                goalTextfield.leadingAnchor.constraint(equalTo: goalLabel.containerView.trailingAnchor),
            ])
        } else {
            NSLayoutConstraint.activate([
                goalLabel.containerView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
                goalTextfield.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
                goalTextfield.leadingAnchor.constraint(equalTo: goalLabel.containerView.trailingAnchor),
            ])
        }
    }
    
    func configureDateTF() {
        dateTextfield.text = dateTFText ?? ""
        if action == Action.create { dateTextfield.placeholder = "Optional" }
        createDatePicker()
        
        NSLayoutConstraint.activate([
            dateLabel.containerView.topAnchor.constraint(equalTo: goalLabel.containerView.bottomAnchor, constant: view.bounds.height * heightMultiplier/2),
            
            dateTextfield.topAnchor.constraint(equalTo: goalLabel.containerView.bottomAnchor, constant: view.bounds.height * heightMultiplier/2),
            dateTextfield.leadingAnchor.constraint(equalTo: dateLabel.containerView.trailingAnchor),
        ])
    }
    
    func configureCurrentNumTF() {
        currentNumberTF.keyboardType = .decimalPad
        currentNumberTF.inputAccessoryView = configureDone()
        currentNumberTF.text = currentNumTFText ?? ""
        if action == Action.create { currentNumberTF.placeholder = "Optional" }
        
        NSLayoutConstraint.activate([
            currentNumberLabel.containerView.topAnchor.constraint(equalTo: dateLabel.containerView.bottomAnchor, constant: view.bounds.height * heightMultiplier/2),
            
            currentNumberTF.topAnchor.constraint(equalTo: dateLabel.containerView.bottomAnchor, constant: view.bounds.height * heightMultiplier/2),
            currentNumberTF.leadingAnchor.constraint(equalTo: currentNumberLabel.containerView.trailingAnchor),
        ])
    }
    
    func configureNumGoalTF() {
        numberTextfield.keyboardType = .decimalPad
        numberTextfield.inputAccessoryView = configureDone()
        numberTextfield.text = finalNumTFText ?? ""
        if action == Action.create { numberTextfield.placeholder = "Optional" }
        
        NSLayoutConstraint.activate([
            numberGoalLabel.containerView.topAnchor.constraint(equalTo: currentNumberLabel.containerView.bottomAnchor, constant: view.bounds.height * heightMultiplier/2),
            
            numberTextfield.topAnchor.constraint(equalTo: currentNumberLabel.containerView.bottomAnchor, constant: view.bounds.height * heightMultiplier/2),
            numberTextfield.leadingAnchor.constraint(equalTo: numberGoalLabel.containerView.trailingAnchor),
        ])
    }
    
    func configureGoalColor() {
        colorButton.translatesAutoresizingMaskIntoConstraints = false
        colorButton.clipsToBounds = true
        colorButton.layer.cornerRadius = 10
        colorButton.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        colorButton.backgroundColor = color
        
        NSLayoutConstraint.activate([
            colorLabel.containerView.topAnchor.constraint(equalTo: numberGoalLabel.containerView.bottomAnchor, constant: view.bounds.height * heightMultiplier/2),
            
            colorButton.topAnchor.constraint(equalTo: numberGoalLabel.containerView.bottomAnchor, constant: view.bounds.height * heightMultiplier/2),
            colorButton.leadingAnchor.constraint(equalTo: colorLabel.containerView.trailingAnchor),
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
        view.addSubview(gainButton)
        view.addSubview(loseButton)
        
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
        
        NSLayoutConstraint.activate([
            gainOrLoseLabel.containerView.topAnchor.constraint(equalTo: colorLabel.containerView.bottomAnchor, constant: view.bounds.height * heightMultiplier/2),
            
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
        if action == Action.edit {
            view.addSubview(deleteButton)
            if goalType == GoalType.main { deleteButton.setTitle("Delete Goal", for: .normal)}
            if goalType == GoalType.sub { deleteButton.setTitle("Delete Sub-Goal", for: .normal)}
            
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
        let ac = AC.deleteGoal
        let delete = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.deleteGoal()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        ac.addAction(delete)
        ac.addAction(cancel)
        present(ac, animated: true)
    }
}
