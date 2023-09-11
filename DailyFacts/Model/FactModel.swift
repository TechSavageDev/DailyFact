//
//  FactModel.swift
//  DailyFacts
//
//  Created by Genadi C on 11/08/2023.
//

import Foundation

class FactModel: Identifiable, Codable{
    var id: UUID
    var fact: String
    var category: String
    var source: String
    
    init(id: UUID = UUID(), fact: String, category: String, source: String) {
        self.id = id
        self.fact = fact
        self.category = category
        self.source = source
    }
}
