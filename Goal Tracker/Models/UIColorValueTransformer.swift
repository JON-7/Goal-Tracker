//
//  UIColorValueTransformer.swift
//  Goal Tracker
//
//  Created by Jon E on 2/24/21.
//

import Foundation
import UIKit.UIColor

@objc(UIColorValueTransformer)
final class UIColorValueTransformer: NSSecureUnarchiveFromDataTransformer {
    static let name = NSValueTransformerName(rawValue: String(describing: UIColorValueTransformer.self))
    override static var allowedTopLevelClasses: [AnyClass] {
        return [UIColor.self]
    }
    
    public static func register() {
        let transformer = UIColorValueTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
