import UIKit

// Extension
extension Locale {
    static let TCH: Locale = .init(identifier: "zh-hant-tw")
    static let Japan: Locale = .init(identifier: "ja_JP")
}

extension NumberFormatter {
    static let decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = .TCH
        return formatter
    }()
}

extension Numeric {
    func formatted(by formatter: NumberFormatter = .decimalFormatter) -> String {
        formatter.string(for: self)!
    }
}

let number = 1000
print(number.formatted())
print(1000000.formatted(by: .decimalFormatter))
print(10012301.12301.formatted(by: .currencyFormatter))

number.formatted(.currency(code: "TWD"))

struct Cat {
    var name: String
    var color: String
}

// 使用此中方式可以保留swift對於Cat自動產生的init方式
extension Cat {
    enum Color: String { case 橘色, 黃色, 黑色, 灰色, 白色 }
    init(name: String, color: Color) {
        self.name = name
        self.color = color.rawValue
    }
}

extension Cat: CustomStringConvertible {
    var description: String {
        self.name + " " + self.color
    }
}

extension Cat: Equatable {
    static func == (lhs: Cat, rhs: Cat) -> Bool {
        return lhs.name == rhs.name
    }
}

var cat = Cat(name: "淡淡", color: "橘色")
var cat2 = Cat(name: "Hello", color: .灰色)
print(cat)
print(cat2)
print(cat == cat2)
cat2.name = "淡淡"
print(cat == cat2)

// Subscript + Extension
let string = "可愛小貓咪"
extension String {
    subscript(_ offset: Int) -> Character? {
        guard offset >= 0, let index = self.index(startIndex, offsetBy: offset, limitedBy: index(before: endIndex)) else { return nil }
        return self[index]
    }
}

for index in -1...string.count {
    print(string[index] ?? "沒有")
}

// Protocal + Extension

// 會優先使用限制較多的方法
extension Collection where Element == Int {
    func sum() -> Self.Element {
        print("正在使用Int的方法")
        return reduce(0, +)
    }
}

extension Collection where Element: Numeric {
    func sum() -> Self.Element {
        self.reduce(.zero, +)
    }
}

print([1, 2, 3, 4, 5].sum())
print([1.2, 2.2, 1.4, 6.3].sum())
