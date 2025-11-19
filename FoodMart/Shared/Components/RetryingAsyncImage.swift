//
//  RetryingAsyncImage.swift
//  FoodMart
//
//  Created by Fadi Hareth on 2025-11-18.
//

import SwiftUI

/*
 AsyncImage with capability to retry fetching image if it fails
 
 NOTE: in a real project, using a third party package, such as KingFisher,
    would be more suitable for this use case
 */
struct RetryingAsyncImage: View {
    let url: URL?
    var retries: Int = 3
    var delay: Double = 0.5

    @State private var attempt = 0
    @State private var reloadID = UUID()

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()

            case .failure(_):
                Color.gray.opacity(0.2)
                    .onAppear {
                        if attempt < retries {
                            // Schedule retry
                            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                                attempt += 1
                                reloadID = UUID() // force AsyncImage to reload
                            }
                        }
                    }

            case .empty:
                Color.gray.opacity(0.2)

            @unknown default:
                Color.gray.opacity(0.2)
            }
        }
        .id(reloadID) // forces AsyncImage to restart loading
    }
}

