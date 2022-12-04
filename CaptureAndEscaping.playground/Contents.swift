import UIKit

// 自動Capture
func getBuyCandyClosure() -> () -> Void {
    var money = 100
    func buyCandy() {
        money -= 20
        print("😊🍬，剩下\(money)")
    }
    return buyCandy
}

let buyCandy = getBuyCandyClosure()
buyCandy()
buyCandy()

// 在class中的Capture
class 錢包 {
    var money: Int = 100
    func buySomething(cost: Int) {
        money -= cost
        print("花了 \(cost)，剩下 \(money)")
    }
    deinit {
        print("錢包掰掰")
    }
}

var wallet: 錢包? = 錢包()
wallet?.buySomething(cost: 20)
// 這裡會產生一個強連結，導致下方即使wallet設定成nil實例對象依舊存在
var buySomething: ((Int) -> Void)? = wallet?.buySomething
wallet = nil
buySomething?(30)
// 在這裡將強連結去除後就會釋放實例對象
buySomething = nil


// Capture List
class 錢包包 {
    var money: Int = 100
    
    // 這裡透過weak self將此closure用弱連結連到self上
    // 所以當實例化錢包包對象的變數改成nil時會釋放實例對象
    lazy var buySomething: (Int) -> Void = { [weak self] cost in
        guard let self = self else {
            print("沒有錢包可以用了")
            return
        }
        self.money -= cost
        print("花了 \(cost)，剩下 \(self.money)")
    }
    
    // 這裡會是複製一份money的值近來，所以與當前實例對象的數值不同步
    lazy var checkMoney: () -> Void = { [money] in
        print("剩下\(money)")
    }
    deinit {
        print("錢包掰掰")
    }
}

var wallet2: 錢包包? = 錢包包()
wallet2?.buySomething(20)
var buySomething2 = wallet2?.buySomething
wallet2?.checkMoney()
wallet2 = nil
buySomething2?(30)

// Escaping 表示closure會以某種形式繼續存在
// 也就是將該closure放入到函數的參數中後，函數會使用強連結與closure連接

struct A {
    var closure: () -> Void
    init(closure: @escaping () -> Void) {
        self.closure = closure
    }
}
