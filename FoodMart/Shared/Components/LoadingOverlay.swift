//
//  LoadingOverlay.swift
//  FoodMart
//
//  Created by Fadi Hareth on 2025-11-17.
//

import SwiftUI

struct LoadingOverlay: View {
    @Binding var isLoading: Bool
    
    var body: some View {
        if isLoading {
            ProgressView()
                .padding(50)
                .background(.regularMaterial)
                .cornerRadius(10)
        }
    }
}
