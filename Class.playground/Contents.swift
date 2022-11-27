import UIKit

// Designated init
class 媽媽 {
    var momName: String
    func 洗碗() -> Void {
        print("A")
    }
    init(_ momName: String) {
        self.momName = momName
    }
}

class 小孩: 媽媽 {
    var childName: String
    override var momName: String {
        willSet {
            print("Mom name is going to change with \(newValue)")
        }
    }
    override func 洗碗() -> Void {
        super.洗碗()
        print("B")
    }
    init(_ momName: String, _ childName: String) {
        self.childName = childName
        super.init(momName)
    }
}

var t = 小孩("A", "B")
t.洗碗()
print(dump(t))
t.momName = "C"

// Convenience init
// 在Convience的啟動當中，會呼叫另外一個「自己的」啟動
// 並且啟動的呼叫最終一定要連接到一個Designated啟動
// require是避免繼承的class不遵守protocal

protocol 限制至少需要有的啟動方式 {
    init(寬: Double, 長寬比: Double)
}

class 矩形: 限制至少需要有的啟動方式 {
    var 寬: Double
    var 長: Double
    
    init(寬: Double, 長: Double) {
        self.寬 = 寬
        self.長 = 長
    }
    
    required init(寬: Double, 長寬比: Double) {
        self.寬 = 寬
        self.長 = 寬 * 長寬比
    }
    
    convenience init(單邊長: Double) {
        self.init(寬: 單邊長, 長: 單邊長)
//        self.寬 = 單邊長
//        self.高 = 單邊長
    }
}

// 在extension當中只能擴增convenience的啟動方式
extension 矩形 {
    convenience init() {
        self.init(單邊長: 1)
    }
}


class 立體矩形: 矩形 {
    var 高: Double
    
    init(寬: Double,長: Double, 高: Double) {
        self.高 = 高
        super.init(寬: 寬, 長: 長)
    }
    required init(寬: Double, 長寬比: Double) {
        self.高 = 1
        super.init(寬: 寬, 長寬比: 長寬比)
    }
    convenience init(單邊長: Double) {
        self.init(寬: 單邊長, 長: 單邊長, 高: 單邊長)
    }
}

// 關於class獨有的===符號，以及一些protocal測試

class Book: Equatable, Comparable, CustomStringConvertible {
    var name: String
    var price: Int
    
    static func == (lhs: Book, rhs: Book) -> Bool {
        return lhs.name.lowercased() == rhs.name.lowercased()
    }
    static func < (lhs: Book, rhs: Book) -> Bool {
        return lhs.price < rhs.price
    }
    var description: String {
        return "Book name: \(name), Book price: \(price)"
    }
    
    init(_ name: String, _ price: Int) {
        self.name = name
        self.price = price
    }
}

var book1 = Book("A", 100)
var book2 = Book("a", 200)
var book3 = Book("B", 50)
// === 表示對於是否為指向同一個記憶體位置
print(book1 === book2)
// 需要confirm to Equatable
print(book1 == book2)

var books: [Book] = [book1, book2, book3]
print(books.sorted())


// 限制protocol只能搭配class
// 這裡會需要加上AnyObject表示只能由class來遵守該protocol
protocol 工作: AnyObject {
    var 已完成: Book { get }
}

// 這裡可以用weak的對象需要是reference type的資料，而如果沒有限制
// protocal的對象會導致可能對象是value type的資料，這樣會報錯
class 工程師 {
    weak var task: 工作? 
}
