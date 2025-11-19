//
//  FoodListViewModelTests.swift
//  FoodMartTests
//
//  Created by Fadi Hareth on 2025-11-18.
//

import XCTest
@testable import FoodMart

final class FoodItemServiceMock: FoodItemServicing {
    var itemsToReturn: [FoodItem] = []
    
    func fetchFoodItems() async throws -> [FoodItem] {
        return itemsToReturn
    }
}

final class FoodItemCategoryServiceMock: FoodItemCategoryServicing {
    var categoriesToReturn: [FoodItemCategory] = []
    
    func fetchFoodItemCategories() async throws -> [FoodItemCategory] {
        return categoriesToReturn
    }
}

final class FailingItemServiceMock: FoodItemServicing {
    func fetchFoodItems() async throws -> [FoodItem] {
        throw APIError.fetchError
    }
}

final class FailingCategoryServiceMock: FoodItemCategoryServicing {
    func fetchFoodItemCategories() async throws -> [FoodItemCategory] {
        throw APIError.fetchError
    }
}

@MainActor
final class FoodListViewModelTests: XCTestCase {
    func test_load_success() async {
        let itemMock = FoodItemServiceMock()
        let categoryMock = FoodItemCategoryServiceMock()
        
        itemMock.itemsToReturn = [
            FoodItem(uuid: "i1", name: "Item 1", price: 0.99, category_uuid: "c1", image_url: "")
        ]
        
        categoryMock.categoriesToReturn = [
            FoodItemCategory(uuid: "c1", name: "Category 1")
        ]
        
        let viewModel = FoodListViewModel(
            itemService: itemMock,
            categoryService: categoryMock
        )
        
        await viewModel.load()

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.error)
        XCTAssertEqual(viewModel.items.count, 1)
        XCTAssertEqual(viewModel.itemCategories.count, 1)
        XCTAssertEqual(viewModel.itemCategoriesById["c1"]?.name, "Category 1")
    }
    
    func test_load_failure() async {
        let itemMock = FailingItemServiceMock()
        let categoryMock = FailingCategoryServiceMock()

        let viewModel = FoodListViewModel(
            itemService: itemMock,
            categoryService: categoryMock
        )

        await viewModel.load()

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.error)
        XCTAssertTrue(viewModel.items.isEmpty)
        XCTAssertTrue(viewModel.itemCategories.isEmpty)
    }
    
    func test_getFilteredItems_filter_by_category() async {
        let itemMock = FoodItemServiceMock()
        let categoryMock = FoodItemCategoryServiceMock()

        itemMock.itemsToReturn = [
            FoodItem(uuid: "i1", name: "Pizza", price: 10, category_uuid: "c1", image_url: ""),
            FoodItem(uuid: "i2", name: "Salad", price:  5, category_uuid: "c2", image_url: ""),
            FoodItem(uuid: "i3", name: "Pasta", price: 12, category_uuid: "c1", image_url: "")
        ]

        categoryMock.categoriesToReturn = [
            FoodItemCategory(uuid: "c1", name: "Mains"),
            FoodItemCategory(uuid: "c2", name: "Sides")
        ]

        let viewModel = FoodListViewModel(
            itemService: itemMock,
            categoryService: categoryMock
        )

        await viewModel.load()

        // No filter
        XCTAssertEqual(viewModel.getFilteredItems().count, 3)

        // Filter c1
        viewModel.enabledCategoryFilters = ["c1"]
        XCTAssertEqual(viewModel.getFilteredItems().count, 2)
        XCTAssertEqual(viewModel.getFilteredItems().map { $0.name }, ["Pizza", "Pasta"])

        // Filter c2
        viewModel.enabledCategoryFilters = ["c2"]
        XCTAssertEqual(viewModel.getFilteredItems().count, 1)
        XCTAssertEqual(viewModel.getFilteredItems().map { $0.name }, ["Salad"])
    }
    
    func test_getFilteredItems_filter_by_multiple_categories() async {
        let itemMock = FoodItemServiceMock()
        let categoryMock = FoodItemCategoryServiceMock()

        itemMock.itemsToReturn = [
            FoodItem(uuid: "i1", name: "Pizza", price: 10, category_uuid: "c1", image_url: ""),
            FoodItem(uuid: "i2", name: "Salad", price:  5, category_uuid: "c2", image_url: ""),
            FoodItem(uuid: "i3", name: "Bread", price:  2, category_uuid: "c3", image_url: "")
        ]

        categoryMock.categoriesToReturn = [
            FoodItemCategory(uuid: "c1", name: "Mains"),
            FoodItemCategory(uuid: "c2", name: "Sides"),
            FoodItemCategory(uuid: "c3", name: "Bakery")
        ]

        let viewModel = FoodListViewModel(
            itemService: itemMock,
            categoryService: categoryMock
        )

        await viewModel.load()

        // No filter
        XCTAssertEqual(viewModel.getFilteredItems().count, 3)

        // Filter c1 + c2
        viewModel.enabledCategoryFilters = ["c1", "c2"]
        XCTAssertEqual(viewModel.getFilteredItems().count, 2)
        XCTAssertEqual(viewModel.getFilteredItems().map { $0.name }, ["Pizza", "Salad"])

        // Filter c1 + c3
        viewModel.enabledCategoryFilters = ["c1", "c3"]
        XCTAssertEqual(viewModel.getFilteredItems().count, 2)
        XCTAssertEqual(viewModel.getFilteredItems().map { $0.name }, ["Pizza", "Bread"])
        
        // Filter c1 + c2 + c3
        viewModel.enabledCategoryFilters = ["c1", "c2", "c3"]
        XCTAssertEqual(viewModel.getFilteredItems().count, 3)
    }
    
    func test_getItemCategory_returns_name() async {
        let itemMock = FoodItemServiceMock()
        let categoryMock = FoodItemCategoryServiceMock()

        itemMock.itemsToReturn = [
            FoodItem(uuid: "i1", name: "Soup", price: 4, category_uuid: "c1", image_url: "")
        ]
        categoryMock.categoriesToReturn = [
            FoodItemCategory(uuid: "c1", name: "Starters")
        ]

        let viewModel = FoodListViewModel(
            itemService: itemMock,
            categoryService: categoryMock
        )

        await viewModel.load()

        let item = viewModel.items.first!
        XCTAssertEqual(viewModel.getItemCategory(for: item), "Starters")
    }
}

