//
//  SelectPersonTableViewCell.swift
//  billSplitter
//
//  Created by joel on 7/23/24.
//

import UIKit

class SelectPersonTableViewCell: UITableViewCell {
    
    // MARK: Properties (views)
    private let nameLabel = UILabel()
    let selectSwitch = UISwitch()
    
    // MARK: Properties (data)
    static let reuse = "SelectPersonTableViewCellReuse"
    var switched = false
    
    // MARK: init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.billSplitter.offWhite
        
        setupSelectSwitch()
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
            nameLabel.trailingAnchor.constraint(equalTo: selectSwitch.leadingAnchor, constant: -8),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    private func setupSelectSwitch() {
        selectSwitch.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        contentView.addSubview(selectSwitch)
        selectSwitch.setOn(false, animated: false)
        selectSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            selectSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 8),
            selectSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
