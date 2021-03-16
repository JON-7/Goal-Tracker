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

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTitleLabel()
        configureDateLabel()
        configureNoteTF()
    }
    
    func configureTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 2
        
        titleLabel.text = NotesVC.notes[currentIndex].title
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 25, weight: .semibold)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
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
        view.addSubview(noteLabel)
        noteLabel.translatesAutoresizingMaskIntoConstraints = false
        noteLabel.numberOfLines = 0
        noteLabel.text = NotesVC.notes[currentIndex].noteText
        noteLabel.textAlignment = .left
        noteLabel.layer.masksToBounds = true
        noteLabel.font = .preferredFont(forTextStyle: .headline)
        noteLabel.font = .systemFont(ofSize: 20)
    
        NSLayoutConstraint.activate([
            noteLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 20),
            noteLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 10),
            noteLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -10),
        ])
    }
}
