// OS_ACTIVITY_MDOE disable

//func applyTabBarBackground() {
//    let tabBarAppearance = UITabBarAppearance()
//    tabBarAppearance.configureWithTransparentBackground()
//    tabBarAppearance.backgroundColor = .secondarySystemBackground.withAlphaComponent(0.3)
//    tabBarAppearance.backgroundEffect = UIBlurEffect(style: .systemChromeMaterial)
//    UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
//}

import Foundation
import SwiftUI

//let internetData: Data = Data("""
//{
//"first_name": "Huang",
//"last_name": "Hong-Yan"
//}
//""".utf8)
//
//struct Person {
//    var firstName: String
//    var lastName: String
//}
//
//extension Person: Decodable {
//    enum CodingKeys: String, CodingKey {
//        case firstName = "first_name"
//        case lastName = "last_name"
//    }
//}
//
//let person = try! JSONDecoder().decode(Person.self, from: internetData)
//print(person)

//let internetData: Data = Data("""
//{
//"status": 200,
//"quota": 100,
//"response": [
//{"id": 13, "first_name": "Huang", "last_name": "Hong-Yan"},
//{"id": 15, "first_name": "Chang", "last_name": "Yo-Tan"}
//]
//}
//""".utf8)
//
//struct Response {
//    let status: Int
//    let quota: Int
//    let response: [User]
//}
//
//extension Response: Decodable { }
//
//struct User {
//    let id: Int
//    let firstName: String
//    let lastName: String
//}
//
//extension User: Decodable {
//    enum CodingKeys: String, CodingKey {
//        case id
//        case firstName = "first_name"
//        case lastName = "last_name"
//    }
//}
//
//let response = try! JSONDecoder().decode(Response.self, from: internetData)
//print(response)

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
print(response)
