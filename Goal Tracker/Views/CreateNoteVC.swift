//
//  CreateNoteVC.swift
//  Goal Tracker
//
//  Created by Jon E on 2/17/21.
//

import UIKit

class CreateNoteVC: UIViewController {
    
    init(action: String, noteTitle: String, noteText: String) {
        self.action = action
        self.noteTitle = noteTitle
        self.noteText = noteText
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var action: String?
    var noteTitle: String?
    var noteText: String?
    
    var goalIndex: Int?
    var noteIndex: Int?
    
    var titleLabel = UILabel()
    var titleTF = UITextField()
    var noteLabel = UILabel()
    var noteTF = UITextView()
    
    var currentIndex: Int?
    var currentGoalIndex: Int?
    let padding = CGFloat(10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureTitleLabel()
        configureTitleTF()
        configureNoteLabel()
        configureNoteTF()
        dismissKeyboardByTap()
    }
    
    func configureNavigationBar() {
        if action == "edit" {
            navigationItem.rightBarButtonItem = .init(
                image: UIImage(systemName: "checkmark"),
                style: .plain,
                target: self,
                action: #selector(editNote))
        } else {
            navigationItem.rightBarButtonItem = .init(
                image: UIImage(systemName: "checkmark"),
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
        titleTF.backgroundColor = UIColor(named: "noteTFColor")
        titleTF.layer.cornerRadius = 10
        titleTF.textColor = .black
        
        if action == "edit" {
            titleTF.text = noteTitle
        }
        
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
        noteTF.backgroundColor = UIColor(named: "noteTFColor")
        noteTF.font = .systemFont(ofSize: 22)
        noteTF.textColor = .black
        
        if action == "edit" {
            noteTF.text = noteText
        }
        
        NSLayoutConstraint.activate([
            noteTF.topAnchor.constraint(equalTo: noteLabel.bottomAnchor, constant: 5),
            noteTF.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: padding),
            noteTF.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -padding),
            noteTF.heightAnchor.constraint(equalToConstant: view.bounds.height / 3.25)
        ])
    }
    
    @objc func createNote() {
        if noteTF.text != "" {
            var title: String
            if titleTF.text != "" {
                title = titleTF.text!
            } else {
                title = "Untitled"
            }
            
            let note = DataManager.shared.note(title: title, lastEdited: formatDate(), noteText: noteTF.text, date: Date(), goal: HomeVC.goals[goalIndex!])
            NotesVC.notes.append(note)
            DataManager.shared.save()
            navigationController?.popViewController(animated: true)
        }
        else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func editNote() {
        NotesVC.notes[noteIndex!].title = titleTF.text
        NotesVC.notes[noteIndex!].noteText = noteTF.text
        NotesVC.notes[noteIndex!].lastEdited = formatDate()
        NotesVC.notes[noteIndex!].date = Date()
        DataManager.shared.save()
        navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: NSNotification.Name("updateNote"), object: nil)
    }
    
    func dismissKeyboardByTap() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
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
