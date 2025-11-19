//
//  FoodListViewModel.swift
//  FoodMart
//
//  Created by Fadi Hareth on 2025-11-17.
//

import Foundation

@Observable
class FoodListViewModel {
    var items: [FoodItem] = []
    var itemCategories: [FoodItemCategory] = []
    // Used for category lookup
    var itemCategoriesById: [String : FoodItemCategory] = [:]
    
    var isLoading: Bool = false
    var error: String? = nil
    
    var filterMenuOpened: Bool = false
    var enabledCategoryFilters: Set<String> = []
    var filterMenuHeight: CGFloat = 100
    
    private let itemService: FoodItemServicing
    private let categoryService: FoodItemCategoryServicing
    
    // FOR UI TESTS ONLY
    private var hasForcedErrorOnce: Bool = false
    
    init(
        itemService: FoodItemServicing = FoodItemService(),
        categoryService: FoodItemCategoryServicing = FoodItemCategoryService()
    ) {
        self.itemService = itemService
        self.categoryService = categoryService
    }
    
    func load() async {
        self.isLoading = true
        defer { isLoading = false }
        
        // TEST HOOK - only used for UI Tests
        if ProcessInfo.processInfo.arguments.contains("--force-error-view"), !self.hasForcedErrorOnce {
            self.error = "Something went wrong."
            self.hasForcedErrorOnce = true
            return
        }
        
        do {
            self.items = try await itemService.fetchFoodItems()
            self.itemCategories = try await categoryService.fetchFoodItemCategories()
            self.itemCategories.sort()
            self.itemCategoriesById = Dictionary(
                self.itemCategories.map { ($0.uuid, $0) },
                uniquingKeysWith: { first, _ in first }
            )
            self.error = nil
        } catch {
            self.error = error.localizedDescription
        }
    }
    
    func getFilteredItems() -> [FoodItem] {
        // No filters, return all items
        if self.enabledCategoryFilters.isEmpty {
            return items
        }
        
        // Filters items by category
        return items.filter { item in
            enabledCategoryFilters.contains(item.category_uuid)
        }
    }
    
    // Returns category name for given item
    func getItemCategory(for item: FoodItem) -> String? {
        return self.itemCategoriesById[item.category_uuid]?.name
    }
}
