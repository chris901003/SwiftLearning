import UIKit

// is 確認類型 -> 回傳Bool
// as? 嘗試轉型 -> 回傳optional
// as! 強制轉型 -> 回傳對應類型

let array: [Any] = ["abc", 123]

print(array is [Int])
print(array is [CustomStringConvertible])
let intArray = array as? [Int]
let descriptionArray = array as! [CustomStringConvertible]

print("===========================")
descriptionArray.forEach { element in
    if element is Int {
        print("Int: \(element)")
    } else if element is String {
        print("String: \(element)")
    }
}

print("===========================")
descriptionArray.forEach { element in
    if let element = element as? Int {
        print("Int: \(element)")
    } else if let element = element as? String {
        print("String: \(element)")
    }
}

print("===========================")
descriptionArray.forEach { element in
    switch element {
        case is String:
            print("String: \(element)")
        case let element as Int:
            print("Int: \(element)")
        default:
            break
    }
}
