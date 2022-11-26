import UIKit


@propertyWrapper
struct MaxLilter {
    var wrappedValue: Double {
        didSet {
            wrappedValue = wrappedValue > maxValue ? maxValue : wrappedValue
        }
    }
    private(set) var maxValue: Double
}

struct Project {
    @MaxLilter(wrappedValue: 100, maxValue: 200) var product
    init(_ product: Double, maxValue: Double) {
        _product = .init(wrappedValue: product, maxValue: maxValue)
    }
    init() {
        
    }
}

var project = Project(120, maxValue: 1000)
print(project.product)
project.product = 220
print(project.product)


@propertyWrapper
struct LimitFilter {
    var wrappedValue: Double {
        get {
            price * discount
        }
        set {
            price = newValue
        }
    }
    private(set) var price: Double {
        willSet {
            print("Is going to update price with new value \(newValue)")
            if newValue > maxPrice {
                print("New price value is too large")
            }
        }
        didSet {
            price = price > maxPrice ? maxPrice : price
            print("Update new price \(price)")
            print("We are going to use \(maxPrice) to replace")
        }
    }
    private(set) var discount: Double {
        didSet {
            discount = discount > maxDiscount ? maxDiscount : discount
            print("Updata new discount \(discount)")
        }
    }
    var maxPrice: Double
    var maxDiscount: Double
    init(_ price: Double, discount: Double, maxPrice: Double, maxDiscount: Double) {
        self.price = price
        self.discount = discount
        self.maxPrice = maxPrice
        self.maxDiscount = maxDiscount
    }
}

struct Store {
    @LimitFilter(100, discount: 0.8, maxPrice: 200, maxDiscount: 0.5) var shope
}

var s = Store()
print(s.shope)
s.shope = 220
print(s.shope)

@propertyWrapper
struct ChangeLog<T> {
    var wrappedValue: T {
        didSet {
            print("\(描述)的值被改變成 \(wrappedValue)")
        }
    }
    var projectedValue: Self {self}
    private(set) var 描述: String
}

struct 帳目 {
    @ChangeLog(描述: "用途") var 用途: String = ""
    @ChangeLog var 費用: Int
    
    init(用途: String, 費用: Int) {
        self.用途 = 用途
        _費用 = .init(wrappedValue: 費用, 描述: "\(用途) 花費")
    }
}

var spend = 帳目(用途: "Costo 採買", 費用: 2000)
print(spend.用途, spend.費用)
spend.費用 = 3000
spend.用途 = "Costco 採買 + 吃東西"
