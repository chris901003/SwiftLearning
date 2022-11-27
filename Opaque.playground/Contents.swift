import UIKit

protocol 有交友資料: Equatable {
    var 名字: String { get }
    var 自我介紹: String { get }
}

struct 高顏值機器人: 有交友資料 {
    var 名字: String
    var 自我介紹: String = ""
    
    func 發罐頭訊息() {}
    func 已讀訊息() {}
}

struct 會員: 有交友資料 {
    enum 會員類型 { case 普通會員, 享樂會員, 尊榮會員 }
    var 名字: String
    var 自我介紹: String = ""
    
    var 帳號: String = ""
    var 手機: String = ""
    var 生日: String = ""
    var 會員類型: 會員類型 = .普通會員
    
    func 產生每日配對() -> some 有交友資料 {
//        return 會員(名字: "湯姆")
        return 高顏值機器人(名字: "愛麗絲")
    }
    
    func 發訊息<T: 有交友資料>(給 person: T, _ message: String) {
        print("\(名字) 對 \(person.名字) 説: \(message)")
    }
}

let user = 會員(名字: "Jane")
let match = user.產生每日配對()
user.發訊息(給: match, "Hello")
