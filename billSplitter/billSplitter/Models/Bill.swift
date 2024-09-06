//
//  Bill.swift
//  billSplitter
//
//  Created by joel on 7/23/24.
//

import Foundation

// Represents a person and the items they bought.
class Person: Equatable {
    
    // MARK: Person Properties
    
    var name: String
    var items: [Item]
    var price: Double
    var priceWithFees: Double
    
    // MARK: Person Functions
    
    init(_ name: String) {
        self.name = name
        items = []
        price = 0
        priceWithFees = 0
    }
    
    func addItem(item: Item) {
        if !items.contains(item) {
            items.append(item)
        }
        else {
            var j = 0;
            for i in items {
                if i == item {
                   items[j] = item
                }
                j += 1;
            }
        }
    }
    
    func calculatePrice() {
        price = 0
        for item in items {
            price += item.costPer
        }
    }
    
    func calculateFees(factor: Double) {
        priceWithFees = price * factor
    }
    
    static func == (lhs: Person, rhs: Person) -> Bool {
        return lhs.name == rhs.name
    }
    
}

// Represents an item and the people that got it.
class Item: Equatable {
    
    // MARK: Item Properties
    
    var name: String
    var people: [Person]
    var cost: Double
    var costPer: Double
    var split: Bool
    
    // MARK: Item Functions
    
    init(_ name: String, cost: Double, people: [Person], split: Bool) {
        self.name = name
        self.cost = cost
        self.people = people
        self.split = split
        if split {
            self.costPer = cost / Double(people.count)
        }
        else {
            self.costPer = cost
        }
    }
    
    func removePerson(person: Person) {
        if people.contains(person) {
            guard let ind = people.firstIndex(of: person) else { return }
            people.remove(at: ind)
            
            if people.count != 0 && split {
                costPer = cost / Double(people.count)
            }
        }
    }
    
    static func == (lhs: Item, rhs: Item) -> Bool {
        
        var samePeople = true
        for person in lhs.people {
            if !rhs.people.contains(person) {
                samePeople = false
            }
        }
        if rhs.people.count != lhs.people.count {
            samePeople = false
        }
        
        return lhs.name == rhs.name && lhs.cost == rhs.cost && samePeople && lhs.split == rhs.split
    }
    
}

// Represents a complete bill of people and all the bought items.
class Bill {
    
    // MARK: Bill Properties
    var people: [Person]
    var items: [Item]
    
    // MARK: Bill Functions
    
    init() {
        people = []
        items = []
    }
    
    func addPerson(named: String) {
        people.append(Person(named))
    }
    
    func removePerson(named: String) {
        let person = Person(named)
        
        guard let ind = people.firstIndex(of: person) else { return }
        people.remove(at: ind)
        
        var i = 0;
        for item in items {
            item.removePerson(person: person)
            if item.people.count == 0 {
                items.remove(at: i)
            }
            i += 1
        }
        
    }
    
    func addItem(name: String, cost: Double, people: [Person], split: Bool) {
        if people == [] {
            return
        }
        
        let item = Item(name, cost: cost, people: people, split: split)
        
        if !items.contains(item) {
            items.append(item)
        }
        else {
            return
        }
        
        for person in people {
            person.addItem(item: item)
        }
    }
    
    func removeItem(_ item: Item) {
        if items.contains(item) {
            guard let index = items.firstIndex(of: item) else { return }
            items.remove(at: index)
        }
    }
    
    func calculatePrices() {
        for person in people {
            person.calculatePrice()
        }
    }
    
    func totalPriceWithFees() -> Double {
        var total: Double = 0.0
    
        for person in people {
            total += person.priceWithFees
        }
        
        return total
    }
    
    func calculateFees(percentOne: Double, percentTwo: Double, onTop: Bool) {
        let factorOne = 1 + ( percentOne / 100 )
        let factorTwo = 1 + ( percentTwo / 100 )
        
        var factor: Double = 0
        if onTop {
            factor = factorOne * factorTwo
        }
        else {
            factor = factorOne + factorTwo - 1
        }
        
        for person in people {
            person.calculateFees(factor: factor)
        }
    }
}
