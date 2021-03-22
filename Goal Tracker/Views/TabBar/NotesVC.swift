//
//  NotesVC.swift
//  Goal Tracker
//
//  Created by Jon E on 2/15/21.
//

import UIKit

class NotesVC: UIViewController {
    static var notes = [Note]()
    var goal: Goal?
    var goalIndex: Int?
    var noteIndex: Int?
    
    var tableView = UITableView()
    
    override func viewWillAppear(_ animated: Bool) {
        if NotesVC.notes.count > 1 {
            NotesVC.notes.sort(by: {$0.date! > $1.date! })
        }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        configureTableView()
        configureNav()
        view.backgroundColor = UIColor(named: "mainBackgroundColor")
        
        if let allNotes = goal?.notes?.allObjects as? [Note] {
            NotesVC.notes = allNotes
        }
    }
    
    func configureTableView() {
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "tableCell")
        tableView.backgroundColor = UIColor(named: "mainBackgroundColor")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 100
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func configureNav() {
        title = "Notes"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = .init(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNote))
    }
    
    @objc func addNote() {
        let vc = CreateNoteVC(action: "", noteTitle: "", noteText: "")
        vc.view.backgroundColor = UIColor(named: "mainBackgroundColor")
        vc.goalIndex = goalIndex
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension NotesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NotesVC.notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell") as! TableViewCell
        cell.titleLabel.text = NotesVC.notes[indexPath.row].title
        cell.backgroundColor = UIColor(named: "mainBackgroundColor")
        cell.dateLabel.text = NotesVC.notes[indexPath.row].lastEdited
        cell.notePreview.text = NotesVC.notes[indexPath.row].noteText
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ViewNoteVC()
        vc.currentIndex = indexPath.row
        vc.navigationItem.rightBarButtonItem = .init(
            image: UIImage(systemName: "pencil"),
            style: .plain,
            target: self,
            action: #selector(editNote))
        
        //let navVC = UINavigationController(rootViewController: vc)
        vc.view.backgroundColor = UIColor(named: "mainBackgroundColor")
        //navVC.modalPresentationStyle = .fullScreen
        self.noteIndex = indexPath.row
        //present(navVC, animated: true)
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func editNote() {
        let vc = CreateNoteVC(action: "edit", noteTitle: NotesVC.notes[noteIndex!].title ?? "", noteText: NotesVC.notes[noteIndex!].noteText ?? "")
        vc.goalIndex = goalIndex
        vc.noteIndex = noteIndex
        vc.view.backgroundColor = UIColor(named: "mainBackgroundColor")
//        let navVC = UINavigationController(rootViewController: vc)
//        navVC.modalPresentationStyle = .fullScreen
//        DispatchQueue.main.async {
//            self.getTopMostViewController()?.present(navVC, animated: true, completion: nil)
//        }
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func getTopMostViewController() -> UIViewController? {
        var topMostViewController = UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController
        
        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }
        return topMostViewController
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            
            let personToRemove = NotesVC.notes[indexPath.row]
            
            DataManager.shared.persistentContainer.viewContext.delete(personToRemove)
            DataManager.shared.save()
            
            tableView.endUpdates()
            NotesVC.notes.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
}
            
