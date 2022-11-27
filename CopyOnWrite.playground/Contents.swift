import UIKit

final class Reference<T> {
    var value: T
    init(_ value: T) { self.value = value }
}

struct CopyOnWriteWrapper<T> {
    var reference: Reference<T>
    var value: T {
        get { reference.value }
        set {
            if isKnownUniquelyReferenced(&reference) {
                print("只剩下一個強連結")
                reference.value = newValue
            } else {
                print("還有其他強連結，會構建一個新的指向對象")
                reference = Reference(newValue)
            }
        }
    }
    
    init(_ value: T) {
        self.reference = Reference(value)
    }
}

var cow = CopyOnWriteWrapper(1)
var cow2 = cow
print(cow.value)
print(cow2.value)
print("============")
cow2.value = 2
print(cow.value)
print(cow2.value)
print("============")
cow2.value = 3
print(cow.value)
print(cow2.value)


extension String {
    static func *(string: String, count: Int) -> String {
        Array.init(repeating: string, count: count).joined()
    }

    static func *=(string: inout String, count: Int) {
        string = string * count
    }
}

var string = "hello~"
string *= 3
print(string)
