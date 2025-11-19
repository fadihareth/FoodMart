//
//  ErrorView.swift
//  FoodMart
//
//  Created by Fadi Hareth on 2025-11-17.
//

import SwiftUI

struct ErrorView: View {
    let errorMessage: String
    let action: () async -> Void
    var isLoading: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("Oops...")
                .font(.title)
            Text(errorMessage)
            Spacer()
            Button("Retry", action: {
                Task {
                    await action()
                }
            })
            .disabled(isLoading)
        }
        .padding()
    }
}
