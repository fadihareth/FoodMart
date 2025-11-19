//
//  FoodItemView.swift
//  FoodMart
//
//  Created by Fadi Hareth on 2025-11-17.
//

import SwiftUI

struct FoodItemView: View {
    @State var viewModel: FoodListViewModel
    let item: FoodItem
    
    @State private var loaded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            RetryingAsyncImage(url: URL(string: item.image_url))
                .aspectRatio(1, contentMode: .fit)
                .clipped()
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 0) {
                Text("$\(item.price, specifier: "%.2f")")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text(item.name)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .accessibilityIdentifier("item.name")
                
                if let category = viewModel.getItemCategory(for: item) {
                    Text(category)
                        .font(.caption)
                }
            }
        }
    }
}
