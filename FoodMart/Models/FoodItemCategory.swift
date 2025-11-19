//
//  FoodItemCategory.swift
//  FoodMart
//
//  Created by Fadi Hareth on 2025-11-17.
//

import Foundation

class FoodItemCategory: Identifiable, Codable, Equatable, Hashable, Comparable {
    static func < (lhs: FoodItemCategory, rhs: FoodItemCategory) -> Bool {
        lhs.name < rhs.name
    }
    
    static func == (lhs: FoodItemCategory, rhs: FoodItemCategory) -> Bool {
        lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
    let uuid: String
    var id: String { uuid }
    
    let name: String
    
    init(uuid: String, name: String) {
        self.uuid = uuid
        self.name = name
    }
}
