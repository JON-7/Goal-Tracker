//
//  ViewSubGoalVC.swift
//  Goal Tracker
//
//  Created by Jon E on 2/15/21.
//

import UIKit

class SubGoalsVC: UIViewController {
    weak var collectionView: UICollectionView!
    
    var goalName: String!
    var goal: Goal?
    
    static var subGoals = [SubGoal]()
    var currentGoalIndex: Int!
    var currentIndex: Int!
    
    override func loadView() {
        super.loadView()
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
        cv.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
            self.collectionView!.collectionViewLayout.invalidateLayout()
            self.collectionView!.layoutSubviews()
            self.collectionView.showsVerticalScrollIndicator = false
            self.title = "Sub-Goals"
            if SubGoalsVC.subGoals.count > 1 {
                SubGoalsVC.subGoals.sort(by: {$0.index < $1.index})
            }
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: Notification.Name("updateGoalUI"), object: nil)
        collectionView!.reloadData()
        collectionView.backgroundColor = UIColor(named: "mainBackgroundColor")
        //self.parent?.title = "Sub-Goals"
        navigationController?.navigationBar.prefersLargeTitles = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "MySubCell")
        if let allSubGoals = goal?.subGoals?.allObjects as? [SubGoal] {
            SubGoalsVC.subGoals = allSubGoals
        }
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture))
        collectionView.addGestureRecognizer(gesture)
    }
    
    @objc func updateUI() {
        collectionView.reloadData()
    }
    
    @objc func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
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
    
    @objc func refresh() {
        self.collectionView.reloadData()
    }
}

extension SubGoalsVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SubGoalsVC.subGoals.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MySubCell", for: indexPath) as! CollectionViewCell
        
        cell.clipsToBounds = true
        cell.textLabel.numberOfLines = 1
        cell.textLabel.font = .systemFont(ofSize: 30, weight: .semibold)
        cell.layer.cornerRadius = 20
        
        if indexPath.item < SubGoalsVC.subGoals.count{
            cell.layer.cornerRadius = 20
            cell.textLabel.backgroundColor = SubGoalsVC.subGoals[indexPath.row].cellColor
            cell.textLabel.textColor = .white
            cell.textLabel.numberOfLines = 2
            if SubGoalsVC.subGoals[indexPath.row].isGoalComplete {
                let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: SubGoalsVC.subGoals[indexPath.row].name ?? "Name not found")
                    attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                cell.textLabel.attributedText = attributeString
            } else {
                let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: SubGoalsVC.subGoals[indexPath.row].name ?? "Name not found")
                cell.textLabel.attributedText = attributeString
            }
        }
        
        if indexPath.item == SubGoalsVC.subGoals.count {
            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: "Create Sub-Goal")
            cell.textLabel.attributedText = attributeString
            cell.layer.cornerRadius = 45
            cell.textLabel.backgroundColor = .white
            cell.textLabel.textColor = .black
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item == SubGoalsVC.subGoals.count {
            let vc = CreateGoalVC(goalType: "sub",
                                  action: "create",
                                  goalTFText: "",
                                  dateTFText: "",
                                  currentNumTFText: "",
                                  finalNumTFText: "",
                                  buttonTitle: "Create Sub-Goal",
                                  isGainGoal: true)
                                
            vc.currentSubIndex = indexPath.row
            vc.currentGoalIndex = currentGoalIndex
            present(vc, animated: true)
        }
        
        if indexPath.item < SubGoalsVC.subGoals.count {
            let vc = ViewSubGoalVC()
            vc.goalName = SubGoalsVC.subGoals[indexPath.row].name
            vc.date = SubGoalsVC.subGoals[indexPath.row].date
            vc.currentNum = SubGoalsVC.subGoals[indexPath.row].startNum
            vc.endNum = SubGoalsVC.subGoals[indexPath.row].endNum
            vc.currentGoalIndex = indexPath.item
            vc.subgoalColor = SubGoalsVC.subGoals[indexPath.row].cellColor
            vc.isGainGoal = SubGoalsVC.subGoals[indexPath.row].isGainGoal
            vc.isComplete = SubGoalsVC.subGoals[indexPath.row].isGoalComplete
            
            //let navVC = UINavigationController(rootViewController: vc)
            vc.navigationItem.leftBarButtonItem = .init(
                image: UIImage(systemName: "arrow.backward"),
                style: .plain,
                target: self,
                action: #selector(goBack))
            
            vc.navigationItem.rightBarButtonItem = .init(
                image: UIImage(systemName: "pencil"),
                style: .plain,
                target: self,
                action: #selector(editGoal))
            vc.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(vc, animated: true)
        }
        currentIndex = indexPath.item
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
        //dismiss(animated: true)
    }
    
    @objc func editGoal() {
        var start = ""
        var end = ""
        
        if SubGoalsVC.subGoals[currentIndex].endNum != 0.0 {
            start = SubGoalsVC.subGoals[currentIndex].startNum.formatToString
            end = SubGoalsVC.subGoals[currentIndex].endNum.formatToString
        }
        
        let vc = CreateGoalVC(
            goalType: "sub",
            action: "edit",
            goalTFText: SubGoalsVC.subGoals[currentIndex].name ?? "",
            dateTFText: SubGoalsVC.subGoals[currentIndex].date ?? "",
            currentNumTFText: start,
            finalNumTFText: end,
            buttonTitle: "Edit Sub-Goal",
            isGainGoal: SubGoalsVC.subGoals[currentIndex].isGainGoal)
        vc.currentSubIndex = currentIndex
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        vc.navigationController?.navigationBar.prefersLargeTitles = true
        vc.navigationController?.navigationBar.topItem?.title = " Edit Sub-Goal"
        //vc.navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .close, target: self, action: #selector(closeView))
        
        DispatchQueue.main.async {
            self.getTopMostViewController()?.present(nav, animated: true, completion: nil)
        }
    }
    
    @objc func closeView() {
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

extension SubGoalsVC: UICollectionViewDelegateFlowLayout {
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
        let lastElement = SubGoalsVC.subGoals.count
        if indexPath.item == lastElement {
            return false
        } else { return true
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = SubGoalsVC.subGoals.remove(at: sourceIndexPath.row)
        SubGoalsVC.subGoals.insert(item, at: destinationIndexPath.row)
        
        for (index, element) in SubGoalsVC.subGoals.enumerated() {
            element.index = Int16(index)
        }
        
        DataManager.shared.save()
    }
    
    // This function makes it so the last cell can't be moved
    func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
        if proposedIndexPath.row == SubGoalsVC.subGoals.count {
            return IndexPath(row: proposedIndexPath.row - 1, section: proposedIndexPath.section)
        } else {
            return proposedIndexPath
        }
    }
}
