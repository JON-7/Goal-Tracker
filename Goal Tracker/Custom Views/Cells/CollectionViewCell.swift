//
//  CollectionViewCell.swift
//  Goal Tracker
//
//  Created by Jon E on 6/5/21.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    static let reuseID = "CollectionCell"
    var textLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createDefaultCell() {
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textLabel)
        clipsToBounds = true
        layer.cornerRadius = 20
        
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 0
        textLabel.font = .systemFont(ofSize: 30, weight: .semibold)
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    func createMainCell(cellTitle: String, cellColor: UIColor, isComplete: Bool) {
        createDefaultCell()
        textLabel.backgroundColor = cellColor
        textLabel.textColor = .white
        
        
        DispatchQueue.main.async { [self] in
            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: cellTitle)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            
            if isComplete {
                textLabel.attributedText = attributeString
            } else {
                attributeString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0, attributeString.length))
                textLabel.attributedText = attributeString
            }
        }
    }
    
    func createGoalCell() {
        createDefaultCell()
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: "Create Goal")
        textLabel.attributedText = attributeString
        layer.cornerRadius = bounds.height / 2
        textLabel.backgroundColor = Colors.goalActionBtnColor
        textLabel.textColor = .black
    }
}
