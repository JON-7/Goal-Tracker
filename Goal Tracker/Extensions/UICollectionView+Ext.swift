//
//  UICollectionView+Ext.swift
//  Goal Tracker
//
//  Created by Jon E on 6/5/21.
//

import UIKit

extension UICollectionView {
    func configureLongPress() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture))
        self.addGestureRecognizer(gesture)
        self.showsVerticalScrollIndicator = false
    }
    
    @objc func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            guard let targetIndex = self.indexPathForItem(at: gesture.location(in: self)) else {
                return
            }
            self.beginInteractiveMovementForItem(at: targetIndex)
        case .changed:
            self.updateInteractiveMovementTargetPosition(gesture.location(in: self))
        case .ended:
            self.endInteractiveMovement()
        default:
            self.cancelInteractiveMovement()
        }
    }
}
