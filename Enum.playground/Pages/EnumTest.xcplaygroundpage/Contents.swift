/*:### 【ChaoCode】 Swift 中級 4：Enum 實作作業
 ---
 1. 建立一個名為「感情狀態」的 enum。
 * 一共有五種選項：單身、穩定交往中、已婚、開放式關係、一言難盡。
 * 穩定交往和結婚需要輸入伴侶名字。
 * 調整這個類型被印出來時顯示的文字，如果是穩定交往或是已婚需要顯示對象。
 ```
 例如：和小白穩定交往中。
 ```
 ---
 */

enum 感情狀態: CustomStringConvertible {
    case 單身, 一言難盡, 開放式關係, 已婚(伴侶: String), 穩定交往中(伴侶: String)
    var description: String {
        switch self {
            case .單身:
                return "依舊是單身"
            case .一言難盡:
                return "目前狀態一言難盡"
            case .開放式關係:
                return "目前相當開放"
            case .已婚(伴侶: let 伴侶):
                return "已婚且伴侶為\(伴侶)"
            case .穩定交往中(伴侶: let 伴侶):
                return "穩定交往中且為\(伴侶)"
        }
    }
}



// 👇 請勿刪除下面的 print，你需要讓它們可以正常執行，請自行確認結果是否如同預期。
print(感情狀態.單身)
print(感情狀態.一言難盡)
print(感情狀態.開放式關係)
print(感情狀態.已婚(伴侶: "結衣"))
print(感情狀態.穩定交往中(伴侶: "哈利"))

/*:
 ---
 2. 請根據下列需求設計以下兩個 enum 和一個 struct。
 * 讓 Card 根據大老二的規則比大小（Comparable）。\
 ```- 先比數字大小，數字一樣時再比花色。```\
 ```- 數字大小 2 > ace > king> queen> jack > 10, 9, 8, 7, 6, 5, 4, 3```\
 ```- 同數字時比較花色，黑桃 > 紅心 > 方塊 > 梅花```
 * 讓 Card 被印出來時印出花色表情 + 全形文字。對印文字如下：\
 ```花色：黑桃 ♠️、紅心 ♥️、方塊 ♦️、梅花 ♣️```\
 ```數字：Ａ、２、３、４、５、６、７、８、９、１０、Ｊ、Ｑ、Ｋ```
 * 請勿修改 case 名稱（你可以調整順序）和屬性名稱，也不要增加自訂的啟動方式。
 ```
 例如：紅心 12 應印出♥️Ｑ
 ```
 ---
 */

enum 卡牌花色: Int, Comparable {
    case 黑桃, 紅心, 方塊, 梅花
    static func < (lhs: 卡牌花色, rhs: 卡牌花色) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
    var emoji: String {
        switch self {
            case .梅花: return "♣️"
            case .方塊: return "♦️"
            case .紅心: return "♥️"
            case .黑桃: return  "♠️"
        }
    }
}

enum 卡牌數字: Int, Comparable, CustomStringConvertible {
    case three, four, five, six, seven, eight, nine, ten, jack, queen, king, ace, two
    static func < (lhs: 卡牌數字, rhs: 卡牌數字) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
    var description: String {
        switch self {
            case .ace: return "Ａ"
            case .two: return "２"
            case .three: return "３"
            case .four: return "４"
            case .five: return "５"
            case .six: return "６"
            case .seven: return "７"
            case .eight: return "８"
            case .nine: return "９"
            case .ten: return "１０"
            case .jack: return "Ｊ"
            case .queen: return "Ｑ"
            case .king: return "Ｋ"
        }
    }
}

struct Card: Comparable, CustomStringConvertible {
    static func < (lhs: Card, rhs: Card) -> Bool {
        if lhs.數字 == rhs.數字 {
            return lhs.花色 < rhs.花色
        } else {
            return lhs.數字 < rhs.數字
        }
    }
    
    var description: String {
        花色.emoji + 數字.description
    }
    
    var 花色: 卡牌花色
    var 數字: 卡牌數字
    
}


func testCard() {
    let testCases = [(Card(花色: .紅心, 數字: .ace), Card(花色: .黑桃, 數字: .nine), true, "♥️Ａ"),
                     (Card(花色: .梅花, 數字: .two), Card(花色: .梅花, 數字: .queen), true, "♣️２"),
                     (Card(花色: .梅花, 數字: .ace), Card(花色: .梅花, 數字: .three), true, "♣️Ａ"),
                     (Card(花色: .黑桃, 數字: .ten), Card(花色: .黑桃, 數字: .nine), true, "♠️１０"),
                     (Card(花色: .方塊, 數字: .queen), Card(花色: .黑桃, 數字: .ten), true, "♦️Ｑ"),
                     (Card(花色: .梅花, 數字: .king), Card(花色: .紅心, 數字: .king), false, "♣️Ｋ"),
                     (Card(花色: .紅心, 數字: .two), Card(花色: .紅心, 數字: .king), true, "♥️２"),
                     (Card(花色: .梅花, 數字: .six), Card(花色: .梅花, 數字: .ace), false, "♣️６"),
                     (Card(花色: .方塊, 數字: .six), Card(花色: .黑桃, 數字: .two), false, "♦️６"),
                     (Card(花色: .紅心, 數字: .three), Card(花色: .梅花, 數字: .seven), false, "♥️３"),
                     (Card(花色: .紅心, 數字: .five), Card(花色: .黑桃, 數字: .seven), false, "♥️５"),
                     (Card(花色: .梅花, 數字: .ace), Card(花色: .紅心, 數字: .three), true, "♣️Ａ"),
                     (Card(花色: .梅花, 數字: .five), Card(花色: .紅心, 數字: .five), false, "♣️５"),
                     (Card(花色: .方塊, 數字: .king), Card(花色: .黑桃, 數字: .four), true, "♦️Ｋ"),
                     (Card(花色: .梅花, 數字: .ace), Card(花色: .黑桃, 數字: .queen), true, "♣️Ａ"),
                     (Card(花色: .黑桃, 數字: .seven), Card(花色: .方塊, 數字: .seven), true, "♠️７"),
                     (Card(花色: .紅心, 數字: .jack), Card(花色: .梅花, 數字: .eight), true, "♥️Ｊ"),
                     (Card(花色: .方塊, 數字: .jack), Card(花色: .方塊, 數字: .queen), false, "♦️Ｊ"),
                     (Card(花色: .梅花, 數字: .jack), Card(花色: .紅心, 數字: .four), true, "♣️Ｊ")]
    for testCase in testCases {
        if String(describing: testCase.0) != testCase.3 {
            print("❌ 您印出的是\(String(describing: testCase.0))，應印出 \(testCase.3)")
            break
        }
    }
    
    
    for test in testCases {
        if (test.0 > test.1) != test.2 {
            let answer = test.2 ? "小於" : "大於"
            print("❌ \(test.0) 應\(answer) \(test.1)")
            break
        }
    }
    print("✅ 您的卡牌設計沒有問題。")
}
testCard()
