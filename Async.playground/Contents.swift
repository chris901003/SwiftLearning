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

Task {
    var users: [User] = await fetchFull(userIDs: [1, 2, 3])
    print(users)
}
