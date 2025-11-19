//
//  FoodListFiltersView.swift
//  FoodMart
//
//  Created by Fadi Hareth on 2025-11-17.
//

import SwiftUI

struct FoodListFiltersView: View {
    @State var viewModel: FoodListViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(viewModel.itemCategories) { category in
                    HStack {
                        Text(category.name)
                        Spacer()
                        Toggle("", isOn: Binding(
                            get: { viewModel.enabledCategoryFilters.contains(category.uuid) },
                            set: { isOn in
                                if isOn {
                                    viewModel.enabledCategoryFilters.insert(category.uuid)
                                } else {
                                    viewModel.enabledCategoryFilters.remove(category.uuid)
                                }
                            }
                        ))
                        .labelsHidden()
                        .accessibilityIdentifier("filter.toggle.\(category.name)")
                    }
                }
            }
            .padding(20)
            .getHeight($viewModel.filterMenuHeight)
        }
    }
}
