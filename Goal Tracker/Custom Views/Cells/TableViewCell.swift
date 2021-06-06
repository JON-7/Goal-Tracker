//
//  TableViewCell.swift
//  Goal Tracker
//
//  Created by Jon E on 6/5/21.
//

import UIKit

class TableViewCell: UITableViewCell {

    static let reuseID = "tableViewCell"
    
    var titleLabel = UILabel()
    var dateLabel = UILabel()
    var notePreview = UILabel()
    let heightConstant = UIScreen.main.bounds.height * (0.1/3)
    let topPadding = UIScreen.main.bounds.height * 0.007

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        configureTitleLabel()
        configureDateLabel()
        configurePreviewLabel()
        selectionStyle = .none
        backgroundColor = Colors.mainBackgroundColor
    }

    private func configureTitleLabel() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.font = UIFont.systemFont(ofSize: heightConstant, weight: .semibold)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: topPadding),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            titleLabel.heightAnchor.constraint(equalToConstant: heightConstant)
        ])
    }
    
    private func configureDateLabel() {
        addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont.systemFont(ofSize: heightConstant * 0.75)
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: topPadding),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            dateLabel.heightAnchor.constraint(equalToConstant: heightConstant),
        ])
    }
    
    private func configurePreviewLabel() {
        addSubview(notePreview)
        notePreview.translatesAutoresizingMaskIntoConstraints = false
        notePreview.numberOfLines = 0
        notePreview.font = UIFont.systemFont(ofSize: heightConstant * 0.75)
        
        NSLayoutConstraint.activate([
            notePreview.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: topPadding),
            notePreview.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            notePreview.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: -35),
            notePreview.heightAnchor.constraint(equalToConstant: heightConstant),
        ])
    }
    
    func set(noteIndex: Int) {
        self.titleLabel.text = DataManager.shared.notes[noteIndex].title
        self.dateLabel.text = DataManager.shared.notes[noteIndex].lastEdited
        self.notePreview.text = DataManager.shared.notes[noteIndex].noteText
    }
}
