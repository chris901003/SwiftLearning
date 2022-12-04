import UIKit

actor BankAccount {
    let name: String
    var balance = 1000
    init(_ name: String) { self.name = name }
    
    func withdraw(_ amount: Int) -> Int {
        if amount > balance {
            print("⚠️ \(name)存款只剩 \(balance) 元，無法提款 \(amount) 元")
            return 0
        }
        balance -= amount
        print("⬇️ \(name)提款 \(amount) 元，剩下 \(balance) 元")
        return amount
    }
    
    func deposit(_ amount: Int) -> Int {
        balance += amount
        print("\(name)存款 \(amount) 元，目前存款為 \(balance) 元")
        return balance
    }
    
    func printBlance() {
        print("\(name)餘額為: \(balance)元")
    }
    
    func doSomething() {
        // 這裡不會需要await，不過我們不會這麼做
        syncActions(account: self)
    }
}

func syncActions(account: isolated BankAccount) {
    account.withdraw(200)
    account.deposit(100)
}

extension BankAccount: CustomStringConvertible, Hashable {
    nonisolated var description: String {
        name
    }
    
    static func == (lhs: BankAccount, rhs: BankAccount) -> Bool {
        lhs.name == rhs.name
    }
    
    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

let familyAccount = BankAccount("家庭帳戶")
print("創建了 \(familyAccount.name)。")

Task {
    print("一開始有: \(await familyAccount.balance) 元。")
    await withTaskGroup(of: Void.self, body: { group in
        (0...3).forEach { number in
            group.addTask {
                await familyAccount.withdraw(200)
                await familyAccount.deposit(100)
            }
        }
        await group.waitForAll()
        await familyAccount.printBlance()
    })
}

// GlobalActor
// 這樣寫就可以將 @TradingActor 像是 @MainActor一樣使用
@globalActor
actor TradingActor {
    static let shared = TradingActor()
}

class Conter {
    var number = 0
    func increase() {
        number += 1
        print("計數器更新為 \(number)")
    }
}

let conter = Conter()
for _ in 1...10 {
    Task { @TradingActor in
        conter.increase()
    }
}
