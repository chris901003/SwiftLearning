import UIKit

var number = Optional<Int>.none
//number = 10

switch number {
    case .none:
        print("No value")
    case .some(_):
        print("Value is \(number!)")
}

if let number = number {
    print("Value is \(number)")
} else {
    print("No value")
}

func greeting(_ number: Optional<Int>) {
    guard let number = number else {
        print(number ?? -1)
        return
    }
    print("Value is \(number)")
}
greeting(number)

struct 個人檔案 {
    let 名稱: String
    let 電話: String?
}

let profile: [個人檔案?] = [.init(名稱: "Jane", 電話: nil), nil, .init(名稱: "Sandy", 電話: "098712345678")]
let phone = profile.map({$0?.電話})
let phone2 = profile.compactMap({$0?.電話})
let phone3 = profile.map {(資料: 個人檔案?) -> String? in
    return 資料?.電話
}
print(phone)
print(phone2)
print(phone3)
