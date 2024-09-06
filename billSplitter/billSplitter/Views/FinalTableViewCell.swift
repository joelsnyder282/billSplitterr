//
//  FinalTableViewCEll.swift
//  billSplitter
//
//  Created by joel on 7/24/24.
//

import UIKit

class FinalTableViewCell: UITableViewCell {
    
    // MARK: Properties (views)
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let itemsLabel = UILabel()
    
    // MARK: Properties (data)
    static let reuse = "FinalTableViewCellReuse"
    
    
    // MARK: init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.billSplitter.white
        
        setupNameLabel()
        setupPriceLabel()
        setupItemsLabel()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configure
    func configure(person: Person) {
        nameLabel.text = person.name
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.roundingMode = .halfEven
        
        
        let costString = formatter.string(from: NSNumber(value: person.priceWithFees))
        
        priceLabel.text = costString
        
        itemsLabel.text = ""
        var first = true
        for item in person.items {
            if !first {
                itemsLabel.text! += ", "
            }
            first = false
            itemsLabel.text! += item.name
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
    
    private func setupItemsLabel() {
        itemsLabel.numberOfLines = 2
        itemsLabel.font = .systemFont(ofSize: 12, weight: .light)
        itemsLabel.textColor = UIColor.billSplitter.black
        
        contentView.addSubview(itemsLabel)
        itemsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            itemsLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 8),
            itemsLabel.trailingAnchor.constraint(equalTo: priceLabel.leadingAnchor, constant: -8),
            itemsLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    
    private func setupPriceLabel() {
        priceLabel.numberOfLines = 1
        priceLabel.font = .systemFont(ofSize: 16, weight: .regular)
        priceLabel.textColor = UIColor.billSplitter.black
        
        contentView.addSubview(priceLabel)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            priceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}
