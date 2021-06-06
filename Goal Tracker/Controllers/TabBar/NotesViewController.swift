//
//  NotesViewController.swift
//  Goal Tracker
//
//  Created by Jon E on 6/5/21.
//

import UIKit

class NotesViewController: UIViewController {
    
    var goalIndex: Int!
    weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        if DataManager.shared.notes.count > 1 {
            DataManager.shared.notes.sort(by: {$0.date! > $1.date! })
        }
        title = "Notes"
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        
        if let allNotes = DataManager.shared.goals[goalIndex].notes?.allObjects as? [Note] {
            DataManager.shared.notes = allNotes
        }
    }
    
    private func configureTableView() {
        let table = UITableView()
        view.addSubview(table)
        tableView = table
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.frame = view.bounds
        tableView.rowHeight = view.bounds.height * 0.13
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.reuseID)
        tableView.backgroundColor = Colors.mainBackgroundColor
    }
    
    @objc func createNote() {
        let vc = CreateNoteViewController(action: .create, goalIndex: goalIndex, noteIndex: 0, noteTitle: "", noteText: "")
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension NotesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.shared.notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseID, for: indexPath) as! TableViewCell
        cell.set(noteIndex: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ViewNoteViewController()
        vc.currentIndex = indexPath.row
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            
            let noteToRemove = DataManager.shared.notes[indexPath.row]
            
            DataManager.shared.persistentContainer.viewContext.delete(noteToRemove)
            DataManager.shared.save()
            
            tableView.endUpdates()
            DataManager.shared.notes.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
}
