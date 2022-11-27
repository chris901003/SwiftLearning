import UIKit

// 最基礎的KeyPath
//struct 貓咪 {
//    var name: String
//    var age: Int? = nil
//}
//
//let someKeyPath = \貓咪.name
//let someClosure: (貓咪) -> String = \.name
//
//let cats:[貓咪] = [.init(name: "淡淡", age: 20), .init(name: "桔咪", age: 10)]
//
//print(cats.map(\.name))
//print(cats.map(\.age?.description))
//print(cats[keyPath: \.[0].name])
//var cat = cats.first!
//cat[keyPath: someKeyPath] = "Egg"
//print(cat)

// 稍微進階的KeyPath用法，同時也有contain以及filter的用法
//struct 貓咪: CustomStringConvertible {
//    var name: String
//    var color: String
//
//    var description: String {
//        "\(name) (\(color))"
//    }
//}
//
//let cats: [貓咪] = [.init(name: "淡淡", color: "橘"), .init(name: "橘咪", color: "白+黃")]
//
//print(cats.filter { $0.name.contains("橘") || $0.color.contains("橘") })
//
//print(cats.filter({(catInfo: 貓咪) -> Bool in catInfo
//    return catInfo.name.contains("橘") || catInfo.color.contains("橘")
//}))
//
//extension Array {
//    func filter(keyword: String, on paths: [KeyPath<Element, String>]) -> Self {
//        filter { 資料 in
//            paths.contains{ path in
//                let 屬性資料 = 資料[keyPath: path]
//                return 屬性資料.contains(keyword)
//            }
//        }
//    }
//
//    func fullFilter(keyword: String, on paths: [KeyPath<Element, String>]) -> Self {
//        filter({(資料: Element) -> Bool in
//            paths.contains(where: {(path: KeyPath<Element, String>) -> Bool in
//                let 屬性資料 = 資料[keyPath: path]
//                return 屬性資料.contains(keyword)
//            })
//        })
//    }
//}
//
//print(cats.fullFilter(keyword: "橘", on: [\.name, \.color]))

// KeyPath + Protocol
protocol 可搜尋 {
    static var 搜尋屬性: [KeyPath<Self, String>] { get }
}

extension Sequence where Element: 可搜尋 {
    func filter(keyword: String) -> [Element] {
        filter { 資料 in
            Element.搜尋屬性.contains{ path in
                let 屬性資料 = 資料[keyPath: path]
                return 屬性資料.contains(keyword)
            }
        }
    }
}

struct 貓咪: CustomStringConvertible, 可搜尋 {
    static var 搜尋屬性: [KeyPath<貓咪, String>] = [\.color, \.name]
    
    var name: String
    var color: String
    
    var description: String {
        "\(name) (\(color))"
    }
}

let cats: [貓咪] = [.init(name: "淡淡", color: "橘"), .init(name: "橘咪", color: "白+黃")]
print(cats.filter(keyword: "橘"))


protocol 可計算 {
    static var 總合對象: KeyPath<Self, Int> { get }
    static var 比較對象: KeyPath<Self, Int> { get }
}

struct dog: CustomStringConvertible, 可計算 {
    static var 總合對象: KeyPath<dog, Int> = \.weight
    static var 比較對象: KeyPath<dog, Int> = \.weight
    var name: String
    var weight: Int
    var description: String {
        "\(name), (\(weight))"
    }
}

extension Sequence where Element: 可計算 {
    func sorted() -> [Element] {
        sorted {
            $0[keyPath: Element.比較對象] > $1[keyPath: Element.比較對象]
        }
    }
    
    func sum() -> Int {
        reduce(Int.zero) {
            $0 + $1[keyPath: Element.總合對象]
        }
    }
}

let dogs: [dog] = [.init(name: "A", weight: 200), .init(name: "B", weight: 20), .init(name: "C", weight: 220)]
print(dogs.sorted())
print(dogs.sum())
