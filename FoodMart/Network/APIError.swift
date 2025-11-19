//
//  APIError.swift
//  FoodMart
//
//  Created by Fadi Hareth on 2025-11-17.
//

import Foundation

enum APIError: Error, LocalizedError {
    case fetchError

    var errorDescription: String? {
        switch self {
        case .fetchError:
            return "Something went wrong."
        }
    }
}
