import UIKit

// 一些筆記
/*
 try = 需搭配catch使用，通常會是do catch
 try! = 強制解開，如果有錯誤就會直接報錯，如果沒有錯誤直接會是回傳類型
 try? = 如果有錯誤就會回傳nil，如果沒有錯誤會是optional類型
 */

// 錯誤的一些用法
func doSomething<T: Numeric>(number: T) -> String {
    switch number {
        case is Int:
            return "是整數"
        case is Double:
            return "浮點數"
        default:
            fatalError("不應該到這裡")
    }
}

func doNothing() -> String {
    fatalError("尚未實作，可以使用該方法先跳過實作，讓編譯器可以正常運作")
}

// 一些try catch的用法
struct 使用者 {
    var name: String = "Jane"
    private init() {}
    static func 登入(帳號: String, 密碼: String) throws -> 使用者 {
        guard 帳號.contains("@") && !帳號.contains(" ") else {
            throw 登入錯誤.帳號格式錯誤(account: 帳號)
        }
        if 帳號 != "jane@chaocode.com" {
            throw 登入錯誤.未註冊的帳號(account: 帳號)
        }
        if 密碼 != "pass" {
            throw 登入錯誤.密碼錯誤
        }
        return 使用者()
    }
}

enum 登入錯誤: LocalizedError {
    case 未註冊的帳號(account: String)
    case 帳號格式錯誤(account: String)
    case 密碼錯誤
}

enum 網路錯誤: Error {
    case 無法連線
}

func 嘗試登入(_ 帳號: String, _ 密碼: String) {
    do {
        defer {
            // 放在這裡表示do當中要離開時會做的
            // 如果將defer放到let後面一行當發生錯誤的時候不會執行defer
            print("Hello!")
        }
        let user = try 使用者.登入(帳號: 帳號, 密碼: 密碼)
        print("Hello \(user.name) wellcome back")
    } catch 登入錯誤.密碼錯誤, 登入錯誤.未註冊的帳號 {
        print("帳號或密碼不正確，請重新輸入")
    } catch 登入錯誤.帳號格式錯誤(let account) where !account.contains("@") {
        print("登入帳號應為信箱")
    } catch 登入錯誤.帳號格式錯誤 {
        print("帳號有不正確字元")
    } catch is 網路錯誤{
        print("網路不穩定")
    } catch {
        print(error)
    }
}

嘗試登入("jane@chaocode.com", "pass")
嘗試登入("jan@chaocode.com", "pass")
print("----------------------")

// throws用法

enum MathError: LocalizedError, CustomNSError {
    case cannotDividedEvenly, cannotDividedByZero
    static var errorDomain: String { "MathError" }
    var errorDescription: String? {
        switch self {
        case .cannotDividedEvenly:
            return "無法被整除"
        case .cannotDividedByZero:
            return "除以零不合法"
        }
    }
}

extension Int {
    func divideEvenly(by factor: Int) throws -> Int {
        guard factor != .zero else {
            throw MathError.cannotDividedByZero
        }
        guard self % factor == 0 else {
            throw MathError.cannotDividedEvenly
        }
        return self / factor
    }
}

let number = 3
let divisors = [2, 0, 3]
divisors.forEach { divisor in
    print("\(number) / \(divisor)")
    do {
        let result = try number.divideEvenly(by: divisor)
        print("沒有問題 結果為\(result)")
    } catch let error as NSError {
        print(error)
        print(error.localizedDescription)
        print(error.code)
        print(error.userInfo)
        print(error.domain)
    } catch {
        assertionFailure()
    }
}
print("----------------------")

// rethrows 轉發錯誤

let array = [1, 3, 5]

extension Array {
    func joined(by seperator: String, stringify: (Element) throws -> String) rethrows -> String {
        try map(stringify).joined(separator: seperator)
    }
}

let joinedString = array.joined(by: "、", stringify: ({ $0.description }))
print(joinedString)

let dividedString = try? array.joined(by: "、", stringify: {
    try $0.divideEvenly(by: 3).description
})
