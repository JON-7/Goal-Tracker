//
//  SubGoalViewController.swift
//  Goal Tracker
//
//  Created by Jon E on 6/5/21.
//

import UIKit

class SubGoalViewController: UIViewController {
    
    weak var collectionView: UICollectionView!
    var goalIndex: Int!
    
    override func viewWillAppear(_ animated: Bool) {
        if DataManager.shared.goals.count > 1 {
            // sorting subgoals by their index number
            DataManager.shared.subGoals.sort(by: {$0.index < $1.index})
        }
        self.collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getStoredSubGoals()
        configureCollectionView()
    }
    
    //MARK: Retrieving all sub goals
    private func getStoredSubGoals() {
        if let allSubGoals = DataManager.shared.goals[goalIndex].subGoals?.allObjects as? [SubGoal] {
            DataManager.shared.subGoals = allSubGoals
        }
    }
    
    private func configureCollectionView() {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.frame = view.bounds
        view.addSubview(cv)
        
        collectionView = cv
        collectionView.backgroundColor = Colors.mainBackgroundColor
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.reuseID)
        collectionView.configureLongPress()
    }
}

extension SubGoalViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // the number of goals plus the create goal button
        return DataManager.shared.subGoals.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseID, for: indexPath) as! CollectionViewCell
        
        // creating main cell
        if indexPath.item < DataManager.shared.subGoals.count {
            cell.createMainCell(cellTitle: DataManager.shared.subGoals[indexPath.item].name!, cellColor: DataManager.shared.subGoals[indexPath.item].cellColor ?? UIColor.lightGray, isComplete: DataManager.shared.subGoals[indexPath.item].isGoalComplete)
        } else {
            // creating a create goal cell, which is always the last cell
            cell.createGoalCell(for: .sub)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // presenting create goal screen
        if indexPath.item == DataManager.shared.subGoals.count {
            let vc = CreateGoalViewController()
            vc.action = Action.create
            vc.goalType = .sub
            vc.goalIndex = goalIndex
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = GoalInfoViewController(goalIndex: indexPath.item, goalType: .sub)
            vc.navigationController?.navigationBar.prefersLargeTitles = true
            vc.title = "Sub-Goal"
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: Touch and drag methods
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        let lastElement = DataManager.shared.subGoals.count
        if indexPath.item == lastElement {
            return false
        } else { return true }
    }
    
    //MARK: Changing the current cell index to where the user moved the cell
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = DataManager.shared.subGoals.remove(at: sourceIndexPath.row)
        DataManager.shared.subGoals.insert(item, at: destinationIndexPath.row)
        
        // changing the index of all the goals
        for (index, element) in DataManager.shared.subGoals.enumerated() {
            element.index = Int16(index)
        }
        DataManager.shared.save()
    }
    
    // Disables the last cell (create sub goal button) from being moved
    func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
        if proposedIndexPath.row == DataManager.shared.subGoals.count {
            return IndexPath(row: proposedIndexPath.row - 1, section: proposedIndexPath.section)
        } else {
            return proposedIndexPath
        }
    }
}

extension SubGoalViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width - 30, height: view.bounds.height * 0.11)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 10, left: 0, bottom: 0, right: 0)
    }
}
