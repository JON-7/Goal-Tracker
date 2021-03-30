//
//  ViewNoteVC.swift
//  Goal Tracker
//
//  Created by Jon E on 2/16/21.
//

import UIKit

//MARK: The user will view this screen when they are creating a new note
//and when they are viewing their past notes

class ViewNoteVC: UIViewController {
    
    var titleLabel = UILabel()
    var dateLabel = UILabel()
    var noteLabel = UILabel()
    var currentIndex: Int!
    var noteText: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = true
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateNote), name: NSNotification.Name(NotificationName.updateNote), object: nil)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        configureTitleLabel()
        configureDateLabel()
        configureNoteTF()
    }
    
    @objc func updateNote() {
        DispatchQueue.main.async {
            self.noteText.text = NotesVC.notes[self.currentIndex!].noteText
        }
    }
    
    func configureTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 2
        titleLabel.text = NotesVC.notes[currentIndex].title
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 25, weight: .semibold)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: -40),
            titleLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -20),
            titleLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func configureDateLabel() {
        view.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.text = "last edited: \(NotesVC.notes[currentIndex].lastEdited ?? "")"
        dateLabel.textAlignment = .center
        dateLabel.font = .italicSystemFont(ofSize: 15)
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dateLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func configureNoteTF() {
        noteText.translatesAutoresizingMaskIntoConstraints = false
        noteText.text = NotesVC.notes[currentIndex].noteText
        noteText.isEditable = false
        noteText.isScrollEnabled = true
        noteText.textAlignment = .left
        noteText.layer.masksToBounds = true
        noteText.font = .preferredFont(forTextStyle: .headline)
        noteText.font = .systemFont(ofSize: 20)
        noteText.backgroundColor = Colors.mainBackgroundColor
        view.addSubview(noteText)
        
        NSLayoutConstraint.activate([
            noteText.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 20),
            noteText.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            noteText.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            noteText.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
    }
}
