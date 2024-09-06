//
//  FeesAndFinalVC.swift
//  billSplitter
//
//  Created by joel on 7/24/24.
//

import UIKit

// Represents the final menu where you finalize taxes and other fees.
class FeesAndFinalVC: UIViewController {
    
    // MARK: Properties (view)
    private let taxAndTipView = UIView()
    
    private let taxInput = UITextField()
    
    private let tipInput = UITextField()
    
    private let onTopSwitch = UISwitch()
    private let onTopLabel = UILabel()
    
    private let totalTextLabel = UILabel()
    private let totalPriceLabel = UILabel()
    
    private let tableView = UITableView()
    
    private let restartButton = UIButton()
    
    // MARK: Properties (data)
    private let bill: Bill
    private let formatter: NumberFormatter
    private var taxPercent: Double
    private var tipPercent: Double
    private var onTop: Bool = false
    
    // MARK: init
    
    init(bill: Bill) {
        self.bill = bill
        
        formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.roundingMode = .halfEven
        
        taxPercent = 0
        tipPercent = 0
        
        super.init(nibName: nil, bundle: nil)
        
        recalculatePrices()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Finalize Fees"
        view.backgroundColor = UIColor.white    
    
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.billSplitter.ruby
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.billSplitter.offWhite]
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.scrollEdgeAppearance = appearance
        
        
        setupTaxAndTipView()
        setupTotalLabels()
        setupRestartButton()
        setupTableView()
    }
    
    // MARK: set up views
    
    private func setupTaxAndTipView() {
        taxAndTipView.backgroundColor = UIColor.billSplitter.offWhite
        taxAndTipView.layer.cornerRadius = 16
        
        view.addSubview(taxAndTipView)
        taxAndTipView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            taxAndTipView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            taxAndTipView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 8),
            taxAndTipView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -8),
            taxAndTipView.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        setupTaxField()
        setupTipField()
        setupOnTopOption()
    }
    
    private func setupTaxField() {
        let label = UILabel()
        label.text = "Tax:"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor.billSplitter.black
        
        taxAndTipView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        taxInput.text = "00.000"
        taxInput.keyboardType = .numbersAndPunctuation
        taxInput.borderStyle = .none
        taxInput.font = UIFont(name: "Menlo", size: 12)
        taxInput.textColor = UIColor.billSplitter.black
        
        taxInput.delegate = self
        
        let underline = UIView()
        underline.backgroundColor = UIColor.billSplitter.black
        
        taxAndTipView.addSubview(taxInput)
        taxAndTipView.addSubview(underline)
        taxInput.translatesAutoresizingMaskIntoConstraints = false
        underline.translatesAutoresizingMaskIntoConstraints = false
        
        let percentageLabel = UILabel()
        percentageLabel.text = "%"
        percentageLabel.font = UIFont(name: "Menlo", size: 12)
        percentageLabel.textColor = UIColor.billSplitter.black
        
        taxAndTipView.addSubview(percentageLabel)
        percentageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: taxAndTipView.leadingAnchor, constant: 8),
            label.centerYAnchor.constraint(equalTo: taxAndTipView.centerYAnchor),
            
            underline.topAnchor.constraint(equalTo: taxInput.bottomAnchor),
            underline.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 8),
            underline.widthAnchor.constraint(equalToConstant: 43),
            underline.heightAnchor.constraint(equalToConstant: 1),
            
            taxInput.trailingAnchor.constraint(equalTo: underline.trailingAnchor),
            taxInput.centerYAnchor.constraint(equalTo: taxAndTipView.centerYAnchor),
            
            percentageLabel.centerYAnchor.constraint(equalTo: taxAndTipView.centerYAnchor),
            percentageLabel.leadingAnchor.constraint(equalTo: underline.trailingAnchor, constant: 1)
        ])
        
        taxInput.addTarget(self, action: #selector(inputDidChange), for: .editingChanged)
    }
    
    private func setupTipField() {
        let label = UILabel()
        label.text = "Tip:"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor.billSplitter.black
        
        taxAndTipView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        tipInput.text = "00.000"
        tipInput.keyboardType = .numbersAndPunctuation
        tipInput.borderStyle = .none
        tipInput.font = UIFont(name: "Menlo", size: 12)
        tipInput.textColor = UIColor.billSplitter.black
        
        tipInput.delegate = self
        
        let underline = UIView()
        underline.backgroundColor = UIColor.billSplitter.black
        
        taxAndTipView.addSubview(tipInput)
        taxAndTipView.addSubview(underline)
        tipInput.translatesAutoresizingMaskIntoConstraints = false
        underline.translatesAutoresizingMaskIntoConstraints = false
        
        let percentageLabel = UILabel()
        percentageLabel.text = "%"
        percentageLabel.font = UIFont(name: "Menlo", size: 12)
        percentageLabel.textColor = UIColor.billSplitter.black
        
        taxAndTipView.addSubview(percentageLabel)
        percentageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: taxInput.trailingAnchor, constant: 24),
            label.centerYAnchor.constraint(equalTo: taxAndTipView.centerYAnchor),
            
            underline.topAnchor.constraint(equalTo: tipInput.bottomAnchor),
            underline.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 8),
            underline.widthAnchor.constraint(equalToConstant: 43),
            underline.heightAnchor.constraint(equalToConstant: 1),
            
            tipInput.trailingAnchor.constraint(equalTo: underline.trailingAnchor),
            tipInput.centerYAnchor.constraint(equalTo: taxAndTipView.centerYAnchor),
            
            percentageLabel.centerYAnchor.constraint(equalTo: taxAndTipView.centerYAnchor),
            percentageLabel.leadingAnchor.constraint(equalTo: underline.trailingAnchor, constant: 1)
        ])
        
        tipInput.addTarget(self, action: #selector(inputDidChange), for: .editingChanged)
    }
    
    @objc private func inputDidChange(_ textField: UITextField) {
        
        guard let newString = textField.text?.percentFormatting() else {return}
        textField.text = newString
        
        if textField == tipInput {
            tipPercent = Double(newString) ?? 0
        }
        if textField == taxInput {
            taxPercent = Double(newString) ?? 0
        }
        
        recalculatePrices()
    }

    private func recalculatePrices() {
        
        bill.calculatePrices()
        bill.calculateFees(percentOne: tipPercent, percentTwo: taxPercent, onTop: onTop)
        
        let price = bill.totalPriceWithFees()
        
        totalPriceLabel.text = "$" + (formatter.string(from: NSNumber(value: price)) ?? "0.00")
        
        
        tableView.reloadData()
    }
    
    private func setupOnTopOption() {
        onTopLabel.text = "Tip on Tax?"
        onTopLabel.font = .systemFont(ofSize: 12, weight: .medium)
        onTopLabel.textColor = UIColor.billSplitter.black
        
        onTopSwitch.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        taxAndTipView.addSubview(onTopLabel)
        taxAndTipView.addSubview(onTopSwitch)
        onTopLabel.translatesAutoresizingMaskIntoConstraints = false
        onTopSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            onTopSwitch.trailingAnchor.constraint(equalTo: taxAndTipView.trailingAnchor, constant: -4),
            onTopSwitch.centerYAnchor.constraint(equalTo: taxAndTipView.centerYAnchor),
            
            onTopLabel.centerYAnchor.constraint(equalTo: taxAndTipView.centerYAnchor),
            onTopLabel.trailingAnchor.constraint(equalTo: onTopSwitch.leadingAnchor, constant: -8)
        ])
        
        onTopSwitch.addTarget(self, action: #selector(onTopSwitchPressed), for: .touchUpInside)
    }
    
    @objc private func onTopSwitchPressed() {
        onTop = onTopSwitch.isOn
        recalculatePrices()
    }
    
    private func setupTotalLabels() {
        totalTextLabel.text = "TOTAL:"
        totalTextLabel.font = .systemFont(ofSize: 24, weight: .bold)
        totalTextLabel.textColor = UIColor.billSplitter.black
    
        totalPriceLabel.font = .systemFont(ofSize: 24, weight: .bold)
        totalPriceLabel.textColor = UIColor.billSplitter.black
        
        let underline = UIView()
        underline.backgroundColor = UIColor.billSplitter.silver
        
        view.addSubview(totalTextLabel)
        view.addSubview(totalPriceLabel)
        view.addSubview(underline)
        totalTextLabel.translatesAutoresizingMaskIntoConstraints = false
        totalPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        underline.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            totalTextLabel.topAnchor.constraint(equalTo: taxAndTipView.bottomAnchor, constant: 8),
            totalTextLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 8),
            
            totalPriceLabel.topAnchor.constraint(equalTo: taxAndTipView.bottomAnchor, constant: 8),
            totalPriceLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -8),
            
            underline.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            underline.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            underline.topAnchor.constraint(equalTo: totalTextLabel.bottomAnchor, constant: 3),
            underline.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    private func setupTableView() {
        tableView.register(FinalTableViewCell.self, forCellReuseIdentifier: FinalTableViewCell.reuse)

        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        tableView.backgroundColor = UIColor.billSplitter.white
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: totalTextLabel.bottomAnchor, constant: 8),
            tableView.bottomAnchor.constraint(equalTo: restartButton.topAnchor, constant: -8),
            tableView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
    }
    
    private func setupRestartButton() {
        restartButton.setTitle("Restart", for: .normal)
        restartButton.tintColor = UIColor.billSplitter.offWhite
        restartButton.backgroundColor = UIColor.billSplitter.ruby
        
        restartButton.layer.cornerRadius = 16
        
        view.addSubview(restartButton)
        restartButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            restartButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            restartButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 48),
            restartButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -48),
            restartButton.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        restartButton.addTarget(self, action: #selector(restartButtonPressed), for: .touchUpInside)
    }
    
    @objc private func restartButtonPressed() {
        let mainMenuVC = MainMenuVC()
        navigationController?.setViewControllers([mainMenuVC], animated: true)
    }
    
    
}

// MARK: String extension

extension String {

    func percentFormatting() -> String {
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = ""
        formatter.maximumFractionDigits = 3
        formatter.minimumFractionDigits = 3
        formatter.maximumIntegerDigits = 2
        formatter.minimumIntegerDigits = 2
    
        var amountWithPrefix = self
    
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
    
        var double = (amountWithPrefix as NSString).doubleValue
        
        if double >= 100000 {
            double = floor(double / 10)
        }
        
        number = NSNumber(value: (double / 1000))
    
        guard number != 0 as NSNumber else {
            return "00.000"
        }
        
        return formatter.string(from: number)!
    }
}


// MARK: TableVieW Delegate and datasource

extension FeesAndFinalVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
}

extension FeesAndFinalVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bill.people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: FinalTableViewCell.reuse, for: indexPath) as? FinalTableViewCell {
            cell.configure(person: bill.people[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}

extension FeesAndFinalVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
