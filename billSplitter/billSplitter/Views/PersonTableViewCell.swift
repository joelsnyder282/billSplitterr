//
//  PersonTableViewCell.swift
//  billSplitter
//
//  Created by joel on 7/23/24.
//

import UIKit

class PersonTableViewCell: UITableViewCell {
    
    // MARK: Properties (views)
    private let nameLabel = UILabel()
    let deleteButton = UIButton()
    
    // MARK: Properties (data)
    static let reuse = "PersonTableViewCellReuse"
    
    
    // MARK: init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.billSplitter.white
        
        setupDeleteButton()
        setupNameLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configure
    func configure(person: Person) {
        nameLabel.text = person.name
    }
    
    // MARK: Set up views
    
    private func setupNameLabel() {
        nameLabel.numberOfLines = 1
        nameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        nameLabel.textColor = UIColor.billSplitter.black
        
        contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    private func setupDeleteButton() {
        deleteButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        deleteButton.tintColor = UIColor.billSplitter.black
        
        contentView.addSubview(deleteButton)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            deleteButton.widthAnchor.constraint(equalToConstant: 24),
            deleteButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
}
