//
//  HomeViewController.swift
//  Goal Tracker
//
//  Created by Jon E on 6/5/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    weak var collectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: NSNotification.Name(NotificationName.reloadCollectionView), object: nil)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.topItem?.title = "Goals"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        DataManager.shared.goals = DataManager.shared.fetchGoals()
    }
    
    private func configureCollectionView() {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.frame = view.bounds
        collectionView = cv
        view.addSubview(collectionView)
        
        collectionView.backgroundColor = Colors.mainBackgroundColor
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.reuseID)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.configureLongPress()
    }
    
    @objc func reloadData() {
        DispatchQueue.main.async {
            DataManager.shared.goals = DataManager.shared.fetchGoals()
            self.collectionView.reloadData()
        }
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataManager.shared.goals.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseID, for: indexPath) as! CollectionViewCell
        
        if indexPath.item < DataManager.shared.goals.count {
            let goal = DataManager.shared.goals[indexPath.item]
            cell.createMainCell(cellTitle: goal.name!, cellColor: goal.cellColor ?? UIColor.lightGray, isComplete: goal.isGoalComplete)
        } else {
            cell.createGoalCell(for: .main)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == DataManager.shared.goals.count {
            let vc = CreateGoalViewController()
            vc.action = Action.create
            vc.goalType = .main
            vc.goalIndex = indexPath.item
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let tabBar = GoalTabBarController(goalIndex: indexPath.item)
            navigationController?.pushViewController(tabBar, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        let lastElement = DataManager.shared.goals.count
        if indexPath.item == lastElement {
            return false
        } else { return true }
    }
    
    //MARK: Changing the current cell index to where the user moved the cell
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = DataManager.shared.goals.remove(at: sourceIndexPath.row)
        DataManager.shared.goals.insert(item, at: destinationIndexPath.row)
        
        // changing the index of all the goals
        for (index, element) in DataManager.shared.goals.enumerated() {
            element.index = Int16(index)
        }
        DataManager.shared.save()
    }
    
    // Disables the last cell (create goal button) from being moved
    func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
        if proposedIndexPath.row == DataManager.shared.goals.count {
            return IndexPath(row: proposedIndexPath.row - 1, section: proposedIndexPath.section)
        } else {
            return proposedIndexPath
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
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
