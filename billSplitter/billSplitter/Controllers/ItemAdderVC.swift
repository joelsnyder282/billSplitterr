//
//  ItemAdderVC.swift
//  billSplitter
//
//  Created by joel on 7/23/24.
//

import UIKit

// Represents the second menu where you add items for the people who dined.
class ItemAdderVC: UIViewController {
    
    // MARK: Properties (views)
    
    private let addItemButton = UIButton()
    private let addItemPopupView = UIView()
    private let addItemBackgroundView = UIView()
    private let nameField = UITextField()
    private let closeButton = UIButton()
    private let priceField = UITextField()
    private let splitCheckbox = UISwitch()
    private let tableView = UITableView()
    private let saveButton = UIButton()
    
    private let itemsTableView = UITableView()
    
    private let nextButton = UIButton()
    
    // MARK: Properties (data)
    
    private let bill: Bill
    private var selected: [Bool] = []
    
    // MARK: init
    
    init(bill: Bill) {
        self.bill = bill
        for _ in 0...bill.people.count - 1 {
            selected.append(false)
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: view did load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Items"
        
        view.backgroundColor = UIColor.white
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.billSplitter.ruby
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.billSplitter.offWhite]
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.scrollEdgeAppearance = appearance
        
        
        setupAddItemButton()
        setupNextButton()
        setupItemsTableView()
    }
    
    // MARK: Set up views
    
    private func setupAddItemButton() {
        addItemButton.setTitle("Add Item", for: .normal)
        addItemButton.tintColor = UIColor.billSplitter.offWhite
        addItemButton.backgroundColor = UIColor.billSplitter.emerald
        
        addItemButton.layer.cornerRadius = 16
        
        view.addSubview(addItemButton)
        addItemButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addItemButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            addItemButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 48),
            addItemButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -48),
            addItemButton.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        addItemButton.addTarget(self, action: #selector(addItemButtonPressed), for: .touchUpInside)
    }
    
    @objc private func addItemButtonPressed() {
        showAddItemPopup()
    }
    
    private func setupItemsTableView() {
        
        itemsTableView.register(ItemsTableViewCell.self, forCellReuseIdentifier: ItemsTableViewCell.reuse)
        
        itemsTableView.dataSource = self
        itemsTableView.delegate = self
        
        itemsTableView.separatorInset = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        itemsTableView.backgroundColor = UIColor.billSplitter.white
        
        view.addSubview(itemsTableView)
        itemsTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            itemsTableView.topAnchor.constraint(equalTo: addItemButton.bottomAnchor, constant: 8),
            itemsTableView.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -8),
            itemsTableView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            itemsTableView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
    }
    
    private func setupNextButton() {
        nextButton.setTitle("Finalize Fees", for: .normal)
        nextButton.tintColor = UIColor.billSplitter.offWhite
        nextButton.backgroundColor = UIColor.billSplitter.ruby
        
        nextButton.layer.cornerRadius = 16
        
        view.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            nextButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 48),
            nextButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -48),
            nextButton.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
    }
    
    @objc private func nextButtonPressed() {
        let feesAndFinalVC = FeesAndFinalVC(bill: bill)
        navigationController?.pushViewController(feesAndFinalVC, animated: true)
    }
    
    // MARK: Add Item Popup
    
    private func showAddItemPopup() {
        showBackgroundview()
        showPopupView()
        setupPopupCloseButton()
        setupPopupLabel()
        setupNameField()
        setupPriceField()
        setupSplitPrice()
        setupSaveButton()
        setupPeopleTableView()
        
    }
    
    private func showBackgroundview() {
        addItemBackgroundView.backgroundColor = UIColor.billSplitter.grayOut
        
        self.navigationController?.view.addSubview(addItemBackgroundView)
        addItemBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addItemBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            addItemBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            addItemBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addItemBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func showPopupView() {
        addItemPopupView.backgroundColor = UIColor.billSplitter.offWhite
        addItemPopupView.layer.cornerRadius = 8
        
        self.navigationController?.view.addSubview(addItemPopupView)
        addItemPopupView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addItemPopupView.topAnchor.constraint(equalTo: addItemButton.bottomAnchor, constant: 16),
            addItemPopupView.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -16),
            addItemPopupView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 48),
            addItemPopupView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -48)
        ])
    }
    
    private func setupPopupCloseButton() {
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.backgroundColor = UIColor.billSplitter.offWhite
        closeButton.tintColor = UIColor.billSplitter.black
        
        addItemPopupView.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: addItemPopupView.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: addItemPopupView.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 24),
            closeButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        closeButton.addTarget(self, action: #selector(closePopup), for: .touchUpInside)
    }
    
    @objc private func closePopup() {
        addItemPopupView.removeFromSuperview()
        addItemBackgroundView.removeFromSuperview()
        nameField.text = ""
        priceField.text = ""
    }
    
    private func setupPopupLabel() {
        let label = UILabel()
        label.text = "Add Item"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor.billSplitter.black
        
        addItemPopupView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: addItemPopupView.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: closeButton.topAnchor, constant: 12)
        ])
    }
    
    private func setupNameField() {
        nameField.layer.borderWidth = 1
        nameField.layer.cornerRadius = 4
        nameField.layer.borderColor = UIColor.billSplitter.black.cgColor
        nameField.backgroundColor = UIColor.billSplitter.white
        
        nameField.placeholder = "Name goes here"
        nameField.textColor = UIColor.billSplitter.black
        nameField.font = .systemFont(ofSize: 16, weight: .medium)
        
        nameField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: nameField.frame.height))
        nameField.leftViewMode = .always
        
        nameField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: nameField.frame.height))
        nameField.rightViewMode = .always
        
        nameField.delegate = self
        
        addItemPopupView.addSubview(nameField)
        nameField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameField.topAnchor.constraint(equalTo: addItemPopupView.topAnchor, constant: 56),
            nameField.leadingAnchor.constraint(equalTo: addItemPopupView.leadingAnchor, constant: 16),
            nameField.trailingAnchor.constraint(equalTo: addItemPopupView.trailingAnchor, constant: -16),
            nameField.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func setupPriceField() {
        
        priceField.text = "$00.00"
        priceField.keyboardType = .numbersAndPunctuation
        priceField.borderStyle = .none
        priceField.font = UIFont(name: "Menlo", size: 12)
        priceField.textColor = UIColor.billSplitter.black
        
        let underline = UIView()
        underline.backgroundColor = UIColor.billSplitter.black
        
        addItemPopupView.addSubview(priceField)
        addItemPopupView.addSubview(underline)
        priceField.translatesAutoresizingMaskIntoConstraints = false
        underline.translatesAutoresizingMaskIntoConstraints = false
        
        priceField.delegate = self
        
        NSLayoutConstraint.activate([
            priceField.centerXAnchor.constraint(equalTo: underline.centerXAnchor),
            priceField.widthAnchor.constraint(equalToConstant: 44),
            priceField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 8),
            
            underline.topAnchor.constraint(equalTo: priceField.bottomAnchor),
            underline.leadingAnchor.constraint(equalTo: nameField.leadingAnchor),
            underline.trailingAnchor.constraint(equalTo: priceField.trailingAnchor),
            underline.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        priceField.addTarget(self, action: #selector(priceFieldDidChange), for: .editingChanged)
    }
    
    @objc private func priceFieldDidChange(_ textField: UITextField) {
        if let amountString = textField.text?.currencyInputFormatting() {
            textField.text = amountString
        }
    }
    
    private func setupSplitPrice() {
        let splitLabel = UILabel()
        
        splitLabel.text = "Split Price"
        splitLabel.font = .systemFont(ofSize: 14, weight: .medium)
        splitLabel.textColor = UIColor.billSplitter.black
        
        splitCheckbox.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        addItemPopupView.addSubview(splitLabel)
        addItemPopupView.addSubview(splitCheckbox)
        splitLabel.translatesAutoresizingMaskIntoConstraints = false
        splitCheckbox.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            splitLabel.leadingAnchor.constraint(equalTo: priceField.trailingAnchor, constant: 16),
            splitLabel.centerYAnchor.constraint(equalTo: priceField.centerYAnchor),
            
            splitCheckbox.centerYAnchor.constraint(equalTo: splitLabel.centerYAnchor),
            splitCheckbox.leadingAnchor.constraint(equalTo: splitLabel.trailingAnchor, constant: 4)
        ])
    }
    
    private func setupPeopleTableView() {
        tableView.register(SelectPersonTableViewCell.self, forCellReuseIdentifier: SelectPersonTableViewCell.reuse)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        tableView.backgroundColor = UIColor.billSplitter.white
        
        tableView.backgroundColor = UIColor.billSplitter.offWhite

        addItemPopupView.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: splitCheckbox.bottomAnchor, constant: 8),
            tableView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -8),
            tableView.leadingAnchor.constraint(equalTo: addItemPopupView.leadingAnchor, constant: 8),
            tableView.trailingAnchor.constraint(equalTo: addItemPopupView.trailingAnchor, constant: -8)
        ])
    }
    
    private func setupSaveButton() {
        saveButton.setTitle("Save", for: .normal)
        saveButton.tintColor = UIColor.billSplitter.offWhite
        saveButton.backgroundColor = UIColor.billSplitter.emerald
        
        saveButton.layer.cornerRadius = 4
        
        addItemPopupView.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            saveButton.bottomAnchor.constraint(equalTo: addItemPopupView.bottomAnchor, constant: -16),
            saveButton.trailingAnchor.constraint(equalTo: addItemPopupView.trailingAnchor, constant: -16),
            saveButton.widthAnchor.constraint(equalToConstant: 64),
            saveButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        saveButton.addTarget(self, action: #selector(saveItem), for: .touchUpInside)
    }
        
    @objc private func saveItem() {
        guard let name = nameField.text else { return }
        guard let price = priceField.text?.suffix(5) else { return }
        guard let cost = Double(price) else { return}
        
        if name == "" {
            return
        }
        
        var people: [Person] = []
        
        for i in 0...bill.people.count - 1 {
            if selected[i] {
                people.append(bill.people[i])
            }
        }
        
        let split = splitCheckbox.isOn ? true : false
        
        guard people != [] else {
            return
        }
        
        bill.addItem(name: name, cost: cost, people: people, split: split)
        
        for x in 0...bill.people.count - 1 {
            selected[x] = false
        }
        
        bill.calculatePrices()
        
        closePopup()
        itemsTableView.reloadData()
        tableView.reloadData()
    }
}

// MARK: String extension

extension String {

    func currencyInputFormatting() -> String {
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.maximumIntegerDigits = 2
        formatter.minimumIntegerDigits = 2
    
        var amountWithPrefix = self

        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
    
        var double = (amountWithPrefix as NSString).doubleValue
        
        if double >= 10000 {
            double = floor(double / 10)
        }
        
        number = NSNumber(value: (double / 100))
    
        guard number != 0 as NSNumber else {
            return "$00.00"
        }
        
        return formatter.string(from: number)!
    }
}

extension ItemAdderVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == itemsTableView {
            return 48
        }
        else {
            return 24
        }
    }
    
}

extension ItemAdderVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == itemsTableView {
            return bill.items.count
        }
        else {
            return bill.people.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == itemsTableView {
            if let cell = tableView.dequeueReusableCell(withIdentifier: ItemsTableViewCell.reuse, for: indexPath) as? ItemsTableViewCell {
                
                cell.configure(item: bill.items[indexPath.row])
                
                cell.deleteButton.tag = indexPath.row
                cell.deleteButton.addTarget(self, action: #selector(deleteButtonTapped(_ :)), for: .touchUpInside)
                
                return cell
            }
        }
        else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: SelectPersonTableViewCell.reuse, for: indexPath) as? SelectPersonTableViewCell {
                
                cell.configure(person: bill.people[indexPath.row])
                cell.selectSwitch.setOn(false, animated: false)
                cell.selectSwitch.tag = indexPath.row
                cell.selectSwitch.addTarget(self, action: #selector(switchTouched(_ :)), for: .touchUpInside)
                return cell
            }
        }
        return UITableViewCell()
    }
    
    @objc private func deleteButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        let indexPath = IndexPath(row: index, section: 0)
        
        if bill.items == [] {
            return
        }
        
        let item = bill.items[index]
        bill.removeItem(item)
        
        itemsTableView.beginUpdates()
        itemsTableView.deleteRows(at: [indexPath], with: .automatic)
        itemsTableView.endUpdates()
        
        for (newIndex, cell) in itemsTableView.visibleCells.enumerated() {
            if let button = (cell as? PersonTableViewCell)?.deleteButton {
                button.tag = newIndex
            }
        }
    }
    
    @objc private func switchTouched(_ sender: UISwitch) {
        let index = sender.tag
        selected[index] = sender.isOn
    }
}

extension ItemAdderVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
