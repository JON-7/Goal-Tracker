//
//  HomeVC.swift
//  Goal Tracker
//
//  Created by Jon E on 2/15/21.
//

import UIKit

class HomeVC: UIViewController {
    weak var collectionView: UICollectionView!
    
    static var goals = [Goal]()
    var currentIndex = 0
    var nameOnly: Bool?
    var completeGoalSelected: Bool?
    var tabbarImages = [String]()
    
    let goalViewController = GoalVC(goalType: GoalType.sub)
    let subGoalViewController = SubGoalsVC()
    let notesViewController = NotesVC()
    
    override func viewWillAppear(_ animated: Bool) {
        configureTitle()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: NSNotification.Name(NotificationName.reloadData), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(closeView), name: Notification.Name("dismissNotif"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // retrieving all goal objects
        HomeVC.goals = DataManager.shared.fetchGoals()
        configureCollectionView()
        configureLongPress()
    }
    
    func configureTitle() {
        tabBarController?.hidesBottomBarWhenPushed = true
        navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "GOALS"
    }
    
    func configureCollectionView() {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.frame = view.bounds
        view.addSubview(cv)
        
        self.collectionView = cv
        collectionView.backgroundColor = Colors.mainBackgroundColor
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.reuseID)
    }
    
    // allows the user to hold their finger on a cell and move the cell around
    func configureLongPress() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture))
        collectionView.addGestureRecognizer(gesture)
        collectionView.showsVerticalScrollIndicator = false
    }
    
    @objc func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    // configuring drag and drop
    @objc func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        guard let collectionView = collectionView else { return }
        switch gesture.state {
        case .began:
            guard let targetIndex = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {
                return
            }
            collectionView.beginInteractiveMovementForItem(at: targetIndex)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: collectionView))
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
    func assignDataToVCs(index: Int) {
        let goal = HomeVC.goals[index]
        // passing data to view controllers
        subGoalViewController.goal = goal
        subGoalViewController.goalName = goal.name
        subGoalViewController.currentGoalIndex = currentIndex
        
        notesViewController.goalIndex = index
        notesViewController.goal = goal
        
        goalViewController.goalName = goal.name
        goalViewController.date = goal.date
        goalViewController.currentNum = goal.startNum
        goalViewController.endNum = goal.endNum
        goalViewController.currentGoalIndex = index
        goalViewController.goalType = GoalType.main
        goalViewController.isGainGoal = goal.isGainGoal
        goalViewController.isComplete = goal.isGoalComplete
    }
    
    func configureTabBar(index: Int) {
        let goal = HomeVC.goals[index]
        let tabbar = UITabBarController()
        let goalVC = UINavigationController(rootViewController: goalViewController)
        let subGoalsVC = UINavigationController(rootViewController: subGoalViewController)
        let notesVC = UINavigationController(rootViewController: notesViewController)

        goalVC.title = "GOAL"
        subGoalsVC.title = "Sub-Goals"
        notesVC.title = "Notes"
        
        // if goal contains only a name then the tabbar will only have a subgoal and notes view
        if goal.startNum == 0.0 && goal.endNum == 0.0 && goal.date == "" {
            tabbar.setViewControllers([subGoalsVC, notesVC], animated: true)
            nameOnly = true
            subGoalViewController.navigationItem.leftBarButtonItem = .init(barButtonSystemItem: .close, target: self, action: #selector(goHome))
            
            subGoalViewController.navigationItem.rightBarButtonItem = .init(image: Images.pencil, style: .plain, target: self, action: #selector(editGoal))
            
            tabbarImages = ["applescript", "note.text"]
        } else {
            // if the goal contains more than just a name then all three views will be shown in the tabbar
            tabbar.setViewControllers([goalVC, subGoalsVC, notesVC], animated: true)
            
            goalViewController.navigationItem.leftBarButtonItem = .init(barButtonSystemItem: .close, target: self, action: #selector(goHome))
            
            goalViewController.navigationItem.rightBarButtonItem = .init(image: Images.pencil, style: .plain, target: self, action: #selector(editGoal))
            
            tabbarImages = ["scroll.fill","applescript", "note.text"]
        }
        
        guard let items = tabbar.tabBar.items else { return }
        for n in 0..<items.count {
            items[n].image = UIImage(systemName: tabbarImages[n])
        }
        tabbar.modalPresentationStyle = .fullScreen
        present(tabbar, animated: true)
    }
}

extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return HomeVC.goals.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseID, for: indexPath) as! CollectionViewCell
        // If the cell is not the last cell (create goal cell) then give it a title and cell color
        if indexPath.item < HomeVC.goals.count {
            cell.createMainCell(cellTitle: HomeVC.goals[indexPath.row].name!, cellColor: HomeVC.goals[indexPath.row].cellColor!, isComplete: HomeVC.goals[indexPath.row].isGoalComplete)
        } else {
            cell.createGoalCell()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentIndex = indexPath.item
        // creates new goal when create goal button is pressed
        if indexPath.item == HomeVC.goals.count {
            let vc = CreateGoalVC(
                goalType: GoalType.main,
                action: Action.create,
                goalTFText: "",
                dateTFText: "",
                currentNumTFText: "",
                finalNumTFText: "",
                buttonTitle: "Create Goal",
                isGainGoal: true)
            vc.currentGoalIndex = indexPath.row
            present(vc, animated: true)
        }
        
        //MARK: Creates a tabbar containing different views depending on the goal type
        if indexPath.item < HomeVC.goals.count {
            assignDataToVCs(index: indexPath.item)
            configureTabBar(index: indexPath.item)
        }
    }
    
    @objc func goHome() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func editGoal() {
        var startNumber: String = ""
        var endNumber: String = ""
        
        if HomeVC.goals[currentIndex].endNum != 0.0 {
            startNumber = HomeVC.goals[currentIndex].startNum.formatToString
            endNumber = HomeVC.goals[currentIndex].endNum.formatToString
        }
        
        // passing the goal information so the users inputs are shown on the create goal screen
        let vc = CreateGoalVC(
            goalType: GoalType.main,
            action: Action.edit,
            goalTFText: HomeVC.goals[currentIndex].name!,
            dateTFText: HomeVC.goals[currentIndex].date ?? "",
            currentNumTFText: startNumber,
            finalNumTFText: endNumber,
            buttonTitle: "Edit Goal",
            isGainGoal: HomeVC.goals[currentIndex].isGainGoal)
        
        vc.isGoalComplete = HomeVC.goals[currentIndex].isGoalComplete
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        vc.navigationController?.navigationBar.prefersLargeTitles = true
        vc.navigationController?.navigationBar.topItem?.title = " Edit Main Goal"
        vc.navigationController?.isToolbarHidden = true
        vc.currentGoalIndex = currentIndex
        vc.onlyGoal = true
        
        DispatchQueue.main.async {
            self.getTopMostViewController()?.present(nav, animated: true, completion: nil)
        }
    }
    
    @objc func closeView() {
        collectionView.reloadData()
        
        dismiss(animated: true)
    }
    
    func getTopMostViewController() -> UIViewController? {
        var topMostViewController = UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController
        
        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }
        return topMostViewController
    }
}

extension HomeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width - 30, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 30, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        let lastElement = HomeVC.goals.count
        if indexPath.item == lastElement {
            return false
        } else { return true }
    }
    
    //MARK: Changing the current cell index to where the user moved the cell
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = HomeVC.goals.remove(at: sourceIndexPath.row)
        HomeVC.goals.insert(item, at: destinationIndexPath.row)
        
        // changing the index of all the goals
        for (index, element) in HomeVC.goals.enumerated() {
            element.index = Int16(index)
        }
        
        DataManager.shared.save()
    }
    
    // This function makes it so the last cell (create goal button) can't be moved
    func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
        if proposedIndexPath.row == HomeVC.goals.count {
            return IndexPath(row: proposedIndexPath.row - 1, section: proposedIndexPath.section)
        } else {
            return proposedIndexPath
        }
    }
}
