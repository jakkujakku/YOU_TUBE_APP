//
//  AuthService.swift
//  YOU_TUBE
//
//  Created by (^ㅗ^)7 iMac on 2023/09/04.
//

import Foundation

class AuthService {
    static var shared = [String: UserInfo]()
    static let userDefaults = UserDefaults.standard
    static let userDafaultsKey = "userDafaultsKey"

    private init() {}

    func saveData() {}

    func loadData() {}

    func updateData() {}

    func deleteData() {}
}

struct UserInfo: Codable {
    var name: String
    var email: String
    var password: String
}
