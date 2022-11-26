//【ChaoCode】 Swift 中級篇 7：Protocol 實作作業 B
// ✨ 請閱讀完整份內容，了解使用情境後，請跟著以下步驟完成這題。你會需要新增你自訂的 protocol、調整現有的類型和完成設計「載客管理員」，最後讓測試的 code 能順利執行。
// 1️⃣ 請閱讀以下這三種類型，稍後你會需要回來調整它們。這三種交通工具「汽車、機車、直升機」都已設計完成，它們都有共同的屬性、都 conforms to CustomStringConvertible，並且都用同樣的方式計算抵達目的地的時間。

protocol 可載客: CustomStringConvertible {
    var 牌號: String { get }
    var 最大乘客數: Int { get }
    var 時速: Double { get }
    
    static var 交通工具名稱: String { get }
}

extension 可載客 {
    var description: String { "\(Self.交通工具名稱)牌號「\(牌號)」" }
    
    func 計算時間(目的地距離: Double) -> Int {
        let time = 目的地距離 / 時速
        let min = time * 60
        
        return Int(min)
    }
}

struct 汽車: 可載客 {
    var 最大乘客數: Int = 4
    var 牌號: String
    var 時速: Double
    
    static var 交通工具名稱 = "🚘 汽車"
}

struct 機車: 可載客 {
    let 最大乘客數: Int = 2
    var 牌號: String
    let 時速: Double
    
    static var 交通工具名稱 = "🛵 機車"
}

struct 直升機: 可載客 {
    let 最大乘客數: Int = 4
    var 牌號: String
    var 時速: Double
    
    static var 交通工具名稱 = "🚁 直升機"
}

// 2️⃣ 以下這個類型「載客管理員」，有一個儲存屬性「可用載客車」，它是一個 Array，裡面存放的是現在可以提供載客服務的交通工具。

struct 載客管理員 {
    // 3️⃣ 請讓這個「可用載客車」的 Array 可以放入上面建立的三種交通工具。你會需要編輯上面的 struct，但請確保他們被印出來時顯示的內容還是一樣，並且都能計算時數。（沒有限制如何調整，但請至少用到一個 protocol 來解決這個問題）
    // ⚠️ 為了後面能執行測試，修改時請勿調整上面三個和這個 struct 中儲存屬性的順序和名稱，也不要自訂 init。
    var 可用載客車: [可載客]
    
    // 4️⃣ 請設計派車方法，請勿修改名稱和參數，但需要放入回傳類型。
    // 請從可用載客車中依序找出第一台合適的交通工具，只要能滿足乘載要求的人數即可。假如沒有合適的交通工具就回傳 nil，有的話則把這台交通工具從隊列中移除，並且回傳這台交通工具。回傳之前請根據情況印出派車資訊。
    mutating func 派車(人數: Int, 客人距離: Double) -> 可載客? {
        guard let carIndex = (可用載客車.firstIndex { $0.最大乘客數 >= 人數 }) else {
            print("😣 很抱歉，目前沒有車輛。請稍後再試。")
            return nil
        }
        let car = 可用載客車[carIndex]
        let time = car.計算時間(目的地距離: 客人距離)
        print("\(car)正在前往您的地點，預計 \(time) 分鐘後抵達。")
        
        return 可用載客車.remove(at: carIndex)
    }
}

// 5️⃣ 以下為測試內容，請勿刪除和修改。

var carManager = 載客管理員(可用載客車: [汽車(最大乘客數: 4, 牌號: "TDG-1688", 時速: 80), 機車(牌號: "LKK-0057", 時速: 60), 機車(牌號: "AWJ-0020", 時速: 60), 汽車(最大乘客數: 3, 牌號: "TDZ-2096", 時速: 80), 汽車(最大乘客數: 5, 牌號: "TRT-4042", 時速: 70), 機車(牌號: "LMI-0009", 時速: 80), 直升機(牌號: "B-70331", 時速: 293), 汽車(最大乘客數: 5, 牌號: "TJU-2244", 時速: 60), 汽車(最大乘客數: 4, 牌號: "TTN-6433", 時速: 80), 汽車(最大乘客數: 4, 牌號: "THK-9005", 時速: 85), 機車(牌號: "PXP-2273", 時速: 55), 機車(牌號: "VOJ-3635", 時速: 80), 機車(牌號: "CDH-1960", 時速: 60), 汽車(最大乘客數: 3, 牌號: "TFJ-6039", 時速: 65), 汽車(最大乘客數: 3, 牌號: "TNK-0880", 時速: 85), 機車(牌號: "UUE-2080", 時速: 50), 機車(牌號: "VCE-8777", 時速: 75), 機車(牌號: "BBD-3494", 時速: 60), 汽車(最大乘客數: 6, 牌號: "TLZ-7005", 時速: 75), 汽車(最大乘客數: 4, 牌號: "TWE-5773", 時速: 60), 直升機(牌號: "B-70921", 時速: 301), 機車(牌號: "HHC-2069", 時速: 60), 機車(牌號: "ROW-4209", 時速: 65)])

print("""
目前可用載客車共 \(carManager.可用載客車.count) 台:
\(carManager.可用載客車.map { String(describing: $0) }.joined(separator: "、"))
-----------------------------------------
""")

carManager.派車(人數: 1, 客人距離: 10.9)
carManager.派車(人數: 5, 客人距離: 80.2)
carManager.派車(人數: 7, 客人距離: 5.3)
carManager.派車(人數: 2, 客人距離: 9.2)
carManager.派車(人數: 6, 客人距離: 2.1)
carManager.派車(人數: 2, 客人距離: 0.7)
carManager.派車(人數: 1, 客人距離: 18.5)
carManager.派車(人數: 4, 客人距離: 38.6)
carManager.派車(人數: 4, 客人距離: 7.3)
carManager.派車(人數: 1, 客人距離: 222)
