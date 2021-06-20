//
//  GoalFormViewController.swift
//  Goal Tracker
//
//  Created by Jon E on 6/5/21.
//

import UIKit

class GoalFormViewController: UIViewController {

    let titleLabel = UILabel()
    let goalNameField = GoalFormField(fieldTitle: "Goal Name")
    
    let dateFieldTitleLabel = GoalFormFieldTitle()
    let dateFieldButton = UIButton()
    let removeDateButton = UIButton()
    var datePicker = UIDatePicker()
    let goalDateField = GoalFormField(fieldTitle: "Goal Date")
    
    let currentNumberField = GoalFormField(fieldTitle: "Current Number")
    let goalNumberField = GoalFormField(fieldTitle: "Goal Number")
    
    let goalColorTitle = GoalFormFieldTitle()
    let goalColorButton = GoalFormColorButton()
    let colorPicker = UIColorPickerViewController()
    var color: UIColor?
    let defaultColors = [ #colorLiteral(red: 0.8696990609, green: 0.1960541904, blue: 0.1434972286, alpha: 1), #colorLiteral(red: 0.1998566985, green: 1, blue: 0.3499138355, alpha: 1), #colorLiteral(red: 0.9999932647, green: 0.583832562, blue: 0.003391326172, alpha: 1), #colorLiteral(red: 0, green: 0.6288877726, blue: 0.9007841945, alpha: 1), #colorLiteral(red: 0.5648367405, green: 0.237344414, blue: 0.9931138158, alpha: 1) ]
    
    let goalTypeTitle = GoalFormFieldTitle()
    let gainButton = UIButton()
    let loseButton = UIButton()
    let createButton = GoalButton()
    let deleteButton = GoalButton()
    var ac = UIAlertController()
    
    var isGoalComplete = false
    var isGainGoal: Bool!
    var containsDate = false
    var goalAction: Action
    var goalType: GoalType
    var goalIndex: Int!
    var date: Date?
    
    let sidePadding: CGFloat = 20
    let topPadding: CGFloat = 10
    let heightMultiplier: CGFloat = 0.06
    
    init(action: Action, goalType: GoalType) {
        self.goalAction = action
        self.goalType = goalType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: Notification.Name(NotificationName.reloadCollectionView), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        configureView()
        dismissKeyboardByTap()
    }
    
    private func setDelegates() {
        goalNameField.goalTF.delegate = self
        goalDateField.goalTF.delegate = self
        currentNumberField.goalTF.delegate = self
        goalNumberField.goalTF.delegate = self
        colorPicker.delegate = self
    }
    
    private func configureView() {
        view.backgroundColor = .secondarySystemBackground
        configureColor()
        configureTitle()
        configureCommonFields()
        configureGoalColorField()
        configureGoalTypeField()
        configureGoalButton()
        configureDateField()
        createDatePicker()
    }
    
    private func configureColor() {
        if goalAction == .create {
            color = defaultColors.randomElement()
        }
    }
    
    private func configureTitle() {
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.font = .init(name: "DINAlternate-Bold", size: 40)
        var createGoalTitle = ""
        var editGoalTitle = ""
        
        if goalType == .main {
            createGoalTitle = "Create Goal"
            editGoalTitle = "Edit Goal"
        } else {
            createGoalTitle = "Create Sub-Goal"
            editGoalTitle = "Edit Sub-Goal"
        }
        
        if goalAction == Action.create {
            titleLabel.attributedText = NSAttributedString(string: createGoalTitle, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
        } else if goalAction == Action.edit {
            titleLabel.attributedText = NSAttributedString(string: editGoalTitle, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 85),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    private func configureDateField() {
        view.addSubview(dateFieldTitleLabel)
        dateFieldTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        dateFieldTitleLabel.titleLabel.text = "Date"
        
        view.addSubview(dateFieldButton)
        dateFieldButton.translatesAutoresizingMaskIntoConstraints = false
        dateFieldButton.backgroundColor = .tertiarySystemBackground
        dateFieldButton.layer.cornerRadius = 10
        dateFieldButton.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        
        if !containsDate { displayDateOptional() }
        
        view.addSubview(removeDateButton)
        removeDateButton.translatesAutoresizingMaskIntoConstraints = false
        removeDateButton.setTitle("Remove", for: .normal)
        removeDateButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .thin)
        
        NSLayoutConstraint.activate([
            dateFieldTitleLabel.topAnchor.constraint(equalTo: goalNameField.bottomAnchor, constant: topPadding),
            dateFieldTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sidePadding),
            dateFieldTitleLabel.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.25),
            dateFieldTitleLabel.heightAnchor.constraint(equalToConstant: view.bounds.height * heightMultiplier),
            
            dateFieldButton.topAnchor.constraint(equalTo: goalNameField.bottomAnchor, constant: topPadding),
            dateFieldButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * 0.25 + sidePadding),
            dateFieldButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sidePadding),
            dateFieldButton.heightAnchor.constraint(equalToConstant: view.bounds.height * heightMultiplier),
            
            removeDateButton.topAnchor.constraint(equalTo: goalNameField.bottomAnchor, constant: topPadding),
            removeDateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sidePadding - 15),
            removeDateButton.heightAnchor.constraint(equalToConstant: view.bounds.height * heightMultiplier),
        ])
    }
    
    func displayDateOptional() {
        dateFieldButton.setTitle("Optional", for: .normal)
        dateFieldButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        dateFieldButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        dateFieldButton.setTitleColor(.lightGray, for: .normal)
    }
    
    private func configureCommonFields() {
        let views = [goalNameField, currentNumberField, goalNumberField]
        
        for n in views {
            view.addSubview(n)
            n.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                n.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sidePadding),
                n.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sidePadding),
                n.heightAnchor.constraint(equalToConstant: view.bounds.height * heightMultiplier),
            ])
        }
        
        goalNameField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30).isActive = true
        currentNumberField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: (view.bounds.height * heightMultiplier) * 2 + (topPadding * 5)).isActive = true
        goalNumberField.topAnchor.constraint(equalTo: currentNumberField.bottomAnchor, constant: topPadding).isActive = true
        
        goalNameField.goalTF.autocorrectionType = .default
        goalNameField.goalTF.inputAccessoryView = configureDone()
        currentNumberField.goalTF.keyboardType = .decimalPad
        currentNumberField.goalTF.inputAccessoryView = configureDone()
        currentNumberField.goalTF.attributedPlaceholder = NSAttributedString(string: "Optional", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        goalNumberField.goalTF.keyboardType = .decimalPad
        goalNumberField.goalTF.inputAccessoryView = configureDone()
        goalNumberField.goalTF.attributedPlaceholder = NSAttributedString(string: "Optional", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
    }
    
    private func configureGoalColorField() {
        view.addSubview(goalColorTitle)
        goalColorTitle.translatesAutoresizingMaskIntoConstraints = false
        goalColorTitle.titleLabel.text = "Goal Color"
        
        view.addSubview(goalColorButton)
        goalColorButton.translatesAutoresizingMaskIntoConstraints = false
        goalColorButton.clipsToBounds = true
        goalColorButton.backgroundColor = color
        goalColorButton.addTarget(self, action: #selector(showColorPicker), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            goalColorTitle.topAnchor.constraint(equalTo: goalNumberField.bottomAnchor, constant: topPadding),
            goalColorTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sidePadding),
            goalColorTitle.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.25),
            goalColorTitle.heightAnchor.constraint(equalToConstant: view.bounds.height * heightMultiplier),
            
            goalColorButton.topAnchor.constraint(equalTo: goalNumberField.bottomAnchor, constant: topPadding),
            goalColorButton.leadingAnchor.constraint(equalTo: goalColorTitle.trailingAnchor),
            goalColorButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sidePadding),
            goalColorButton.heightAnchor.constraint(equalToConstant: view.bounds.height * heightMultiplier),
        ])
    }
    
    @objc private func showColorPicker() {
        colorPicker.supportsAlpha = true
        colorPicker.selectedColor = color!
        colorPicker.modalPresentationStyle = .fullScreen
        present(colorPicker, animated: true)
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        color = viewController.selectedColor
        goalColorButton.backgroundColor = color
        datePicker.tintColor = color
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
    
    private func configureGainButton() {
        view.addSubview(gainButton)
        gainButton.translatesAutoresizingMaskIntoConstraints = false
        gainButton.setTitle("GAIN", for: .normal)
        gainButton.setTitleColor(Colors.textColor, for: .normal)
        gainButton.addTarget(self, action: #selector(gainPressed), for: .touchUpInside)
        
        DispatchQueue.main.async { [self] in
            if isGainGoal {
                gainButton.isSelected = true
                loseButton.isSelected = false
                gainButton.backgroundColor = color
                loseButton.backgroundColor = .tertiarySystemBackground
            }
        }
    }
    
    private func configureLoseButton() {
        view.addSubview(loseButton)
        loseButton.translatesAutoresizingMaskIntoConstraints = false
        loseButton.setTitle("LOSE", for: .normal)
        loseButton.setTitleColor(Colors.textColor, for: .normal)
        loseButton.layer.cornerRadius = 10
        loseButton.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        loseButton.addTarget(self, action: #selector(losePressed), for: .touchUpInside)
        
        DispatchQueue.main.async { [self] in
            if !isGainGoal {
                gainButton.isSelected = false
                loseButton.isSelected = true
                gainButton.backgroundColor = .tertiarySystemBackground
                loseButton.backgroundColor = color
            }
        }
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
    
    private func configureGoalTypeField() {
        view.addSubview(goalTypeTitle)
        goalTypeTitle.translatesAutoresizingMaskIntoConstraints = false
        goalTypeTitle.titleLabel.text = "Goal Type"
        configureGainButton()
        configureLoseButton()
        
        NSLayoutConstraint.activate([
            goalTypeTitle.topAnchor.constraint(equalTo: goalColorButton.bottomAnchor, constant: topPadding),
            goalTypeTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sidePadding),
            goalTypeTitle.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.25),
            goalTypeTitle.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * heightMultiplier),
            
            gainButton.topAnchor.constraint(equalTo: goalColorButton.bottomAnchor, constant: topPadding),
            gainButton.leadingAnchor.constraint(equalTo: goalTypeTitle.trailingAnchor),
            gainButton.widthAnchor.constraint(equalToConstant: (view.bounds.width - sidePadding - (UIScreen.main.bounds.width * 0.25) - sidePadding) / 2),
            gainButton.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * heightMultiplier),
            
            loseButton.topAnchor.constraint(equalTo: goalColorButton.bottomAnchor, constant: topPadding),
            loseButton.leadingAnchor.constraint(equalTo: gainButton.trailingAnchor),
            loseButton.widthAnchor.constraint(equalToConstant: (view.bounds.width - sidePadding - (UIScreen.main.bounds.width * 0.25) - sidePadding) / 2),
            loseButton.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * heightMultiplier),
        ])
    }
    
    private func configureGoalButton() {
        view.addSubview(createButton)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            createButton.topAnchor.constraint(equalTo: gainButton.bottomAnchor, constant: 20),
            createButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.70),
            createButton.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.09)
        ])
        
        if goalAction == Action.create {
            createButton.setTitle("Create Goal", for: .normal)
        } else {
            createButton.setTitle("Edit Goal", for: .normal)
            configureDeleteButton()
        }
    }
    
    private func configureDeleteButton() {
        view.addSubview(deleteButton)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.setTitle("Delete Goal", for: .normal)
        deleteButton.backgroundColor = .systemRed
        
        NSLayoutConstraint.activate([
            deleteButton.topAnchor.constraint(equalTo: createButton.bottomAnchor, constant: 20),
            deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.70),
            deleteButton.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.09)
        ])
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if currentNumberField.goalTF.text == "" && goalNumberField.goalTF.text != "" {
            currentNumberField.goalTF.placeholder = ""
        }
        
        if currentNumberField.goalTF.text != "" && goalNumberField.goalTF.text == "" {
            goalNumberField.goalTF.placeholder = ""
        }
        
        if currentNumberField.goalTF.text == "" && goalNumberField.goalTF.text == "" {
            currentNumberField.goalTF.placeholder = "Optional"
            goalNumberField.goalTF.placeholder = "Optional"
        }
    }
}
