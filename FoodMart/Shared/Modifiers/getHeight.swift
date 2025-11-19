//
//  getHeight.swift
//  FoodMart
//
//  Created by Fadi Hareth on 2025-11-18.
//

import SwiftUI

// Calculates and stores view's height

extension View {
    func getHeight(_ height: Binding<CGFloat>) -> some View {
        self.modifier(MeasuredModifier(height: height))
    }
}

struct MeasuredModifier: ViewModifier {
    @Binding var height: CGFloat

    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geo in
                    Color.clear
                        .preference(key: HeightKey.self, value: geo.size.height)
                }
            )
            .onPreferenceChange(HeightKey.self) { height = $0 }
    }
}

struct HeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}
