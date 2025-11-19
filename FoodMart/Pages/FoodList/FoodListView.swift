//
//  FoodListView.swift
//  FoodMart
//
//  Created by Fadi Hareth on 2025-11-17.
//

import SwiftUI

struct FoodListView: View {
    @State var viewModel = FoodListViewModel()
    
    private let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    var body: some View {
        Group {
            if let error = viewModel.error {
                ErrorView(errorMessage: error, action: viewModel.load)
            } else {
                VStack(spacing: 10) {
                    HStack(alignment: .bottom) {
                        Text("Food")
                            .font(.title)
                            .fontWeight(.semibold)
                        Spacer()
                        Button("Filter", action: {
                            viewModel.filterMenuOpened.toggle()
                        })
                        .padding(.trailing)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(viewModel.getFilteredItems()) { item in
                                FoodItemView(viewModel: viewModel, item: item)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                    }
                }
            }
        }
        .task {
            await viewModel.load()
        }
        .overlay {
            LoadingOverlay(isLoading: $viewModel.isLoading)
        }
        .sheet(isPresented: $viewModel.filterMenuOpened) {
            FoodListFiltersView(viewModel: viewModel)
                .presentationDetents([.height(min(viewModel.filterMenuHeight, 450)), .large])
        }
    }
}

#Preview {
    FoodListView()
}
