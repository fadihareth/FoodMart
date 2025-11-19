//
//  FoodItemService.swift
//  FoodMart
//
//  Created by Fadi Hareth on 2025-11-17.
//

import Foundation

protocol FoodItemServicing {
    func fetchFoodItems() async throws -> [FoodItem]
}

class FoodItemService: FoodItemServicing {
    func fetchFoodItems() async throws -> [FoodItem] {
        try await BaseService.request("food_items.json")
    }
}
