//
//  ViewController.swift
//  billSplitter
//
//  Created by joel on 7/23/24.
//

import UIKit

// Represents the starting menu where you can add people who dined.
class MainMenuVC: UIViewController {
    
    // MARK: Properties (views)
    
    private let addPersonButton = UIButton()
    private let addPersonPopupView = UIView()
    private let addPersonBackgroundView = UIView()
    private let nameField = UITextField()
    
    
    private let nextButton = UIButton()
    private let tableView = UITableView()
    
    
    // MARK: Properties (data)
    private let bill: Bill
    
    // MARK: init
    init() {
        self.bill = Bill()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    // MARK: viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Add People"

        view.backgroundColor = UIColor.white
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.billSplitter.ruby
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.billSplitter.offWhite]
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.scrollEdgeAppearance = appearance
        
        setupAddPersonButton()
        setupNextButton()
        setupTableView()
    }
    
    // MARK: Set up views
    
    private func setupAddPersonButton() {
        addPersonButton.setTitle("Add Person", for: .normal)
        addPersonButton.tintColor = UIColor.billSplitter.offWhite
        addPersonButton.backgroundColor = UIColor.billSplitter.emerald
        
        addPersonButton.layer.cornerRadius = 16
        
        view.addSubview(addPersonButton)
        addPersonButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addPersonButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            addPersonButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 48),
            addPersonButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -48),
            addPersonButton.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        addPersonButton.addTarget(self, action: #selector(addPersonButtonPressed), for: .touchUpInside)
    }
    
    @objc private func addPersonButtonPressed() {
        showAddPersonViews()
    }
    
    private func showAddPersonViews() {
        
        
        
        // Gray out background
        addPersonBackgroundView.backgroundColor = UIColor.billSplitter.grayOut
        
        self.navigationController?.view.addSubview(addPersonBackgroundView)

        
        addPersonBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addPersonBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            addPersonBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            addPersonBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addPersonBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // Set up the popup view
        
        addPersonPopupView.backgroundColor = UIColor.billSplitter.offWhite
        addPersonPopupView.layer.cornerRadius = 8
        
        self.navigationController?.view.addSubview(addPersonPopupView)
        
        addPersonPopupView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addPersonPopupView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            addPersonPopupView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 48),
            addPersonPopupView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -48),
            addPersonPopupView.heightAnchor.constraint(equalToConstant: 192)
        ])
        
        // Set up the close button
        
        let closeButton = UIButton()
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.backgroundColor = UIColor.billSplitter.offWhite
        closeButton.tintColor = UIColor.billSplitter.black
        
        addPersonPopupView.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: addPersonPopupView.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: addPersonPopupView.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 24),
            closeButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        closeButton.addTarget(self, action: #selector(closePopup), for: .touchUpInside)
        
        // Set up a label
        let label = UILabel()
        label.text = "Add Person"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor.billSplitter.black
        
        addPersonPopupView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: addPersonPopupView.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: closeButton.topAnchor, constant: 12)
        ])
        
        // Set up the name chooser
        
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
        
        
        addPersonPopupView.addSubview(nameField)
        nameField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameField.centerYAnchor.constraint(equalTo: addPersonPopupView.centerYAnchor),
            nameField.centerXAnchor.constraint(equalTo: addPersonPopupView.centerXAnchor),
            nameField.leadingAnchor.constraint(equalTo: addPersonPopupView.leadingAnchor, constant: 16),
            nameField.trailingAnchor.constraint(equalTo: addPersonPopupView.trailingAnchor, constant: -16),
            nameField.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        nameField.delegate = self
        
        // Set up save button
        
        let saveButton = UIButton()
        saveButton.setTitle("Save", for: .normal)
        saveButton.tintColor = UIColor.billSplitter.offWhite
        saveButton.backgroundColor = UIColor.billSplitter.emerald
        
        saveButton.layer.cornerRadius = 4
        
        addPersonPopupView.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            saveButton.bottomAnchor.constraint(equalTo: addPersonPopupView.bottomAnchor, constant: -16),
            saveButton.trailingAnchor.constraint(equalTo: addPersonPopupView.trailingAnchor, constant: -16),
            saveButton.widthAnchor.constraint(equalToConstant: 64),
            saveButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        saveButton.addTarget(self, action: #selector(saveNameField), for: .touchUpInside)
    
    }
    
    @objc private func closePopup() {
        addPersonPopupView.removeFromSuperview()
        addPersonBackgroundView.removeFromSuperview()
        nameField.text = ""
        nameField.removeFromSuperview()
    }
    
    @objc private func saveNameField() {
        if let name = nameField.text{
            if name != "" {
                let person = Person(name)
                
                if !bill.people.contains(person) {
                    bill.addPerson(named: name)
                }
            }
        }
        closePopup()
        tableView.reloadData()
    }
    
    

    private func setupNextButton() {
        nextButton.setTitle("Add Items", for: .normal)
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
        guard bill.people != [] else { return }
        let itemAdderVC = ItemAdderVC(bill: bill)
        
        navigationController?.pushViewController(itemAdderVC, animated: true)
    }
    
    private func setupTableView() {
        
        tableView.register(PersonTableViewCell.self, forCellReuseIdentifier: PersonTableViewCell.reuse)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        tableView.backgroundColor = UIColor.billSplitter.white
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: addPersonButton.bottomAnchor, constant: 8),
            tableView.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -8),
            tableView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
    }
}

extension MainMenuVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
}

extension MainMenuVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bill.people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: PersonTableViewCell.reuse, for: indexPath) as? PersonTableViewCell {
            cell.configure(person: bill.people[indexPath.row])
            cell.deleteButton.tag = indexPath.row
            cell.deleteButton.addTarget(self, action: #selector(deleteButtonTapped(_ :)), for: .touchUpInside)
            return cell
        }
        return UITableViewCell()
    }
    
    @objc private func deleteButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        let indexPath = IndexPath(row: index, section: 0)
        
        let person = bill.people[index]
        bill.removePerson(named: person.name)
        
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
        
        for (newIndex, cell) in tableView.visibleCells.enumerated() {
            if let button = (cell as? PersonTableViewCell)?.deleteButton {
                button.tag = newIndex
            }
        }
    }
}

extension MainMenuVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
