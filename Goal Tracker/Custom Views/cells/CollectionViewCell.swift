//
//  MyCell.swift
//  LayoutFlowDemo
//
//  Created by Jon E on 2/14/21.
//


import UIKit

class CollectionViewCell: UICollectionViewCell {
    weak var textLabel: UILabel!
    weak var image: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        textLabel = label
        textLabel.textAlignment = .center
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


