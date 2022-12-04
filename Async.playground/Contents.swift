import Foundation
import _Concurrency
import AppKit


// 使用async進行網路存取
let randomImageUrl = URL(string: "https://bing.ioliu.cn/v1/rand")!

func downloadImage() async throws -> NSImage {
    let (data, response) = try await URLSession.shared.data(from: randomImageUrl)
    guard let response =  response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
        fatalError()
    }
    return NSImage(data: data)!
}

//Task {
//    try! await downloadImage()
//}


// 理解async與await
let startTime = Date.now

func printElapsedTime(from: Date) {
    print(from)
    print(Date.now)
}

extension Task where Success == Never, Failure == Never {
    static func sleep(seconds: TimeInterval) async throws {
        try await Task.sleep(nanoseconds: UInt64(seconds * 1000000000))
    }
}

let totalWorkders = 20
var finishWorking = 0


func work(name: String) async throws {
    print("\(name) 1️⃣ 開始工作")
    try await Task.sleep(seconds: 2)
    Task {
        print("\(name) 2️⃣ 午休時間")
        try await Task.sleep(seconds: 1)
        print("\(name) 3️⃣ 睡飽了")
    }
    print("\(name) 4️⃣ 繼續工作")
    try await Task.sleep(seconds: 2)
    print("\(name) 5️⃣ 下班")
    await MainActor.run {
        finishWorking += 1
        print(finishWorking, Thread.current)
        if finishWorking == totalWorkders {
            printElapsedTime(from: startTime)
        }
    }
}

//for number in 1...totalWorkders {
//    Task {
//        try! await work(name: "員工 \(number) 號")
//    }
//}


// 筆記部分
/*
 只有在async當中才可以使用async相關功能，如果要在原始main中使用就需要透過
 Task構建出一個可以使用async的空間，在這裡面就可以呼叫使用async標籤的函數
 呼叫帶有async標籤的函數就會需要在前面加上await
 await表示的是，這個函數有可能中途會被暫停，也有可能不會被暫停，這裡沒辦法
 保證是否會被暫停，在這裡的示範程式碼就是在sleep時會被系統認定成不需要使用
 計算能力，所以先被放到其他地方但是sleep的時間依舊有在計算，此時系統會去找
 有沒有其他可以執行的async函數
 await也可以解釋成，告訴系統這裡可以暫停，由系統自動分配資源
 被加上await的地方沒辦法確定何時會有結果，所以當資料回傳後需要重新判斷當前
 系統狀況
*/


// async let

struct People: CustomStringConvertible {
    var name: String
    var score: Int
    
    var description: String {
        "Name: \(name), Score: \(score)"
    }
}

func fetchData() async -> People {
    let startTime = Date.now
    // async let表示這裡會由系統自動分配資源調用函數
    // 這裡一定是let沒有var這個選項，因為一但指定就不能更改
    async let name = fetchUserName()
    async let score = fetchUserScore()
    
    // 使用var或是let配合await來表示，我現在需要這個值了
    // 這樣就會強制卡在這裡，直到獲取到值才會往下
    var userName = await name
    var userScore = await score
    
    printElapsedTime(from: startTime)
    return People(name: userName, score: userScore)
}

func fetchUserName() async -> String {
    try! await Task.sleep(seconds: 1)
    return "Chris"
}

func fetchUserScore() async -> Int {
    try! await Task.sleep(seconds: 1)
    return 100
}

//Task {
//    var t = await fetchData()
//    print(t)
//}

// withTaskGroup

struct User: CustomStringConvertible {
    var name: String
    var height: Int
    var description: String {
        "Name: \(name), Height: \(height)"
    }
}

func fetchUser(id: Int) async -> User {
    try! await Task.sleep(seconds: 1)
    let names = ["Chris", "Kevin", "Jane"]
    let heights = [163, 165, 161]
    return User(name: names[id - 1], height: heights[id - 1])
}

func fetch(userIDs: [Int]) async -> [User] {
    await withTaskGroup(of: (index: Int, user: User).self, returning: [User].self) { group in
        for id in userIDs {
            group.addTask {
                (id - 1, await fetchUser(id: id))
            }
        }
        var users = Array(repeating: User?.none, count: userIDs.count)
        for await results in group {
            users[results.index] = results.user
        }
        return users.compactMap { $0 }
    }
}

func fetchFull(userIDs: [Int]) async -> [User] {
    await withTaskGroup(of: (index: Int, user: User).self, returning: [User].self, body: ({(group) -> [User] in
        for id in userIDs {
            group.addTask {
                (id - 1, await fetchUser(id: id))
            }
        }
        var users = Array(repeating: User?.none, count: userIDs.count)
        for await results in group {
            users[results.index] = results.user
        }
        return users.compactMap { $0 }
    }))
}

//Task {
//    var users: [User] = await fetchFull(userIDs: [1, 2, 3])
//    print(users)
//}

// Task的取消，也就是中斷Task當正在執行的內容
enum CookError: Error {
    case 切到手
}

func 切菜(切到手: Bool) async throws {
    print("切菜")
    try await Task.sleep(seconds: 1)
    if 切到手 {
        print("我切到手了，馬上去醫院")
        throw CookError.切到手
    }
}

@discardableResult
func 煮飯() async throws -> String {
    print("正在煮飯...")
    try await Task.sleep(seconds: 2)
    print("🍚煮好了")
    return "🍚"
}

@discardableResult
func 蒸魚() async throws -> String {
    print("正在蒸魚...")
    try await Task.sleep(seconds: 2)
    print("🐟蒸好了")
    return "🐟"
}

@discardableResult
func 炒菜() async throws -> String {
    print("正在炒菜...")
    try await Task.sleep(seconds: 1)
    print("🥗炒好了")
    return "🥗"
}

func asyncCooking(切到手: Bool) async {
    async let rice = 煮飯()
    async let fish = 蒸魚()
    do {
        try await 切菜(切到手: 切到手)
        let vegetable = try await 炒菜()
        print("上菜了 \(vegetable) \(try await rice) \(try await fish)")
    } catch {
        print("停止煮飯，原因: \(error)")
    }
}

func taskCooking(切到手: Bool) {
    var dishes = ""
    let callback = { @MainActor (dish: String) -> Void in
        dishes += dish
        if dishes.count == 3 {
            print("上菜了\(dishes)")
        }
    }
    let rice = Task {
        do {
            let riceResult = try await 煮飯()
            await callback(riceResult)
        } catch {
            print("停止煮飯，原因: \(error)")
        }
    }
    let fish = Task {
        do {
            let fishResult = try await 蒸魚()
            await callback(fishResult)
        } catch {
            print("停止蒸魚，原因: \(error)")
        }
    }
    Task {
        do {
            try await 切菜(切到手: 切到手)
            let vegetableResult = try await 炒菜()
            await callback(vegetableResult)
        } catch {
            print("停止切菜，原因: \(error)")
            rice.cancel()
            fish.cancel()
        }
    }
}

func taskCookingTask(切到手: Bool) async {
    let rice = Task { try await 煮飯() }
    let fish = Task { try await 蒸魚() }
    let vegetable = Task { () -> String in
        try await 切菜(切到手: 切到手)
        return try await 炒菜()
    }
    do {
        print("上菜了 \(try await vegetable.value) \(try await rice.value) \(try await fish.value)")
    } catch CookError.切到手 {
        rice.cancel()
        fish.cancel()
        print("取消煮飯和蒸魚")
    } catch {
        print("無法完成晚餐")
    }
}

//Task {
//    await asyncCooking(切到手: true)
//    await taskCookingTask(切到手: true)
//}
//taskCooking(切到手: false)


// 取消任務的時間點

@Sendable
func doingSomethingBusy() throws {
    let startTime = Date.now
    try Task.checkCancellation()
    (1...400).reduce(0) {
        $0 + (1...$1).reduce(0, +)
    }
    try Task.checkCancellation()
}

Task {
    await withThrowingTaskGroup(of: Void.self) { group in
        group.addTask(operation: doingSomethingBusy)
        group.addTask(operation: doingSomethingBusy)
        group.cancelAll()
    }
}
