//
//  TabBarItem.swift
//  DailyFacts
//
//  Created by Genadi C on 10/09/2023.
//

import SwiftUI

struct TabBarItem: View {
    let tab: CustomTabBar.Tab
    let index: Int
    @Binding var selectedIndex: Int
    
    var body: some View {
        Button(action: {
            selectedIndex = index
        }) {
            Image(systemName: tab.rawValue)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(selectedIndex == index ? .white : .gray.opacity(0.5)) // Customize selected and unselected tab colors
                .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    ContentView()
}
