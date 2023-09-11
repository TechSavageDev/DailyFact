//
//  UserData.swift
//  DailyFacts
//
//  Created by Genadi C on 19/08/2023.
//

import Foundation

struct UserData: Codable{
    var fullname: String
    var email: String
    var gender: String
    var age: String
    var image: URL
}
