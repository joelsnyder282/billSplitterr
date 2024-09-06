//
//  PriceTableViewCell.swift
//  billSplitter
//
//  Created by joel on 7/23/24.
//

import UIKit

class ItemsTableViewCell: UITableViewCell {
    
    // MARK: Properties (views)
    private let nameLabel = UILabel()
    let deleteButton = UIButton()
    private let priceLabel = UILabel()
    private let peopleLabel = UILabel()
    
    // MARK: Properties (data)
    static let reuse = "ItemsTableViewCellReuse"
    
    
    // MARK: init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.billSplitter.white
        
        setupNameLabel()
        setupDeleteButton()
        setupPriceLabel()
        setupPeopleLabel()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configure
    func configure(item: Item) {
        nameLabel.text = item.name
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.roundingMode = .halfEven
        
        let costString = formatter.string(from: NSNumber(value: item.cost))
        
        priceLabel.text = costString
        
        peopleLabel.text = ""
        var first = true
        for person in item.people {
            if !first {
                peopleLabel.text! += ", "
            }
            first = false
            peopleLabel.text! += person.name
        }
    
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
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    private func setupPeopleLabel() {
        peopleLabel.numberOfLines = 2
        peopleLabel.font = .systemFont(ofSize: 12, weight: .light)
        peopleLabel.textColor = UIColor.billSplitter.black
        
        contentView.addSubview(peopleLabel)
        peopleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            peopleLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 8),
            peopleLabel.trailingAnchor.constraint(equalTo: priceLabel.leadingAnchor, constant: -8),
            peopleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    
    private func setupPriceLabel() {
        priceLabel.numberOfLines = 1
        priceLabel.font = .systemFont(ofSize: 16, weight: .regular)
        priceLabel.textColor = UIColor.billSplitter.black
        
        contentView.addSubview(priceLabel)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            priceLabel.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -8),
            priceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    private func setupDeleteButton() {
        deleteButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        deleteButton.tintColor = UIColor.billSplitter.black
        
        contentView.addSubview(deleteButton)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 24),
            deleteButton.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
}
