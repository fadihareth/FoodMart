//
//  ErrorViewUITests.swift
//  FoodMartUITests
//
//  Created by Fadi Hareth on 2025-11-18.
//

import XCTest

final class ErrorViewUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--force-error-view")
        app.launch()
    }
    
    func test_error_view_present() throws {
        // Assert error view is displayed
        let errorHeader = app.staticTexts["Oops..."]
        XCTAssertTrue(errorHeader.waitForExistence(timeout: 3), "Error header should appear")
        
        let errorMessage = app.staticTexts["Something went wrong."]
        XCTAssertTrue(errorMessage.waitForExistence(timeout: 3), "Error message should appear")
    }
    
    func test_retry_load() throws {
        // Assert retry button is displayed
        let retryButton = app.buttons["Retry"]
        XCTAssertTrue(retryButton.waitForExistence(timeout: 3), "Retry button should be visible")
        
        // Tap retry button and ensure error view is no longer displayed
        retryButton.tap()
        let foodHeader = app.staticTexts["Food"]
        XCTAssertTrue(foodHeader.waitForExistence(timeout: 5), "Main page header should appear")
        XCTAssertFalse(retryButton.exists, "Retry button should not be visible after error disappears")
    }
}
