//
//  CreateNoteViewController.swift
//  Goal Tracker
//
//  Created by Jon E on 6/5/21.
//

import UIKit

class CreateNoteViewController: UIViewController {
    
    var action: Action
    var goalIndex: Int!
    var noteIndex: Int!
    var noteTitle: String?
    var noteText: String?
    
    var titleLabel = UILabel()
    var titleTF = UITextField()
    var noteLabel = UILabel()
    var noteTF = UITextView()
    
    var currentIndex: Int?
    var currentGoalIndex: Int?
    let padding = CGFloat(10)
    
    init(action: Action, goalIndex: Int, noteIndex: Int, noteTitle: String, noteText: String) {
        self.action = action
        self.noteTitle = noteTitle
        self.noteText = noteText
        self.goalIndex = goalIndex
        self.noteIndex = noteIndex
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.mainBackgroundColor
        configureView()
    }
    
    private func configureView() {
        configureNavigationBar()
        configureTitleLabel()
        configureTitleTF()
        configureNoteLabel()
        configureNoteTF()
        configureText()
        dismissKeyboardByTap()
    }
    
    func configureNavigationBar() {
        if action == Action.edit {
            navigationItem.rightBarButtonItem = .init(
                image: SFSymbol.checkmark,
                style: .plain,
                target: self,
                action: #selector(editNote))
        } else {
            navigationItem.rightBarButtonItem = .init(
                image: SFSymbol.checkmark,
                style: .plain,
                target: self,
                action: #selector(createNote))
        }
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func configureTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Note Title"
        titleLabel.font = .boldSystemFont(ofSize: 20)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: -40),
            titleLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func configureTitleTF() {
        view.addSubview(titleTF)
        titleTF.translatesAutoresizingMaskIntoConstraints = false
        titleTF.backgroundColor = Colors.noteTFColor
        titleTF.layer.cornerRadius = 10
        titleTF.textColor = .black
        titleTF.setLeftPaddingPoints(10)
        titleTF.setRightPaddingPoints(10)
        
        NSLayoutConstraint.activate([
            titleTF.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            titleTF.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: padding),
            titleTF.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -padding),
            titleTF.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    func configureNoteLabel() {
        view.addSubview(noteLabel)
        noteLabel.translatesAutoresizingMaskIntoConstraints = false
        noteLabel.text = "Note:"
        noteLabel.font = .boldSystemFont(ofSize: 20)
        
        NSLayoutConstraint.activate([
            noteLabel.topAnchor.constraint(equalTo: titleTF.bottomAnchor, constant: 15),
            noteLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: padding),
            noteLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -padding),
            noteLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func configureNoteTF() {
        view.addSubview(noteTF)
        noteTF.translatesAutoresizingMaskIntoConstraints = false
        noteTF.layer.cornerRadius = 10
        noteTF.backgroundColor = Colors.noteTFColor
        noteTF.font = .systemFont(ofSize: 22)
        noteTF.textColor = .black
        
        NSLayoutConstraint.activate([
            noteTF.topAnchor.constraint(equalTo: noteLabel.bottomAnchor, constant: 5),
            noteTF.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: padding),
            noteTF.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -padding),
            noteTF.heightAnchor.constraint(equalToConstant: view.bounds.height / 3.25)
        ])
    }
    
    private func configureText() {
        if action == Action.edit {
            titleTF.text = self.noteTitle
            noteTF.text = self.noteText
        }
    }
    
    @objc func createNote() {
        var title: String
        if noteTF.text != "" {
            if titleTF.text != "" {
                title = titleTF.text!
            } else {
                title = "Untitled"
            }
            
            let note = DataManager.shared.note(title: title, lastEdited: formatDate(), noteText: noteTF.text, date: Date(), goal: DataManager.shared.goals[goalIndex])
            DataManager.shared.notes.append(note)
            DataManager.shared.save()
            navigationController?.popViewController(animated: true)
        }
        else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func editNote() {
        DataManager.shared.notes[noteIndex].title = titleTF.text
        DataManager.shared.notes[noteIndex].noteText = noteTF.text
        DataManager.shared.notes[noteIndex].lastEdited = formatDate()
        DataManager.shared.notes[noteIndex].date = Date()
        DataManager.shared.save()
        NotificationCenter.default.post(name: Notification.Name(NotificationName.reloadCollectionView), object: nil)
        navigationController?.popBack(2)
    }
    
    func formatDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale.current
        let formatedDate = dateFormatter.string(from: Date())
        return formatedDate
    }
}
