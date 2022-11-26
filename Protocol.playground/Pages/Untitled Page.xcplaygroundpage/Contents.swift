import UIKit

struct Test: CustomStringConvertible {
    var name: String
    var score: Int
    var description: String {
        "Name: \(name) with score \(score)"
    }
}

var testArray: [Test] = [.init(name: "A", score: 10), .init(name: "B", score: 15), .init(name: "C", score: 52), .init(name: "D", score: 86), .init(name: "E", score: 16)]

var testIndex = testArray.firstIndex {
    $0.score > 20
}
print(testArray[testIndex!])

//protocol 可戰鬥 {
//    associatedtype Level: Strideable where Level.Stride == Int
//    var name: String { get }
//    var hp: Int { get set }
//    var 最大hp: Int { get set }
//    var 攻擊力: Int { get set }
//    var 等級: Level { get set }
//    init()
//}
//
//extension 可戰鬥 {
//    mutating func 休息() {
//        hp = 最大hp
//    }
//    mutating func 升級() {
//        最大hp = Int(Double(最大hp) * 1.1)
//        hp = 最大hp
//        攻擊力 = Int(Double(攻擊力) * 1.2)
//        等級 =  等級.advanced(by: 1)
//        print("\(name) 升至 \(等級) 級了，現在 hp 為 \(hp); 攻擊力為 \(攻擊力)。")
//    }
//    func 攻擊<T: 可戰鬥>(on target: inout T) {
//        target.hp -= self.攻擊力
//        print("\(name) 對 \(target.name) 造成 \(攻擊力) 點傷害， \(target.name) 剩下 \(target.hp)")
//    }
//}

// 第一部分
//struct 寶可夢: 可戰鬥 {
//    var name: String = "某個寶可夢"
//    var hp: Int = 50
//    var 最大hp: Int = 50
//    var 攻擊力: Int = 5
//    var 等級: Int = 1
//}
//
//struct 邪惡外星人: 可戰鬥 {
//    var name: String = "某個邪惡外星人"
//    var hp: Int = 60
//    var 最大hp: Int = 60
//    var 攻擊力: Int = 7
//    var 等級: Int = 1
//}
//
//var 皮卡丘 = 寶可夢(name: "皮卡丘")
//var 外星人 = 邪惡外星人()
//皮卡丘.升級()
//外星人.升級()
//皮卡丘.攻擊(on: &外星人)

// 第二部分
//struct 絕地武士: 可戰鬥 {
//    enum 階級: Int, Strideable, CustomStringConvertible {
//        typealias Stride = Int
//
//        var description: String {
//            switch self {
//                case .幼徒:
//                    return "幼徒"
//                case .學徒:
//                    return "學徒"
//                case .絕地武士:
//                    return "絕地武士"
//                case .大師:
//                    return "大師"
//                case .宗師:
//                    return "宗師"
//            }
//        }
//
//        func advanced(by n: Int) -> 絕地武士.階級 {
//            let level = rawValue + n
//            return 階級.init(rawValue: level) ?? .宗師
//        }
//
//        func distance(to other: 絕地武士.階級) -> Int {
//            return other.rawValue - self.rawValue
//        }
//
//        case 幼徒, 學徒, 絕地武士, 大師, 宗師
//    }
//
//    var name: String = "某個絕地武士"
//    var hp: Int = 100
//    var 最大hp: Int = 60
//    var 攻擊力: Int = 5
//    var 等級: 階級 = .幼徒
//}
//
//var 武士 = 絕地武士()
//var 皮丘 = 寶可夢()
//武士.升級()
//武士.升級()
//武士.升級()
//武士.升級()
//武士.升級()
//武士.攻擊(on: &皮丘)

// Protocal + Protocal
protocol 可戰鬥: Equatable, CustomStringConvertible {
    associatedtype Level: Strideable where Level.Stride == Int
    var name: String { get }
    var hp: Int { get set }
    var 最大hp: Int { get set }
    var 攻擊力: Int { get set }
    var 等級: Level { get set }
    init()
}

// 將需要遵守的protocal先寫道extenstion當中，當有其他類需要遵守可戰鬥
// 的時會直接套用，同時也可以進行複寫
extension 可戰鬥 {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.name == rhs.name
    }
}
