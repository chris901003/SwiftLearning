# Swift

## Protocal

### Sendable
**跟編譯器說此部分不用擔心同步問題**\
**主要一個變數在函數中傳遞時的同步問題**\
只要是Value Type的資料原先都會直接符合Sendable，因為Value Type本身在函數傳遞變數時都會透過複製一份，所以不同函數中的資料是獨立的，由此就不會有同步問題。
如果是Reference Type的資料在傳遞時就會有同步問題，此時編譯器會阻止我們有這類的操作，例如我們要將一個class的資料進行傳遞時就會直接報錯，此時我們可以將此class遵守Sendable，但是編譯器仍就會報錯，因為在swift當中class是不會保證thread safty的，若需要保證thread safty需要我們自行設計lock才可以，若要強制遵守sendable需要在前面加上@unchecked就可以告訴編譯器我們自行處理完畢。
```swift=
class Person: Sendable {
    let name: String
    init(name: String) { self.name = name }
}
/*
Person目前是可以直接遵守Sendable，因為在class當中的所有變數為不可更改，這時就會保證Thread safty
*/
```
```swift=
class Person: @unchecked Sendable {
    // 指定讀取以及更改時的Thread
    let queue = DispathQueue(label: "feel free")
    
    var name: String
    init(name: String) { self.name = name }
    
    func updateName(name: String) {
        // 轉移到指定Thread
        queue.async {
            self.name = name
        }
    }
}
/*
Person目前就無法遵守Sendable因為當中的name可能在不同thread中被更改
所以若要達成Sendable我們可以將所有操作都強制在某個Thread上進行
*/
```
在Swift6以後即時class已經遵守Sendable，在函數中有使用到此變數依舊會報錯，此時我們只需要將func前加上@Sendable就可以，主要是要提醒自己這樣傳遞可能會有同步問題
但我發現似乎不用讓class遵守Sendable也是可以傳遞
```swift=
class Person {
    var name: String
    init(name: String) { self.name = name }
}

@Sendable
func updateName(person: Person, newName: String) {
    person.name = newName
}
```
---
### Decodable
**接收來自網路的茲料**\
我們直接透過程式碼來說明不同情況的處理方式\
命名習慣不同，在swift中我們習慣使用小駝峰命名法，但是在資料庫中大多使用蛇行命名
此時我們可以透過遵守RawRepresentable的CodingKey來轉換
```swift=
let internetData: Data = Data("""
{
"first_name": "Huang",
"last_name": "Hong-Yan"
}
""".utf8)
struct Person {
    var firstName: String
    var lastName: String
}
extension Person: Decodable {
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
let person = try! JSONDecoder().decode(Person.self, from: internetData)
```
巢狀資料，透過多層struct進行解析，基本概念與一層資料相同
```swift=
let internetData: Data = Data("""
{
"status": 200,
"quota": 100,
"response": [
{"id": 13, "first_name": "Huang", "last_name": "Hong-Yan"},
{"id": 15, "first_name": "Chang", "last_name": "Yo-Tan"}
]
}
""".utf8)

struct Response {
    let status: Int
    let quota: Int
    let response: [User]
}
extension Response: Decodable { }
struct User {
    let id: Int
    let firstName: String
    let lastName: String
}
extension User: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
let response = try! JSONDecoder().decode(Response.self, from: internetData)
```
巢狀資料但是不想要多開一個struct來解碼\
在解碼過程中可以轉成array的方式進行解碼\
這裡示範的是在value中有array[dict]的資料結構
```swift=
let internetData: Data = Data("""
{
"status": 200,
"quota": 100,
"response": [
{"id": 13, "first_name": "Huang", "last_name": "Hong-Yan"},
{"id": 15, "first_name": "Chang", "last_name": "Yo-Tan"}
]
}
""".utf8)
struct Response {
    let status: Int
    let quota: Int
    let ids: [Int]
    let names: [String]
}
extension Response: Decodable {
    enum CodingKeys: String, CodingKey {
        case status, quota, ids, names, response, id
        case firstName = "first_name"
        case lastName = "last_name"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try container.decode(Int.self, forKey: .status)
        self.quota = try container.decode(Int.self, forKey: .quota)
        var responseContainer = try container.nestedUnkeyedContainer(forKey: .response)
        var fetchIds: [Int] = []
        var fetchNames: [String] = []
        while !responseContainer.isAtEnd {
            let userContainer = try responseContainer.nestedContainer(keyedBy: CodingKeys.self)
            let id = try userContainer.decode(Int.self, forKey: .id)
            let firstName = try userContainer.decode(String.self, forKey: .firstName)
            let lastName = try userContainer.decode(String.self, forKey: .lastName)
            fetchIds.append(id)
            fetchNames.append(firstName + " " + lastName)
        }
        self.ids = fetchIds
        self.names = fetchNames
    }
}
let response = try! JSONDecoder().decode(Response.self, from: internetData)
```
巢狀資料但是不想要多開一個struct來解碼\
在解碼過程中可以轉成array的方式進行解碼\
這裡示範的是在value中有dict的資料結構
```swift=
let internetData: Data = Data("""
{
"status": 200,
"quota": 100,
"response": {"id": 13, "first_name": "Huang", "last_name": "Hong-Yan"}
}
""".utf8)

struct Response {
    let status: Int
    let quota: Int
    let id: Int
    let name: String
}

extension Response: Decodable {
    enum CodingKeys: String, CodingKey {
        case status, quota, name, response, id
        case firstName = "first_name"
        case lastName = "last_name"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try container.decode(Int.self, forKey: .status)
        self.quota = try container.decode(Int.self, forKey: .quota)
        var responseContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .response)
        self.id = try responseContainer.decode(Int.self, forKey: .id)
        let firstName = try responseContainer.decode(String.self, forKey: .firstName)
        let lastName = try responseContainer.decode(String.self, forKey: .lastName)
        self.name = firstName + " " + lastName
    }
}

let response = try! JSONDecoder().decode(Response.self, from: internetData)
```
---
### URL + URLRequest + URLSession
**與網路獲取資料相關**\
雖然URL並不是只能從網路中獲取資料，但是我這邊先介紹與網路相關的方法\
首先需要了解的是URL是一種struct，在我們使用以下程式碼時swift會嘗試將傳入的string變成URL這個struct
```swift=
let url = URL(string: "https://google.com")
```
此時你會發現url的類型其實是optional的URL，也就是代表這個轉換會失敗，那失敗的可能會是有不合法的字串，例如在網址當中不會有空格鍵，所以如果string的地方輸入有空白鍵的字串就會啟動失敗。\
當我們有URL時會發現其實我們啥都不能做(就挺廢的)\
接下來要了解URLRequest與URLSession之間的關係，如果以發送包裹來形容，URLRequest就是裡面的物品，URLSession就是箱子。\
也就是所有請求相關的詳細資訊都會放在URLRequest當中，例如最重要的URL以及GET或是POST時的參數都是放在URLRequest當中，所以就可以發現URLSession只是個包裝，但他還是有他的功用，後面會提到。\
那我們就先來看看要怎麼使用URLRequest
```swift=
// 此為最基本的使用方式
let urlRequest = URLRequest(url: url)
```
**之後再來補充比較複雜的URLRequest**\
接下來就是URLSession部分，swift當中已經有一個share的版本
```swift=
let session = URLSession.shared
```
(以下我將URLSession簡稱為session)\
這個session的版本是共用的，在session當中會有[default, ephemeral, background]三種模式可以選擇分別會是[無痕, 有記錄的, 可在切換到其他APP時持續下載]，shared的版本就會是無痕的，畢竟我們不會希望共用的session會保存紀錄，就像是我們不會希望家裡的路由器會記錄下我們的瀏覽紀錄。\
session的使用方式也很簡單
```swift=
let request = URLRequest(url: URL("https://google.com")!)
let (data, response) = try await session.data(for: request)
// data = 從網路回傳的二進制檔案
// response = 服務器帶的資料，包括status code
```
那如果我們希望是有cache的版本就會需要自行創建URLSession\
在使用cache時也有四種不同的類型
1. 根據服務器規範使用cache
2. 無論有沒有cache直接下載
3. 直接使用cache，若沒有cache報錯
4. 直接使用cache，沒有cache下載

通常我們使用1或2，3跟4主要是在可能斷網或是網路不足時使用，以下我們就使用1來操作\
在使用cache時要重點注意資料是否為最新的狀態
```swift=
extension URLSession {
    static let imageSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.urlCache = .imageCache
        return .init(configuration: config)
    }()
}
extension URLCache {
    static let imageCache: URLCache = {
        .init(memoryCapacity: 20 * 1024 * 1024,
              diskCapacity: 30 * 1024 * 1024)
    }()
}
// 此session就會有cache的功能
let session = URLSession.imageSession

// 檢查在cache中是否有資料(urlRequest是一個URLRequest類型)
let data = session.configuration.urlCache?.cachedResponse(for: urlRequest)?.data
```

---
# SwiftUI

## Protocal

### PreferenceKey
**可將資料從下層的View網上層的View傳遞**\
當我們需要子View的資料顯示在父View上時可以使用，例如我們想要sheet的高度剛好是顯示所需的大小。\
此時我們需要從子View傳遞高度資料給父View才可以限制sheet的高度\
首先我們需要一個遵守PreferenceKey的struct
```swift=
struct SheetSizePreference: PreferenceKey {
    // 預設值
    // 此preferenceKey中我們存的資料為CGFloat，如果有其他需求可以使用其他資料類型
    static var defaultValue: CGFloat = 300

    // 當往上傳遞時有新的設定值的時候要如何更新
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        // 直接以上層View的新資料為主
        value = nextValue()
        // 比較誰的值比較大作為新的值
        // value = max(value, nextValue())
    }
}
```
接下來就是要如何設定此preference value\
只需要使用preference這個調整器(不一定要用在VStack上，任何一個View都可以)\
key的地方就是自定義的struct名稱的類型\
value就是設定值，可以是個變數
```swift=
VStack {
    
}
.preference(key: AllRepositoryView.SheetSizePreference.self, value: 100)
```
最後就是接收更新，在上層的View需要接收下層更新preference value
```swift=
VStack {
    
}
.onPreferenceChange(SheetSizePreference.self) { sheetViewSize = $0 }
```
最後需要注意部分就是，由於是從子畫面更改父畫面，所以有可能發生父畫面更新後子畫面又需要被更新，這樣就會導致無限巡迴變成無法控制的狀態，所以這部分要很清楚父畫面的更新不會導致子畫面更新這件事情不斷重複。

---
# 待完成
### ViewBuilder