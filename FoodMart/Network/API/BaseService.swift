//
//  BaseService.swift
//  FoodMart
//
//  Created by Fadi Hareth on 2025-11-17.
//

import Foundation

struct BaseService {
    static let baseUrl = URL(string: "https://7shifts.github.io/mobile-takehome/api/")!
    
    static func request<T: Decodable>(_ path: String) async throws -> T {
        let url = baseUrl.appendingPathComponent(path)
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let http = response as? HTTPURLResponse, 200..<300 ~= http.statusCode else {
            throw APIError.fetchError
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.fetchError
        }
    }
}
