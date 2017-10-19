//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

open class TestMe {
  open func Please() -> String {
    return "I have been tested"
  }
}

////////////////////////////////////
// Money
//
public struct Money : CustomStringConvertible, Mathematics {
    public mutating func plus(_ num: Int) {
        self.amount = self.amount + num;
    }
    
    public mutating func minus(_ num: Int) {
        self.amount = self.amount - num;
    }
    
    public var description: String {
        get {
            return "\(self.getType()) : \(amount)"
        }
    }
    
    public func equals(_ other : Money) -> Bool {
        return self.amount == other.amount && self.currency == other.currency;
    }
    
    private func getType() -> String {
        var type : String
        switch self.currency {
        case .GBP:
            type = "GBP"
        case .USD:
            type = "USD";
        case .EUR:
            type = "EUR";
        case .CAN:
            type = "CAN";
        case .YEN:
            type = "YEN";
        }
        return type;
    }
  public var amount : Int
  public var currency : CurrencyType
    
    public enum CurrencyType : CustomStringConvertible{
        public var description: String {
            get {
                var type : String
                switch self {
                case .GBP:
                    type = "GBP"
                case .USD:
                    type = "USD";
                case .EUR:
                    type = "EUR";
                case .CAN:
                    type = "CAN";
                case .YEN:
                    type = "YEN";
                }
                return "The currency type is \(type)"
            }
        }
        case GBP
        case USD
        case EUR
        case CAN
        case YEN
    }
  
  public func convert(_ to: CurrencyType) -> Money {

    return Money(amount: Int((Double(amount) / Money.getCurrency(currency)) * Money.getCurrency(to)), currency: to);

  }
    
  private static func getCurrency(_ to: CurrencyType) -> Double {
      switch to {
      case .GBP:
          return 0.5;
      case .USD:
          return 1.0;
      case .EUR:
          return 1.5;
      case .CAN:
          return 1.25;
      case .YEN:
          return 122.0;
        
      }
  }
  
  public func add(_ to: Money) -> Money {
    return Money(amount: Int((Double(self.amount) / Money.getCurrency(self.currency)) * Money.getCurrency(to.currency)) + to.amount, currency: to.currency);
  }
  public func subtract(_ from: Money) -> Money {
    return Money(amount: Int((Double(self.amount) / Money.getCurrency(self.currency)) * Money.getCurrency(from.currency)) - from.amount, currency: from.currency);
  }
}

////////////////////////////////////
// Job
//
open class Job : CustomStringConvertible {
    public var description: String {
        get {
            return "\(title) is a \(type.description)"
        }
    }
    
  fileprivate var title : String
  fileprivate var type : JobType

    public enum JobType : CustomStringConvertible {
    case Hourly(Double)
    case Salary(Int)
    
    public var description : String {
        get {
            switch self{
            case .Hourly(let rate):
                return "hourly job with a pay rate of \(rate)"
            case .Salary(let rate):
                return "salary job with a pay rate of \(rate)"
            }
        }
    }
  }
  
  public init(title : String, type : JobType) {
    self.title = title
    self.type = type
  }
  
  open func calculateIncome(_ hours: Int) -> Int {
    switch self.type {
    case let .Hourly(pay):
        return Int(Double(hours) * pay)
    case let .Salary(year):
        return year
    }
  }
  
  open func raise(_ amt : Int) {
    switch self.type {
    case .Hourly:
        break
    case let .Salary(year):
        self.type = Job.JobType.Salary(year + amt)
    }
  }
    
  open func raise(_ amt : Double) {
    switch self.type {
    case let .Hourly(pay):
        self.type = Job.JobType.Hourly(pay + amt)
    case .Salary:
        break
    }
  }
}

////////////////////////////////////
// Person
//
open class Person : CustomStringConvertible {
    public var description: String {
        get {
            var myJob : String
            var mySpouse : String
            if self._job == nil {
                myJob = "no job"
            } else {
                myJob = "a job of \(self._job!.title)"
            }
            if self._spouse == nil {
                mySpouse = "no spouse"
            } else {
                mySpouse = "a spouse of \(self._spouse!.firstName) \(self._spouse!.lastName)"
            }
            return "\(firstName) \(lastName) is a \(age)-year-old person with \(myJob) and with \(mySpouse)"
        }
    }
  open var firstName : String = ""
  open var lastName : String = ""
  open var age : Int = 0

  fileprivate var _job : Job? = nil
  open var job : Job? {
    get {
        return self._job
    }
    set(value) {
        if (self.age >= 16) {
            self._job = value
        } else {
            self._job = nil
        }
    }
  }
  
  fileprivate var _spouse : Person? = nil
  open var spouse : Person? {
    get { return self._spouse }
    set(value) {
        if (self.age >= 18) {
            self._spouse = value
        } else {
            self._spouse = nil
        }
    }
  }
  
  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }
  
  open func toString() -> String {
//    var myJob: String;
//    var mySpouse: String;
//    if (self.job == nil) {
//        myJob = "no job";
//    } else {
//        myJob = "a job of \(self.job!)"
//    }
//    if (self.spouse == nil) {
//        mySpouse = "no spouse";
//    } else {
//        mySpouse = "a spouse whose name is \(self.spouse!.firstName) \(self.spouse!.lastName)"
//    }
    return "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(self.job) spouse:\(self.spouse)]"
    //"\(firstName) \(lastName) is \(age) years old with \(myJob) and with \(mySpouse)"
  }
}

////////////////////////////////////
// Family
//
open class Family : CustomStringConvertible {
    public var description: String {
        get {
            var output = ""
            for member in self.members {
                output += "\(member.firstName) \(member.lastName), "
            }
            return "This family has members : \(output)and the household income is \(self.householdIncome())"
        }
    }
  fileprivate var members : [Person] = []
  
  public init(spouse1: Person, spouse2: Person) {
    if spouse1.spouse == nil && spouse2.spouse == nil {
        self.members.append(spouse1)
        self.members.append(spouse2)
        spouse1.spouse = spouse2
        spouse2.spouse = spouse1
    }
  }
  
  open func haveChild(_ child: Person) -> Bool {
    var result : Bool = true;
    for member in members {
        if member.age <= 21 {
            result = false;
        }
    }
    if result {
        child.age = 0;
        self.members.append(child)
    }
    return result;
  }
  
  open func householdIncome() -> Int {
    var result = 0;
    for member in members {
        if member.job != nil {
            result += member.job!.calculateIncome(2000)
        }
    }
    return result
  }
}

protocol Mathematics {
    mutating func plus(_ num : Int)
    mutating func minus(_ num: Int)
}

extension Double {
    var USD: Money {
        get {
            return Money(amount: Int(self), currency: Money.CurrencyType.USD)
        }
    }
    
    var EUR: Money {
        get {
            return Money(amount: Int(self), currency: Money.CurrencyType.EUR)
        }
    }
    
    var GBP: Money {
        get {
            return Money(amount: Int(self), currency: Money.CurrencyType.GBP)
        }
    }
    
    var YEN: Money {
        get {
            return Money(amount: Int(self), currency: Money.CurrencyType.YEN)
        }
    }
    
    var CAN: Money {
        get {
            return Money(amount: Int(self), currency: Money.CurrencyType.CAN)
        }
    }
}

