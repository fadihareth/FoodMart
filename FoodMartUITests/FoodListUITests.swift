//
//  FoodListUITests.swift
//  FoodMartUITests
//
//  Created by Fadi Hareth on 2025-11-18.
//

import XCTest

final class FoodListUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func test_header_and_filter_sheet_present() throws {
        // Assert header "Food" exists
        let header = app.staticTexts["Food"]
        XCTAssertTrue(header.waitForExistence(timeout: 3), "Header 'Food' should appear")

        // Filter button should exist
        let filterButton = app.buttons["Filter"]
        XCTAssertTrue(filterButton.exists, "Filter button should exist and be visible")

        // Tap filter and ensure sheet appears
        XCTAssertFalse(app.sheets.element.exists, "Sheet should not be present before tapping")
        filterButton.tap()
        
        let predicate = NSPredicate(format: "identifier BEGINSWITH 'filter.toggle.'")
        let togglesQuery = app.switches.matching(predicate)
        XCTAssertTrue(togglesQuery.count > 0, "At least one filter toggle should be visible")
        
        // Dismiss sheet
        app.windows.element(boundBy: 0).tap()
        XCTAssertFalse(app.sheets.element.exists, "Sheet should not be present after dismissing")
    }
    
    func test_filter_by_category() throws {
        // Tap filter and query all toggles
        app.buttons["Filter"].tap()
        let predicate = NSPredicate(format: "identifier BEGINSWITH 'filter.toggle.'")
        let togglesQuery = app.switches.matching(predicate)
        
        // Tap first toggle to apply a filter and record first food item name
        let firstToggle = togglesQuery.firstMatch
        XCTAssertTrue(firstToggle.exists, "First toggle should be present")
        firstToggle.tap()
        let filter1ItemName = app.staticTexts["item.name"].firstMatch.label
        firstToggle.tap()
        
        // Untap toggle, tap second toggle to apply another filter and record first food item name
        let secondToggle = togglesQuery.element(boundBy: 1)
        XCTAssertTrue(secondToggle.exists, "Second toggle should be present")
        secondToggle.tap()
        let filter2ItemName = app.staticTexts["item.name"].firstMatch.label
        secondToggle.tap()
        
        // Ensure that filter worked
        XCTAssertNotEqual(filter1ItemName, filter2ItemName)
    }
}

