//
//  TableViewCell.swift
//  Goal Tracker
//
//  Created by Jon E on 2/16/21.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    var titleLabel = UILabel()
    var dateLabel = UILabel()
    var notePreview = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(titleLabel)
        addSubview(dateLabel)
        addSubview(notePreview)
        configureTitleLabel()
        configureDateLabel()
        configurePreviewLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureTitleLabel() {
        titleLabel.numberOfLines = 0
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .boldSystemFont(ofSize: 20)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            titleLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func configureDateLabel() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            dateLabel.widthAnchor.constraint(equalToConstant: 100),
            dateLabel.heightAnchor.constraint(equalToConstant: 15),
        ])
    }
    
    func configurePreviewLabel() {
        notePreview.numberOfLines = 0
        notePreview.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            notePreview.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            notePreview.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            notePreview.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: -35),
            notePreview.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
}
