//
//  FoodItem.swift
//  FoodMart
//
//  Created by Fadi Hareth on 2025-11-17.
//

import Foundation

class FoodItem: Identifiable, Codable {
    let uuid: String
    var id: String { uuid }
    
    let name: String
    let price: Double
    let category_uuid: String
    let image_url: String
    
    init(uuid: String, name: String, price: Double, category_uuid: String, image_url: String) {
        self.uuid = uuid
        self.name = name
        self.price = price
        self.category_uuid = category_uuid
        self.image_url = image_url
    }
}
