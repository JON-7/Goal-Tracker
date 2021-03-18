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
    
    override func loadView() {
        super.loadView()
        // Setting up collection view
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cv)
        
        NSLayoutConstraint.activate([
            cv.topAnchor.constraint(equalTo: view.topAnchor, constant: -20),
            cv.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cv.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cv.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        self.collectionView = cv
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: NSNotification.Name("newDataNotif"), object: nil)
        collectionView.reloadData()
        navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "GOALS"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(closeView), name: Notification.Name("dismissNotif"), object: nil)
        // retrieving all goal objects
        HomeVC.goals = DataManager.shared.fetchGoals()
        navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "GOALS"
        collectionView.backgroundColor = UIColor(named: "mainBackgroundColor")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture))
        collectionView.addGestureRecognizer(gesture)
        collectionView.showsVerticalScrollIndicator = false
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
    
    @objc func reloadData() {
        self.collectionView.reloadData()
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! CollectionViewCell
        cell.clipsToBounds = true
        cell.textLabel.numberOfLines = 1
        cell.textLabel.textColor = .white
        cell.textLabel.font = .systemFont(ofSize: 30, weight: .semibold)        
        cell.layer.cornerRadius = 20
        
        // creates the goal cells
        if indexPath.item < HomeVC.goals.count {
            cell.layer.cornerRadius = 20
            cell.textLabel.backgroundColor = HomeVC.goals[indexPath.row].cellColor
            cell.textLabel.numberOfLines = 2
            
            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: HomeVC.goals[indexPath.row].name ?? "Name not found")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            if HomeVC.goals[indexPath.row].isGoalComplete {
                cell.textLabel.attributedText = attributeString
            } else {
                attributeString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0, attributeString.length))
                cell.textLabel.attributedText = attributeString
            }
        }
        
        // creates the create goal button
        if indexPath.item == HomeVC.goals.count {
            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: "Create Goal")
            cell.textLabel.attributedText = attributeString
            cell.layer.cornerRadius = 45
            cell.textLabel.backgroundColor = UIColor(named: "goalActionBtnColor")
            cell.textLabel.textColor = .black
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentIndex = indexPath.item
        // creates new goal when create goal button is pressed
        if indexPath.item == HomeVC.goals.count {
            let vc = CreateGoalVC(
                goalType: "main",
                action: "create",
                goalTFText: "",
                dateTFText: "",
                currentNumTFText: "",
                finalNumTFText: "",
                buttonTitle: "Create Goal",
                isGainGoal: true)
            vc.currentGoalIndex = indexPath.row
            present(vc, animated: true)
        }
        
        //MARK: Creating a tab ViewController when a goal cell is tapped with views depending on the type of goal
        if indexPath.item < HomeVC.goals.count {
            
            let tabbar = UITabBarController()
            let goal = HomeVC.goals[indexPath.row]
            
            let goalViewController = GoalVC(goalType: "sub")
            let subGoalViewController = SubGoalsVC()
            let notesViewController = NotesVC()
            
            // passing data to view controllers
            subGoalViewController.goal = goal
            subGoalViewController.goalName = goal.name
            subGoalViewController.currentGoalIndex = currentIndex
            
            notesViewController.goalIndex = indexPath.row
            notesViewController.goal = goal
            
            goalViewController.goalName = goal.name
            goalViewController.date = goal.date
            goalViewController.currentNum = goal.startNum
            goalViewController.endNum = goal.endNum
            goalViewController.currentGoalIndex = indexPath.item
            goalViewController.goalType = "main"
            goalViewController.isGainGoal = goal.isGainGoal
            goalViewController.isComplete = goal.isGoalComplete
            
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
                subGoalViewController.navigationItem.leftBarButtonItem = .init(
                    barButtonSystemItem: .close,
                    target: self,
                    action: #selector(goHome))
                
                subGoalViewController.navigationItem.rightBarButtonItem = .init(
                    image: UIImage(systemName: "pencil"),
                    style: .plain,
                    target: self,
                    action: #selector(editGoal))
                
                guard let items = tabbar.tabBar.items else { return }
                
                let images = ["applescript", "note.text"]
                
                for n in 0..<items.count {
                    items[n].image = UIImage(systemName: images[n])
                }
                tabbar.modalPresentationStyle = .fullScreen
                present(tabbar, animated: true)
                
            } else {
                // if the goal contains more than just a name then all three views will be shown in the tabbar
                tabbar.setViewControllers([goalVC, subGoalsVC, notesVC], animated: true)
                
                goalViewController.navigationItem.leftBarButtonItem = .init(
                    barButtonSystemItem: .close,
                    target: self,
                    action: #selector(goHome))
                
                goalViewController.navigationItem.rightBarButtonItem = .init(
                    image: UIImage(systemName: "pencil"),
                    style: .plain,
                    target: self,
                    action: #selector(editGoal))
                
                guard let items = tabbar.tabBar.items else { return }
                let images = ["scroll.fill","applescript", "note.text"]
                
                for n in 0..<items.count {
                    items[n].image = UIImage(systemName: images[n])
                }
                
                tabbar.modalPresentationStyle = .fullScreen
                present(tabbar, animated: true)
            }
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
            goalType: "main",
            action: "edit",
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
        
        vc.navigationItem.rightBarButtonItem = .init(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(closeView))
        vc.currentGoalIndex = currentIndex
        vc.onlyGoal = true
        
        DispatchQueue.main.async {
            self.getTopMostViewController()?.present(nav, animated: true, completion: nil)
        }
    }
    
    @objc func closeView() {
        collectionView.reloadData()
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
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
