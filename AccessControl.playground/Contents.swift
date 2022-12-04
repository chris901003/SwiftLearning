import UIKit

@propertyWrapper
struct remindChange {
    var wrappedValue: Int {
        didSet {
            print("You have change value to \(wrappedValue)")
        }
    }
    var projectedValue: Self { self }
    init(_ wrappedValue: Int) {
        self.wrappedValue = wrappedValue
    }
}

struct bankAccount {
    @remindChange var balance: Int
    init(_ balance: Int) {
        _balance = .init(balance)
    }
}

enum 季節: String, CaseIterable, CustomStringConvertible {
case spring, summer, fall, winter
    var description: String {
        switch self {
            case .spring:
                return "S"
            case .summer:
                return "SS"
            case .fall:
                return "SSS"
            case .winter:
                return "SSSS"
        }
    }
}
print(季節.allCases)
var season = 季節.init(rawValue: "summer")!


extension Collection where Element: Comparable {
    mutating func getLast() -> Element? {
        self = self.sorted() as! Self
        return self.first
    }
}

var t = [5, 4, 3, 2, 1]
print(t.getLast()!)

protocol 基本資料 {
    associatedtype nameType
    var name: nameType { get set }
    init(_ name: nameType)
}

struct user: 基本資料 {
    typealias nameType = String
    var name: String
    init(_ name: String) {
        self.name = name
    }
}

protocol HasName {
    var name: String { get }
}

func doSomething2(array: [HasName]) {
    array.forEach { info in
        print(info.name)
    }
}

struct user2: HasName {
    var name: String = "Chris"
    var score: Int = 100
}

struct student: HasName {
    var name: String = "Kevin"
    var height: Int = 165
}

doSomething2(array: [user2(), student()])
