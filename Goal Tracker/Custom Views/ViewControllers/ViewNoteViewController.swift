//
//  ViewNoteViewController.swift
//  Goal Tracker
//
//  Created by Jon E on 6/5/21.
//

import UIKit

class ViewNoteViewController: UIViewController {

    var titleLabel = UILabel()
    var dateLabel = UILabel()
    var noteLabel = UILabel()
    var noteText = UITextView()
    var currentIndex: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateNote), name: NSNotification.Name("updateNoteNotif"), object: nil)
        view.backgroundColor = Colors.mainBackgroundColor
        configureNavBar()
        configureTitleLabel()
        configureDateLabel()
        configureNoteTF()
    }
    
    @objc func updateNote() {
        DispatchQueue.main.async {
            self.noteText.text = DataManager.shared.notes[self.currentIndex!].noteText
            self.titleLabel.text = DataManager.shared.notes[self.currentIndex!].title
        }
    }
    
    private func configureNavBar() {
        navigationItem.rightBarButtonItem = .init(image: SFSymbol.pencil, style: .plain, target: self, action: #selector(editNote))
    }
    
    @objc private func editNote() {
        let note = DataManager.shared.notes[currentIndex]
        let vc = CreateNoteViewController(action: .edit, goalIndex: 0, noteIndex: currentIndex, noteTitle: note.title ?? "", noteText: note.noteText ?? "")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func configureTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 2
        titleLabel.text = DataManager.shared.notes[currentIndex].title
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
        dateLabel.text = "last edited: \(DataManager.shared.notes[currentIndex].lastEdited ?? "")"
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
        noteText.text = DataManager.shared.notes[currentIndex].noteText
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
