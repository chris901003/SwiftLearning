import UIKit

// Without associate value

enum 會員等級: String, CaseIterable, CustomStringConvertible {
    case 免費會員, 銀卡會員, 金卡會員
    enum 權限: String, CaseIterable {
        case 觀看舊片, 跳過廣告, 下載影片, 觀看新片
    }
    
    var 費用: Int {
        switch self {
            case .免費會員:
                return 0
            case .銀卡會員:
                return 250
            case .金卡會員:
                return 400
        }
    }
    
    var description: String { rawValue }
    
    func 可以使用(_ 權限: 權限) -> Bool {
        switch self {
            case .免費會員:
                return 權限 == .觀看新片
            case .銀卡會員:
                return 權限 != .觀看新片
            case .金卡會員:
                return true
        }
    }
    
    static let 所有會員類型 = 會員等級.allCases.map {$0.rawValue}.joined(separator: "、")
}

print("你好，請選擇你想要加入的會員類型：\(會員等級.所有會員類型)")
let myMembership = 會員等級.allCases.randomElement()!
print("歡迎加入\(myMembership)")

會員等級.權限.allCases.forEach { 權限類別 in
    let isAllowed = myMembership.可以使用(權限類別)
    print(isAllowed ? "你可以 \(權限類別)" : "\(myMembership) 無法 \(權限類別)")
}
// 使用rawValue進行啟動
var 會員等級啟動 = 會員等級.init(rawValue: "免費會員")
print(會員等級啟動!)

 

// With associate value
enum 性別: CaseIterable, CustomStringConvertible, RawRepresentable {
    
    typealias RawValue = String
    
    init(rawValue: String) {
        switch rawValue {
            case "生理男":
                self = .生理男
            case "生理女":
                self = .生理女
            default:
                self = .其他(描述: rawValue)
        }
    }
    
    var rawValue: String {
        switch self {
        case .生理男:
            return "生理男"
        case .生理女:
            return "生理女"
        case .其他(描述: let 描述, 特徵: let 特徵):
            return "其他: " + 描述 + " \(特徵)"
        }
    }
    
    case 生理男, 生理女, 其他(描述: String = "Other", 特徵: String = "None")
    
    var description: String {
        rawValue
    }
    
    static var allCases: [性別] = [.生理男, .生理女, .其他()]
}

性別.其他(描述: "酷兒")
print(性別.其他())
print(性別.allCases)
性別.init(rawValue: "其他")
性別.init(rawValue: "生理男")
