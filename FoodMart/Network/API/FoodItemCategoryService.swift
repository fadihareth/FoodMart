//
//  FoodItemCategoryService.swift
//  FoodMart
//
//  Created by Fadi Hareth on 2025-11-17.
//

import Foundation

protocol FoodItemCategoryServicing {
    func fetchFoodItemCategories() async throws -> [FoodItemCategory]
}

class FoodItemCategoryService: FoodItemCategoryServicing {
    func fetchFoodItemCategories() async throws -> [FoodItemCategory] {
        try await BaseService.request("food_item_categories.json")
    }
}
